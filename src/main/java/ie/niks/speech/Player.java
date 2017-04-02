package ie.niks.speech;

public class Player {
	private String equation;
	private double answer;
	private float time;
	private String id;
	
	public Player(String id){
		this.id = id;
	}
	
	public String getEquation() {
		return equation;
	}

	public void setEquation(String equation) {
		this.equation = equation;
	}

	public double getAnswer() {
		return answer;
	}

	public void setAnswer(double answer) {
		this.answer = answer;
	}

	public float getTime() {
		return time;
	}

	public void setTime(float time) {
		this.time = time;
	}

	public String getId() {
		return id;
	}
}
