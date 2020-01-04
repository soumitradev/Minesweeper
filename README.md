# Minesweeper
A simple minesweeper game implemented in Julia using a bit of OOP.

## Features:
- Uses OOP (Object Oriented Programming)
- Checks and asks for valid user input at every step
- Code is commented
- Allows users to replay at the end of the game
- Custom grid sizes!
- Allows user to flag certain cells to help while playing

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
