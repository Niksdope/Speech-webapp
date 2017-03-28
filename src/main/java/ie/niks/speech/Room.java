package ie.niks.speech;

import java.net.Socket;

import org.bson.types.ObjectId;

public class Room extends Thread{
	private ObjectId id;
	Socket clientSocket;
	
	Room(Socket s){
		this.clientSocket = s;
	}
	
	// Thread running
	public void run() {
		
	}
}
