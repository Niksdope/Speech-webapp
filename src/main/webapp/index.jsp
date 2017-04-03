<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Numbers game</title>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.js"></script>
		<script src="https://code.jquery.com/jquery-3.1.1.js"></script>
		<link rel="stylesheet" href="css/styles.css">
	</head>
	<body>
	<!-- Adapted from http://stackoverflow.com/questions/396145/how-to-vertically-center-a-div-for-all-browsers -->
		<div class="outer">
			<div class="middle">
				<div class="inner">
					<a class="button" id="btnSingleplayer" href="#">Singleplayer</a>
					|
					<a class="button"  id="btnMultiplayer" href="#">Multiplayer</a>
					<p style="font-size: 30px;" id="tips">From the menu, say single player or multi player to join a game</p>
				</div>
			</div>
		</div>
			
		<script type="text/javascript">
			var tips = ["From the menu, say 'single player' or 'multi player' to join a game", "To reset your progress within a game, say 'reset'", "After a game is over, you can say 'home' to return to the menu"];
			var counter = 1;
			// Check if speech API is avaliable
			if (annyang) {
				// Define some commands for api
				var commands = {
					'single player': singlePlayer,
					'single': singlePlayer,
					'multi player': multiPlayer,
					'multi': multiPlayer
				};
	
				// Add commands to annyang
				annyang.addCommands(commands);
	
				// Start listening.
				annyang.start();
			}
			
			slideShowTips();
			setTimeout(function(){ $("#tips").fadeOut(); }, 5100);
			
			function slideShowTips(){
				setTimeout(function(){ 
					$("#tips").fadeIn();
					$("#tips").text(tips[counter]);
					
					counter++;
					if(counter >= tips.length){
						counter = 0;
					}
					
					setTimeout(function(){ $("#tips").fadeOut(); }, 5100);
					slideShowTips();
				}, 5500);
				
				
				
			}
			
			function singlePlayer(){
				console.log("Going into a singleplayer game");
				$("#btnSingleplayer").click();
			}
			
			function multiPlayer(){
				console.log("Going into a multiplayer game");
				$("#btnMultiplayer").click();
			}
			
			$("#btnMultiplayer").click(function (){
				// Make an ajax call to check if a game is made
				$.ajax({
					url: "checkLobby",
					type: "GET",
					success: function(response){
						console.log("Game id: " + response);
						window.location.assign("game.jsp?id=" + response);
					}
				});
			});
			
			$("#btnSingleplayer").click(function (){
				// Make an ajax call to check if a game is made
				window.location.assign("game.jsp");
			});
		</script>
	</body>
</html>