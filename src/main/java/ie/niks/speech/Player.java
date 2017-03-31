package ie.niks.speech;

public class Player {
	private String equation;
	private double answer;
	private float time;
	private String ip;
	
	public Player(String ip){
		this.ip = ip;
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

	public String getIp() {
		return ip;
	}
}
