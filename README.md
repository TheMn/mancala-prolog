# Mancala Game in Prolog

This project is a Prolog implementation of the Mancala board game. It was developed as a project for the Artificial Intelligence course at Guilan University in December 2018.

## About the Game

Mancala is a generic name for a family of two-player turn-based strategy board games played with small stones, beans, or seeds and rows of holes or pits in a board. Players begin by placing a certain number of seeds in each of the pits on their side of the game board. A player captures all the seeds in the opponent's pit (or hole) if the last sown seed lands in an empty pit on the player's side. The game ends when one player no longer has any seeds in any of their holes. The player with the most seeds in their store wins.

This implementation uses the "Kalah" variant of the game.

## Project Structure

The project is organized into the following files:

*   `player_SN.pl`: The main file that loads the other modules and starts the game.
*   `More/Facts.pl`: Defines the basic facts and settings of the game, such as the number of stones and the depth of the search tree for the AI.
*   `More/Rules.pl`: Implements the rules of the Mancala game.
*   `More/Minimax.pl`: Implements the minimax algorithm with alpha-beta pruning, which is used by the AI to choose its moves.
*   `LICENSE`: The license for this project.

## How to Run the Game

To run the game, you will need a Prolog interpreter, such as [SWI-Prolog](https://www.swi-prolog.org/).

1.  **Start SWI-Prolog:**
    ```bash
    swipl
    ```

2.  **Load the main file:**
    ```prolog
    ['player_SN.pl'].
    ```

3.  **Start the game:**
    To start the game, run the following query:
    ```prolog
    play(sowing).
    ```

The game will then start, and you will be prompted to make a move. The AI will play against you.

## Game Rules

The rules of the Kalah variant of Mancala implemented in this project are as follows:

1.  The game board has two rows of six holes each, and a larger store (or "Kalah") at each end.
2.  The game starts with six stones in each of the 12 holes.
3.  Players take turns "sowing" their stones. On a turn, a player chooses one of the six holes on their side of the board. The player removes all the stones from that hole and distributes them, one by one, into the following holes in a counter-clockwise direction.
4.  If the last stone is dropped into the player's own store, they get an extra turn.
5.  If the last stone is dropped into an empty hole on the player's side, and the opposite hole contains stones, the player captures all the stones in the opposite hole, plus their own last stone, and places them in their store.
6.  The game ends when one player has no more stones in any of their holes. The other player then captures all the remaining stones on their side of the board and places them in their store.
7.  The player with the most stones in their store at the end of the game is the winner.

## How the AI Works

The AI uses the minimax algorithm with alpha-beta pruning to decide which move to make. The algorithm works by building a tree of possible moves and their outcomes, and then choosing the move that leads to the best possible outcome for the AI, assuming that the opponent will also play optimally.

The `value/2` predicate in `More/Minimax.pl` is the evaluation function that determines the "goodness" of a particular board state. In this implementation, the value of a board state is simply the difference between the number of stones in the AI's store and the number of stones in the opponent's store.
