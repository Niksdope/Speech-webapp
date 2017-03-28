package ie.niks.speech;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.enterprise.context.ApplicationScoped;
import javax.json.JsonObject;
import javax.websocket.Session;

@ApplicationScoped
public class RoomHandler {
	private final Set<Session> sessions = new HashSet<Session>();
    private final Set<Player> devices = new HashSet<Player>();
    
    public void addSession(Session session) {
        sessions.add(session);
    }

    public void removeSession(Session session) {
        sessions.remove(session);
    }
    
    public List<Player> getPlayers() {
        return new ArrayList<Player>(devices);
    }

    public void addDevice(Player device) {
    	
    }

    public void removePlayer(int id) {
    	
    }

    private JsonObject createAddMessage(Player device) {
        return null;
    }

    private void sendToAllConnectedSessions(JsonObject message) {
    }

    private void sendToSession(Session session, JsonObject message) {
    }
}
