# Speech-webapp
Multiplayer and Singleplayer numbers game using a speech api

## What's the game?
The numbers game is modelled after the Countdown numbers game on Channel 4. 
As the game starts, the application generates a random number between 101 and 999 which will be the target number. The app also generates 6 random numbers from the following list:

```
{1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100}
```

The goal of the game is to use the 6 given numbers in an equation to get the target number(or as close to it as possible) as quickly as possible. The numbers on the list can only be used once.