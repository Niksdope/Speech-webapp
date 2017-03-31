package ie.niks.speech;

import java.util.ArrayList;
import java.util.List;

public class Game{
	private String id;
	private List<Player> players = new ArrayList<Player>();
	private boolean full;
	
	public Game(String id, List<Player> players){
		this.id = id;
		this.players = players;
	}
	
	public String getId() {
		return id;
	}

	public boolean isFull() {
		return full;
	}

	public void addPlayer(Player p){
		if(players.size() == 1){
			this.players.add(p);
			full = true;
		}
	}
}
