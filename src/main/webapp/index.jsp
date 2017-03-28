<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Numbers Game</title>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.js"></script>
		<script
  src="https://code.jquery.com/jquery-3.1.1.js"
  integrity="sha256-16cdPddA6VdVInumRGo6IbivbERE8p7CQR3HzTBuELA="
  crossorigin="anonymous"></script>
  		<link rel="stylesheet" href="css/styles.css"></link>
	</head>
	<body>
		<h4 id="status"></h4>
		<div class="chalkboard">
			<h1 id="target"></h1>
			<h2 id="randomNums"></h2>
			<h3 id="answer"></h3>
		</div>
		<script type="text/javascript">
			$(document).ready(function() {
			    init();
			});
		
			var targetNumber;
			var randomNumbers = [];
			
			if (annyang) {
				// Let's define a command.
				var commands = {
					'answer *tag': calculateAnswer
				};

				// Add our commands to annyang
				annyang.addCommands(commands);

				// Debug
				/* annyang.addCallback('result', function(phrases) {
				  console.log("Sounds to me like the user said: ", phrases);
				}); */

				// Start listening.
				annyang.start();

				function calculateAnswer(tag){
					console.log(tag);
					
					var strings = tag.split(" ");
					console.log(strings);
					
					// Do some error checking to make sure we are evaluating the right expression
					for (var i = 0; i < strings.length; i++){
						switch(strings[i]){
							case "plus":
								strings[i] = "+";
								break;s
							case "minus":
								strings[i] = "-";
								break;
							case "by":
							case "buy":
							case "x":
								strings[i] = "*"
								break;
							case "to":
								strings[i] = "2";
								break;
							case "for":
								strings[i] = "4";
								break;
							case "divided":
							case "divide":
								strings[i] = "/";
								if (strings[i+1] === "by")
									strings.splice(i+1, 1);
								break;
							case "multiplied":
							case "multiply":
								strings[i] = "*";
								if (strings[i+1] === "by")
									strings.splice(i+1, 1);
								break;
						}
					}
					
					if(strings % 2 != 0){
						var answer = eval(strings.join(" "));
						for (var i = 0; i<strings.length; i++){
							$("#answer").append(strings[i] + " ");
						}
						
						$("#answer").append("= " + answer);
					}
				}
			}
			
			function init(){
				targetNumber = Math.floor((Math.random() * 1000) + 101);
				var possibleNumbers = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100];
				
				for(var i = 0; i < 6; i++){
					var rand = Math.floor(Math.random() * possibleNumbers.length);
					randomNumbers.push(possibleNumbers[rand]);
					possibleNumbers.splice(rand, 1);
				}
				
				$("#target").text(targetNumber);
				$("#randomNums").text(randomNumbers);
			}
		</script>
	</body>
</html>