mutable struct Tile
    shown::Bool
    is_mine::Bool
    x::Int
    y::Int
end

function to_string(tile)
    if tile.shown
        if tile.is_mine == true
            return "•"
        else
            return " "
        end
    else
        return "�"
    end
end