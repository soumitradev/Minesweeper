include("Tile.jl")

grid = Array{Any}(nothing, 8)
mine_pos_arr = []

for mine_pos in 1:9
    x = floor(8*rand())+1
    y = floor(8*rand())+1
    push!(mine_pos_arr, (x, y))
end

for i in 1:8
    temp = []
    for j in 1:8
        tile_mine = (i, j) in mine_pos_arr ? true : false
        push!(temp, Tile(false, tile_mine, i, j))
    end
    grid[i] = temp
end

function print_board(board)
    rows = length(board)
    cols = length(board[1])

    labels_cols = join(collect(1:cols), "  ")
    println("   | "*labels_cols)
    println("___|_"*join(["_" for x in 1:length(labels_cols)]))
    for i in 1:rows
        boxes = join([to_string(board[i][x]) for x in 1:cols], "  ")
        if length("$i") < 2
            println("$i  | "*boxes)
        else
            println("$i | "*boxes)
        end
    end
end

function get_input(text_to_print, in_same_line)
    in_same_line ? print(text_to_print) : println(text_to_print)
    txtin = split(lowercase(readline()));
    if length(txtin) < 3
        println("Please enter a valid command (see manual/README)")
        get_input(text_to_print, in_same_line)
    else
        return join(txtin, " ")
    end
end

print_board(grid)
while true
    txt = split(get_input("command: ", true))
    if txt[1] == "m"
        (grid[parse(Int, txt[2])][parse(Int, txt[3])]).shown = true
        print_board(grid)
    else
        break
    end
end