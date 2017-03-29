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
			<h1 id="randomNums"></h1>
			<h2 id="answer"></h2>
		</div>
		<script type="text/javascript">
			$(document).ready(function() {
			    init();
			});
		
			var targetNumber;
			var randomNumbers = [];
			var randomNumbersBackup = [];
			
			if (annyang) {
				// Let's define a command.
				var commands = {
					'restart': restart,
					'reset': restart,
					'*tag': calculateAnswer
					
				};

				// Add our commands to annyang
				annyang.addCommands(commands);

				// Start listening.
				annyang.start();

			}
			
			function init(){
				targetNumber = Math.floor(Math.random() * 899) + 101;
				var possibleNumbers = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100];
				
				for(var i = 0; i < 6; i++){
					var rand = Math.floor(Math.random() * possibleNumbers.length);
					randomNumbers.push(possibleNumbers[rand]);
					possibleNumbers.splice(rand, 1);
				}
				
				randomNumbersBackup = randomNumbers;
				
				$("#target").text(targetNumber);
				$("#randomNums").text(randomNumbers);
			}
			
			function isNumber(string){
			    return $.isNumeric(string)
			}
			
			function calculateAnswer(tag){
					var invalidExpression = false;
					
					var strings = tag.split(" ");
					console.log(strings);
					
					// Do some error checking to make sure we are evaluating the right expression
					for (var i = 0; i < strings.length; i++){
						var bracket = 0;
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
					// Good chance the user was saying out an equation, not random words, if the first word is a number
					if(isNumber(strings[0])){
						// An equation should always be odd in terms of string[].length. E.g. The valid expression 1 + 2 * 5 = ["1", "+", "2", "*", "5"].length = 5;
						// Likewise, since we only have 6 random numbers to use, we know the max length of an equation would be 11.
						if(strings % 2 != 0 && strings.length <= 11){
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
									break;
								}
							}
							
							if (!invalidExpression){
								
								try {
									var answer = eval(strings.join(" "));
								}
								catch(err) {
								    console.log(err);
								}
								// For loop to print out each part of the answer on the screen.
								for (var i = 0; i < strings.length; i++){
									$("#answer").append(strings[i] + " ");
								}
								
								$("#answer").append("= " + answer + "\n");
								
								if (randomNumbers.length > 0){
									randomNumbers.push(answer);
								}
								
								$("#randomNums").text(randomNumbers);
							}else{
								// Reset what numbers were removed and print error message
								randomNumbers = randomNumbersBackup;
								console.log("Numbers other than the ones given were used.");
							}
						}
					}
				}
			
				function restart(){
					console.log("Resetting numbers");
					randomNumbers = randomNumbersBackup;
					$("#randomNums").text(randomNumbers);
					$("#answer").text("");
				}
		</script>
	</body>
</html>