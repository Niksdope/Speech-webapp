package ie.niks.speech;

import java.util.ArrayList;
import java.util.List;

public class Game{
	private String id;
	private List<Player> players = new ArrayList<Player>();
	private int targetNumber = 0;
	private int closestAnswer = 0;
	private String bestEquation = "";
	private String bestUser = "";
	private boolean full = false;
	private boolean finished = false;
	private int answers = 0;

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
	
	public String getPlayers(){
		return Integer.toString(players.size());
	}
	
	public int getTargetNumber() {
		return targetNumber;
	}

	public void setTargetNumber(int targetNumber) {
		this.targetNumber = targetNumber;
	}

	public int getClosestAnswer() {
		return closestAnswer;
	}

	public void setClosestAnswer(int closestAnswer) {
		this.closestAnswer = closestAnswer;
	}
	
	public void setFinished(boolean finished) {
		this.finished = finished;
	}

	public boolean isFinished() {
		return finished;
	}
	
	public int incrementAnswers(){
		answers++;
		return answers;
	}
	
	public String getBestEquation() {
		return bestEquation;
	}

	public void setBestEquation(String bestEquation) {
		this.bestEquation = bestEquation;
	}

	public String getBestUser() {
		return bestUser;
	}

	public void setBestUser(String bestUser) {
		this.bestUser = bestUser;
	}
}
