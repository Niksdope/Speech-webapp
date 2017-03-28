package ie.niks.speech;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ApplicationScoped
@ServerEndpoint("/actions")
public class Manager {
	@Inject
    private RoomHandler sessionHandler;
	
    @OnOpen
    public void open(Session session) {
    	// Check for sessions, if there is any, add player to one. Else create one and wait.
    	sessionHandler.addSession(session);
    }

    @OnClose
    public void close(Session session) {
    	// If game is over, just remove player from session. Else, broadcast message to opponent that the other player left.
    	sessionHandler.removeSession(session);
    }

    @OnError
    public void onError(Throwable error) {
    	
    }

    @OnMessage
    public void handleMessage(String message, Session session) {
    	// Messages should be sent from both players when the game is over. 
    	
    	/*try (JsonReader reader = Json.createReader(new StringReader(message))) {
            JsonObject jsonMessage = reader.readObject();

            if ("add".equals(jsonMessage.getString("action"))) {
                Device device = new Device();
                device.setName(jsonMessage.getString("name"));
                device.setDescription(jsonMessage.getString("description"));
                device.setType(jsonMessage.getString("type"));
                device.setStatus("Off");
                sessionHandler.addDevice(device);
            }

            if ("remove".equals(jsonMessage.getString("action"))) {
                int id = (int) jsonMessage.getInt("id");
                sessionHandler.removeDevice(id);
            }

            if ("toggle".equals(jsonMessage.getString("action"))) {
                int id = (int) jsonMessage.getInt("id");
                sessionHandler.toggleDevice(id);
            }
        }*/
    }
}    
