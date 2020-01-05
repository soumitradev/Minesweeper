# Use the object Tile and other functions for Tiles.
include("Tile.jl")

# Create function to get user input and recursively validate the user input
function get_input(text_to_print, in_same_line, allowed_options, required_params)

    # If we want to print on the same line, use `print()`. Else, `use println()`
    in_same_line ? print(text_to_print) : println(text_to_print)

    # Get input and split it into n array
    txtin = split(lowercase(readline()));

    # If the required amount of parameters is not met or if the command is not in the list of allowed options,
    # ask for input again
    if length(txtin) < required_params || !(txtin[1] in allowed_options)
        println("Please enter a valid command (see README)")
        get_input(text_to_print, in_same_line, allowed_options, required_params)
    else
        # If input is valid, return the input as a string.
        return join(txtin, " ")
    end
end

# Ask if user wants to play again
function play_again()

    ans = get_input("Play again? (y/n): ", true, ["y", "n"], 1)

    # If user wants to play again, run the game again. Else, exit()
    if ans == "y"
        run(`julia $PROGRAM_FILE`)
        exit()
    else
        exit()
    end
end

# Print the current game state
function print_board(board)

    # Gets basic variables required to iterate over array
    rows = length(board)
    cols = length(board[1])
    arr = []

    # If number in column label is more than one digit, just print 1 space instead of 2 so
    # that grid is aligned.
    for num in 1:cols
        n_spaces = num > 9 ? " " : "  "
        push!(arr, num, n_spaces)
    end

    # Join the column labels
    labels_cols = join(arr)

    # Print the column labels
    println("   | "*labels_cols)
    println("___|"*join(["_" for x in 1:length(labels_cols)]))

    # For each row, print the row labels such that the digits align properly by using spaces
    for i in 1:rows
        boxes = join([to_string(board[i][x]) for x in 1:cols], "  ")
        if length("$i") < 2
            println("$i  | "*boxes)
        else
            println("$i | "*boxes)
        end
    end
end

# If a tile is hit and it has 0 mine neighbours, then expose itself, and non-mine neighbours recursively.
function flood_fill(board, cell)
    # Iterate over all the cells to its left-top diagonal neighbour to its right-bottom diagonal neighbour.
    for x_offset in -1:1
        for y_offset in -1:1
            # Get absolute index of the current cell instead of relative index
            i = cell.x + x_offset
            j = cell.y + y_offset

            # If cell exists in the grid (the left-top corner makes the function check outside the array)
            if (i in 1:length(board)) && (j in 1:length(board[1]))
                neighbour = board[i][j]

                # If the tile is not a mine and is not shown, show it.
                # show() also calls flood_fill() if its neighbour has 0 mine neighbours, making this recursive
                if (!(neighbour.is_mine) && !neighbour.shown)
                    show(board, neighbour)
                end
            end
        end
    end
end

# Show a tile, and call flood_fill() if required.
function show(board, tile)
    tile.shown = true

    # If tile has 0 mine-neighbours, call flood_fill() on it so it exposes the required neighbours
    if tile.num_mines == 0
        flood_fill(board, tile)
    end
end

# If game is over, show the leftover mines.
function game_over(board, mine_pos_arr)
    for pos in mine_pos_arr
        (board[pos[1]][pos[2]]).shown = true
    end
end

# Create board at the start of the game
function init_board(r, c, n)

    # Create an array with r rows. We will insert our cells in an array here.
    board = Array{Any}(nothing, r)

    # Initialize an array that holds the positions of the mines.
    mine_pos_arr = []

    # Initialize a flat array with all possible positions
    options = [[(x, y) for x in 1:r, y in 1:c]...]

    # For every mine, pick up a random position in all possible positions, and remove it 
    # from the possible positions so the other mines can not be placed in the same place
    # accidentally.
    for mine_pos in 1:n
        x = rand(1:length(options))
        push!(mine_pos_arr, options[x])
        deleteat!(options, x)
    end

    # For every row, create an array of cells, and place the array in its corresponding row.
    for i in 1:r
        temp = []
        for j in 1:c
            tile_mine = (i, j) in mine_pos_arr ? true : false
            push!(temp, Tile(false, tile_mine, i, j, 0, false))
        end
        board[i] = temp
    end

    # Count the number of mine neighbours for each cell.
    # If the cell is a mine, it is set to -1.
    for i in 1:r
        for j in 1:c
            count_neighbours(board, board[i][j])
        end
    end

    # Return game info
    return [board, options, mine_pos_arr]
end

# Print the difficulty selector of the game
function start_game()
    difficulty = """
    Select difficulty:
    - `easy`: 8x8 grid, with 9 mines
    - `medium`: 16x16 grid, with 20 mines (fullscreen recommended)
    - `custom`: You specify the parameters!
    """
    diff_seleted = get_input(difficulty, true, ["easy", "medium", "custom"], 1)

    # Based on the selected difficulty, initialize game.
    if diff_seleted == "easy"
        board = init_board(8, 8, 9)
        return board
    elseif diff_seleted == "medium"
        board = init_board(16, 16, 20)
        return board
    else
        params = get_input("Enter the number of rows, columns and mines seperated by spaces (1-99): ", true, [1:99...], 3)
        board = init_board(params[1], params[2], params[3])
        return board
    end
end

# Validate a flag or mine command, ancd check if the input is inside bounds.
function validate_command(board, input)
    if (parse(Int, input[2]) > length(board)) || (parse(Int, input[3]) > length(board[1]))
        return false
    else
        return true
    end
end

# Beginning of game, print the welcome message.
println("Welcome to Minesweeper! Please have a look at the README before playing. Enjoy!")

# Get game info by initializing grid, and mines
game = start_game()

# Save info for game-result validation.
grid = game[1]
options = game[2]
mine_pos_arr = game[3]

# Print the starting state of game
print_board(grid)

# Get input at every step using a while true loop, and breaking out of loop on game end.
while true
    # Get command and parameters
    txt = split(get_input("Enter your command: ", true, ["f", "m", "exit"], 3))

    # If the user wishes to mine, and the parameters are valid, mine that cell.
    if txt[1] == "m" && (validate_command(grid, txt))

        # If the mined cell is a mine, game over.
        if (grid[parse(Int, txt[2])][parse(Int, txt[3])]).is_mine == true
            game_over(grid, mine_pos_arr)
            print_board(grid)
            println("You lose. Better luck next time!")
            break
        end

        # Show the cell the user clicked on, and show the updated state
        show(grid, grid[parse(Int, txt[2])][parse(Int, txt[3])])
        print_board(grid)

        # Check win
        win = true

        # If all non-mine locations are shown, then user wins
        for pos in setdiff(options, mine_pos_arr)
            if (grid[pos[1]][pos[2]]).shown == false
                win = false
                break
            end
        end

        # If user wins, print win message.
        if (win)
            println("Congratulations, you win!")
            break
        # If user hasn't won yet, advance to next loop.
        else
            continue
        end

    # If the user wishes to flag and parameters are valid, flag the cell
    elseif txt[1] == "f"  && (validate_command(grid, txt))

        (grid[parse(Int, txt[2])][parse(Int, txt[3])]).is_flagged = true

        # After flagging, print updated game state
        print_board(grid)

    # If command is to exit, exit game.
    elseif txt[1] == "exit"
        exit()
    # If command is invalid (out of bounds), ask user to type command again
    else
        println("Please enter valid cell coordinates.")
    end
end

# On end of game, ank if user wants to play again.
play_again()