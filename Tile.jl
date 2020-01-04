# Create a Tile object with position, number of mine neighbours, and states describing
# if tile: is flagged, is shown and if is a mine.
mutable struct Tile
    shown::Bool
    is_mine::Bool
    x::Int
    y::Int
    num_mines::Int
    is_flagged::Bool
end

# Return the string to show on screen based on current state of cell
function to_string(tile)
    # If tile is shown, return the corresponding character
    if tile.shown
        if tile.is_mine == true
            return "•"
        else
            return tile.num_mines
        end

    # If tile is not shown but is flagged, show a flag. Else, show a box with a question mark.
    elseif tile.is_flagged
        return "!"
    else
        return "�"
    end
end

# Count the number of mine neighbours for a tile.
function count_neighbours(board, tile)
    # If the tile itself is a mine, let the number of mine neighbours be -1
    if (tile.is_mine)
        tile.num_mines = -1
        return -1
    else
        # Iterate over neighbours in grid, and count number of mine neighbours
        total = 0
        for x_offset in -1:1
            for y_offset in -1:1
                i = tile.x + x_offset
                j = tile.y + y_offset
                if ((i in 1:length(board)) && (j in 1:length(board[1])) && (board[i][j].is_mine))
                    total += 1
                end
            end
        end

        # Return the number obtained
        tile.num_mines = total
        return total        
    end
end