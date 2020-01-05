# Minesweeper
A simple minesweeper game implemented in Julia using a bit of OOP.

## Features:
- Uses OOP (Object Oriented Programming)
- Checks and asks for valid user input at every step
- Code is commented
- Allows users to replay at the end of the game
- Custom grid sizes!
- Allows user to flag certain cells to help while playing

## Demo
I have made a video showing a playthrough of the game here: https://youtu.be/yTB0-xnQN8M

[![https://youtu.be/yTB0-xnQN8M](https://img.youtube.com/vi/yTB0-xnQN8M/0.jpg)](https://www.youtube.com/watch?v=yTB0-xnQN8M)

#### Timestamps if you don't want to get bored for 7 and half minutes:
0:00 to 1:04: 8x8 easy mode demo

1:04 to 1:11: replay demo

1:11 to 6:55: 16x16 hard mode demo (I actually win this one!)

7:04 to 7:30: custom mode demo

7:30 to 7:33: don't replay demo

## How to Play
Look up the instructions here: https://en.wikipedia.org/wiki/Minesweeper_(video_game)

- To mine a cell in the `i`th row and `j`th column, the command is:
`m i j`

- To flag a cell in the `i`th row and `j`th column, the command is:
`f i j`

- To exit, the command is:
`exit foo bar`

**Note:** `foo` and `bar` can be anything: `String`s, random `Integers`, anything.

## What do all these weird symbols mean?
- `•` denotes a mine
- `!` denotes a flag
- `�` denotes a uncovered tile or cell.
- `1` or `2` or `3`... denote the number of immediate mine neighbours a tile has.

## Why?
Why not?
