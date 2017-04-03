package ie.niks.speech;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.bson.types.ObjectId;

@ServerEndpoint(value = "/game/{id}")
public class Manager {
	static Map<String, Game> games = Games.getGamesInstance();
	static Map<String, Session> openGames = new HashMap<String, Session>();
	
    @OnOpen
    public void open(Session session, @PathParam("id")String id) throws IOException{
    	// Store id in Session
    	System.out.println(id);
    	if(games.containsKey(id)){
    		session.getUserProperties().put("id", id);
    		
    		String userId = new ObjectId().toString();
    		session.getUserProperties().put("userId", userId);
    	    openGames.put(String.valueOf(session.getId()), session);
    	    
    	    // Send how many players are connected, and the users unique id.
    	    session.getBasicRemote().sendText(games.get(id).getPlayers() + " " + userId);
    	}else{
    		close(session);
    	}
    }

    @OnClose
    public void close(Session session) {
    	// If game is over, just remove player from session. Else, broadcast message to opponent that the other player left.
    	//String id = session.getId();
    	openGames.remove(session.getId());
    	/*for (Map.Entry<String, Session> entry : openGames.entrySet()) {
    	    Session s = entry.getValue();
    	    if(s.getId() )
    	}
    	games.get(session.getId()).ge*/
    }

    @OnError
    public void onError(Throwable error) {
    	System.out.println(error);
    }

    @OnMessage
    public void handleMessage(String message, Session session, @PathParam("id")String id) throws IOException {
    	System.out.println(message);
    	
    	if(message.startsWith("ready")){
    		// Check if session corresponds to the game id 
        	for (Map.Entry<String, Session> entry : openGames.entrySet()) {
        	    Session s = entry.getValue();
        	    if (s.isOpen() && s.getUserProperties().get("id").equals(id)) {
        	    	String[] numbers = message.split(" ");
        	    	games.get(id).setTargetNumber(Integer.parseInt(numbers[1]));
        	    	s.getBasicRemote().sendText("ready "+ numbers[1] + " " + numbers[2] + " " + numbers[3] + " " + numbers[4] + " " + numbers[5] + " " + numbers[6] + " " + numbers[6]);
        	    }
        	}
    	}else if(message.startsWith("answer")){
    		// Compare answers and return the best one to both
    		for (Map.Entry<String, Session> entry : openGames.entrySet()) {
        	    Session s = entry.getValue();
        	    if (s.isOpen() && s.getUserProperties().get("id").equals(id)) {
        	    	String[] numbers = message.split(" ");
        	    	if(games.get(id).incrementAnswers() == 2){
        	    		String msg = "";
        	    		
        	    		if(Integer.parseInt(numbers[2]) > games.get(id).getClosestAnswer()){
        	    			
        	    			games.get(id).setClosestAnswer(Integer.parseInt(numbers[2]));
        	    			String equation = "";
        	    			for(int i = 3; i < numbers.length; i++){
        	    				equation += numbers[i] + " ";
        	    			}
        	    			
        	    			games.get(id).setBestUser(numbers[1]);
        	    			games.get(id).setBestEquation(equation);
        	    			msg = "result "+ numbers[1] + " " + numbers[2] + " " + equation;
        	    			sendAnswerToUsers(msg, session, id);
        	    		}else if(Integer.parseInt(numbers[2]) == games.get(id).getClosestAnswer()){
        	    			System.out.println(numbers[2] + games.get(id).getClosestAnswer());
        	    			
        	    			msg = "result draw";
        	    			sendAnswerToUsers(msg, session, id);
        	    		}else{
        	    			msg = "result "+ games.get(id).getBestUser() + " " + games.get(id).getClosestAnswer() + " " + games.get(id).getBestEquation();
        	    			sendAnswerToUsers(msg, session, id);
        	    		}
        	    	}else{
        	    		if(Integer.parseInt(numbers[2]) >= games.get(id).getClosestAnswer()){
        	    			games.get(id).setClosestAnswer(Integer.parseInt(numbers[2]));
        	    			System.out.println("Setting closestAnswer to: " + numbers[2]);
        	    			
        	    			String equation = "";
        	    			for(int i = 3; i < numbers.length; i++){
        	    				equation += numbers[i] + " ";
        	    			}
        	    			
        	    			games.get(id).setBestEquation(equation);
        	    			games.get(id).setBestUser(numbers[1]);
        	    		}
        	    	}
        	    }
        	}
    	}
    }
    
    private void sendAnswerToUsers(String message, Session session, String id) throws IOException{
    	for (Map.Entry<String, Session> entry : openGames.entrySet()) {
    	    Session s = entry.getValue();
    	    if (s.isOpen() && s.getUserProperties().get("id").equals(id)) {
    	    	s.getBasicRemote().sendText(message);
    	    }
    	}
    }
}    
