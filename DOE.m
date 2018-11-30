% Opponent Exit Distance
function y = DOE(board, turn)
    y = ones(6,6) * 100;
    for ghost_ind = 1:36
        if board(ghost_ind) == 0 | ...
                mod(turn,2) == 1 & (board(ghost_ind) == 3 | board(ghost_ind) == 4) | ...
                mod(turn,2) == 0 & (board(ghost_ind) == 1 | board(ghost_ind) == 2)
            continue;
        end
        
        [g_row, g_col] = ind2sub(size(board), ghost_ind);
        
        if(mod(turn,2) == 1) % 1 31
            if(ghost_ind <= 18) % 1
                [row, col] = ind2sub(size(board), 1);
            else 
                [row, col] = ind2sub(size(board), 31);
            end
            y(ghost_ind) = abs(row - g_row) + abs(col - g_col);
        else %% 6, 36
            if(ghost_ind < 18) % 1
                [row, col] = ind2sub(size(board), 6);
            else 
                [row, col] = ind2sub(size(board), 36);
            end
            y(ghost_ind) = abs(row - g_row) + abs(col - g_col);
        end
    end
    y = y(:);
    y = min(y);
end