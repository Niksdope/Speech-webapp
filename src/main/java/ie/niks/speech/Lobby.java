package ie.niks.speech;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bson.types.ObjectId;

public class Lobby extends HttpServlet{
	private static final long serialVersionUID = 777L;
	
	private static Map<String,Game> games = Games.getGamesInstance();
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		List<String> openGames = new ArrayList<String>();
		
		for (Map.Entry<String,Game> entry : games.entrySet()){
			if(!entry.getValue().isFull()){
				openGames.add(entry.getKey());
			}
		}
		
		// Get user IP from the HTTP request
		String userId = new ObjectId().toString();
		
		if(openGames.size() > 0){
			// If a room exists, return the room ID so the player can connect to it
			Player p = new Player(userId);
			games.get(openGames.get(0)).addPlayer(p);
			
			resp.getWriter().write(openGames.get(0));
		}else{
			// Else create a room and add the current player in the set of unique players, and return the id of the room for the user to connect to
			
			// 1. Generate an BSON ObjectId to be the room id
			String id = new ObjectId().toString();
			
			// 2. Create a Player object and add it to a player list
			Player p = new Player(userId);
			List<Player> players = new ArrayList<Player>();
			players.add(p);
			
			// 3. Create a Game object and populate it with the id and players list
			Game g = new Game(id, players);
			
			// 4. Add the <id, game> entry to the map
			games.put(id, g);
			
			// 5. Return the id of the room to the player
			resp.getWriter().write(id);
		}
		
		System.out.println(openGames.size());
	}
}
