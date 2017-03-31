<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Numbers Game</title>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.js"></script>
		<script src="https://code.jquery.com/jquery-3.1.1.js"></script>
  		<script src="https://cdnjs.cloudflare.com/ajax/libs/flipclock/0.7.8/flipclock.js"></script>
  		<link rel="stylesheet" href="css/flipclock.css"></link>
  		<link rel="stylesheet" href="css/styles.css"></link>
	</head>
	<body>
		<div id="game">
			<div class="timer"></div>
			<div class="gameBoard">
				<h1 id="target"></h1>
				<h1 id="randomNums"></h1>
				<h3 id="answer"></h3>
			</div>
		</div>
		
		<div class="gameBoard" id="scoreCard">
			<h2 id="title"></h2>
			<h2 id="distance"></h2>
			<p id="equation"></p>
		</div>
		<script type="text/javascript">
			// As the DOM of the page is ready, initialize all variables and start the game (The timer starts ticking)
			$(document).ready(function() {
			    init();
			});
			
			// Instance variables
			var clock;
			var targetNumber;
			var randomNumbers = [];
			var randomNumbersBackup = [];
			var bestEquation = "";
			var closestAnswer = 0;
			
			// Multiplayer only variables
			var multiplayer = false;
			var gameId;
			var ws;
			
			// Create an audio object for the timer music
			var sound = document.createElement("audio");
			sound.src="./audio/Countdown.mp3";
			sound.volume=0.01;
			
			// Check if speech API is avaliable
			if (annyang) {
				// Define some commands for api
				var commands = {
					'restart': restart,
					'reset': restart,
					'*tag': calculateAnswer
					
				};

				// Add commands to annyang
				annyang.addCommands(commands);

				// Start listening.
				annyang.start();
			}
			
			function init(){
				gameId = getURLParameter("id");
				
				if(gameId != null){
					multiplayer = true;
				}
				
				// Create a random target number
				targetNumber = Math.floor(Math.random() * 899) + 101;
				var possibleNumbers = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100];
				
				// Create 6 random numbers out of possibleNumbers list
				for(var i = 0; i < 6; i++){
					var rand = Math.floor(Math.random() * possibleNumbers.length);
					randomNumbers.push(possibleNumbers[rand]);
					possibleNumbers.splice(rand, 1);
				}
				
				// Make a backup of randomNumbers (for reset)
				randomNumbersBackup = randomNumbers.slice(0);
				
				if(multiplayer){
					// Upgrade connection to a websocket
					(function(ws) {
					    "use strict";
					    if (window.WebSocket) {      
					        console.log("WebSockets supported by browser. Hooray!");
					        ws = new WebSocket("ws://localhost:8080/speech/game/" + gameId);   
					        ws.onopen = function() {
					            console.log("TCP connection established with server");
					        };    
					        ws.onmessage = function(e) {
					        	// Switch here to check parse the incoming messages the right way
					            console.log(e.data);  
					        };
					        ws.onclose = function() {   
					        	console.log("TCP connection with server closed");
					        };
					        ws.onerror = function() {
					        	console.log("Websocket error");  
					        };
					
					    } else {
					        console.log("WebSockets not supported by browser. Returning to home page.");
					        setTimeout(function(){ window.location.assing("index.jsp"); }, 3000);
					    }
					})(ws);
				}else{
					// Print everything to screen
					$("#target").text(targetNumber);
					printRandomNumbers();
	
					// Start the timer and play the music
					clock = $('.timer').FlipClock(30, {
						clockFace: 'Counter',
						countdown: true,
						autoStart: true,
						
						callbacks: {
				        	stop: function() {
				        		console.log("Time's up! Let's see how you did..");
				        		finish();
				        	}
				        }
					});
					
					sound.play();
				}
			}
			
			function isNumber(string){
			    return $.isNumeric(string)
			}
			
			function differenceTarget(number){
				if(number > targetNumber){
					return number - targetNumber;
				}else{
					return targetNumber - number;
				}
			}
			
			function calculateAnswer(tag){
				var invalidExpression = false;
				
				var strings = tag.split(" ");
				console.log(strings);
				
				// Check if the strings need changing to make the equation evaluateable
				strings = checkEquation(strings);
				
				// Good chance the user was saying out an equation, not random words, if the first word is a number
				if(isNumber(strings[0])){
					// An equation should always be odd in terms of string[].length. E.g. The valid expression 1 + 2 * 5 = ["1", "+", "2", "*", "5"].length = 5;
					// Likewise, since we only have 6 random numbers to use, we know the max length of an equation would be 11.
					if(strings % 2 != 0 && strings.length <= 11){
						var temp = randomNumbers.slice(0);
						
						// Check the numbers that are used in the equation. If they are valid numbers from the randomNumbers list, calculate the 
						for(var j = 0; j < strings.length; j+=2){
							// Check if the number from equation is in the randomNumbers array, if it is, remove it
							var index = $.inArray(Number(strings[j]), randomNumbers);
							console.log(strings[j]);
							console.log(index);
							if (index >= 0){
								randomNumbers.splice(index, 1);
								console.log(randomNumbers);
							}else{
								invalidExpression = true;
								randomNumbers = temp.slice(0);
								break;
							}
						}
						
						if (!invalidExpression){
							try {
								var answer = eval(strings.join(" "));
								
								if(answer % 1 != 0){
									// If answer has decimal points, round the answer to make life easier for everyone
									answer = Math.round(answer);
								}
								
								if (differenceTarget(answer) < differenceTarget(closestAnswer)){
									closestAnswer = answer;
									bestEquation = $("#answer").text();
								}
							}
							catch(err) {
							    console.log("Problem evaluating equation. Please try again!");
							}
							// For loop to print out each part of the answer on the screen.
							for (var i = 0; i < strings.length; i++){
								$("#answer").append(strings[i] + " ");
							}
							
							$("#answer").append("= " + answer + "\n<br/>");
			
							if (randomNumbers.length > 0){
								randomNumbers.push(answer);
							}
							
							if (answer == targetNumber){
								finish();
							}
							
							printRandomNumbers(); // Update the random numbers list to represent that some have been used
						}else{
							// Reset what numbers were removed and print error message
							randomNumbers = randomNumbersBackup;
							console.log("Numbers other than the ones given were used.");
						}
					}
				}
			}
		
			function checkEquation(strings){
				// Do some error checking to make sure we are evaluating the right expression
				for (var i = 0; i < strings.length; i++){
					switch(strings[i]){
						case "one":
							strings[i] = "1";
						case "to":
						case "two":
							strings[i] = "2";
							break;
						case "three":
							strings[i] = "3";
							break;	
						case "for":
						case "four":
							strings[i] = "4";
							break;
						case "five":
							strings[i] = "5";
							break;
						case "six":
							strings[i] = "6";
							break;
						case "seven":
							strings[i] = "7";
							break;
						case "eight":
							strings[i] = "8";
							break;
						case "nine":
							strings[i] = "9";
							break;
						case "ten":
							strings[i] = "4";
							break;
						case "divided":
						case "divide":
						case "÷":
							strings[i] = "/";
							if (strings[i+1] === "by")
								strings.splice(i+1, 1);
							break;
						case "by":
						case "buy":
						case "x":
						case "multiplied":
						case "multiply":
							strings[i] = "*";
							if (strings[i+1] === "by")
								strings.splice(i+1, 1);
							break;
						case "plus":
							strings[i] = "+";
							break;s
						case "minus":
							strings[i] = "-";
							break;
						case "open":
							strings[i] = "(";
							if (strings[i+1] === "parenthesis" || strings[i+1] === "bracket")
								strings.splice(i+1, 1);
							break;
						case "close":
						case "closed":
							strings[i] = ")";
							if (strings[i+1] === "parenthesis" || strings[i+1] === "bracket")
								strings.splice(i+1, 1);
							break;
					}
				}
				
				return strings;
			}
		
			function restart(){
				console.log("Resetting numbers");
				randomNumbers = randomNumbersBackup.slice(0);
				printRandomNumbers();
				$("#answer").text("");
			}
			
			function finish(){
				//var timeLeft = clock.getFaceValue();
				console.log("You were " + differenceTarget(closestAnswer) + " from the target number.");
				console.log(bestEquation);
				
				// Hide the game and display the score card
				$("#game").hide();
				
				if(multiplayer){
					
				}else{
					if(closestAnswer == targetNumber){
						$("#title").text("Congratulations! You managed to get the target number");
						$("#equation").text("Here's how you did it </br>" + bestEquation);
					}else{
						$("#title").text("Nice try! You'll get the target next time");
						$("#distance").text("You were " + differenceTarget(closestAnswer) + " from the target number");
						$("#equation").append("Here's how you did it: \n</br>" + bestEquation);
					}
				}

				$("#scoreCard").show();
				
				// Add the commands to go back to home page from end game screen
				var returnCommand = {
						'return': home,
						'home': home,
						'back': home
				};

				// Remove existing commands and add the new commands to annyang
				annyang.removeCommands();
				annyang.addCommands(commands);
			}
			
			function home(){
				window.location.assign("index.jsp");
			}
			
			function printRandomNumbers(){
				$("#randomNums").text("");
				
				for (var i = 0; i<randomNumbers.length;i++){
					$("#randomNums").append(randomNumbers[i] + "   ");
				}
			}
			
			// Found here: http://stackoverflow.com/questions/11582512/how-to-get-url-parameters-with-javascript/11582513#11582513
			function getURLParameter(name) {
				return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
			}
		</script>
	</body>
</html>