package ie.niks.speech;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Singleton;

@Singleton
public class Games {
	private static Map<String, Game> games = new HashMap<String, Game>();
	
	protected Games(){
		
	}
	
	public static Map<String, Game> getGamesInstance(){
		return games;
	}
}
