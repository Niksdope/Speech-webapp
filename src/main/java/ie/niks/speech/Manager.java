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

@ServerEndpoint(value = "/game/{id}")
public class Manager {
	static Map<String, Game> games = Games.getGamesInstance();
	static Map<String, Session> openGames = new HashMap<String, Session>();
	
    @OnOpen
    public void open(Session session, @PathParam("id")String id) throws IOException{
    	// Store id in Session
    	System.out.println(id);
	    session.getUserProperties().put("id", id);
	    openGames.put(String.valueOf(session.getId()), session);
	    
	    session.getBasicRemote().sendText("Welcome");
    }

    @OnClose
    public void close(Session session) {
    	// If game is over, just remove player from session. Else, broadcast message to opponent that the other player left.
    	openGames.remove(session.getId());
    }

    @OnError
    public void onError(Throwable error) {
    	System.out.println(error);
    }

    @OnMessage
    public void handleMessage(String message, Session session, @PathParam("id")String id) {
    	// Check if session corresponds to the game id 
    	for (Map.Entry<String, Session> entry : openGames.entrySet()) {
    	    Session s = entry.getValue();
    	    if (s.isOpen() && s.getUserProperties().get("id").equals(id)) {
    	    	
    	    }
    	}
    }
}    
