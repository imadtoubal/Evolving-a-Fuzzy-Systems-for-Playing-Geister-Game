% Others Distance to Opponent Exit
function y = OTDHE(board, turn)
    y = zeros(6,6);
    for ghost_ind = 1:36
        if board(ghost_ind) == 0 | ...
                mod(turn,2) == 0 & (board(ghost_ind) == 1 | board(ghost_ind) == 2) | ...
                mod(turn,2) == 1 & (board(ghost_ind) == 3 | board(ghost_ind) == 4)
            continue;
        end
        
        [g_row, g_col] = ind2sub(size(board), ghost_ind);
        
        if(mod(turn,2) == 0) %% 1, 31
            if(ghost_ind <= 18) 
                sub_board = board(g_row:end, 1:g_col);    
            else 
                sub_board = board(g_row:end, g_col:6);    
            end
            
            y(ghost_ind) = sum(sum(sub_board == 1)) + sum(sum(sub_board == 2));
            
        else %% 6, 36
            if(ghost_ind <= 18) 
                sub_board = board(g_row:6, 1:g_col);    
            else 
                sub_board = board(g_row:6, g_col:6);    
            end
            y(ghost_ind) = sum(sum(sub_board == 3)) + sum(sum(sub_board == 4));
            
        end
    end
end