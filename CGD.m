% Closest Ghost Distance
function y = CGD(board, turn)
    y = ones(6,6) * 10;
    for ghost_ind = 1:36
        if board(ghost_ind) == 0 | ...
                mod(turn,2) == 0 & (board(ghost_ind) == 3 | board(ghost_ind) == 4) | ...
                mod(turn,2) == 1 & (board(ghost_ind) == 1 | board(ghost_ind) == 2)
            continue;
        end
        
        [g_row, g_col] = ind2sub(size(board), ghost_ind);
        [M, N]= size(board);
        length = M * N;
        
        if(mod(turn,2) == 0) %% 3, 4
            for i = 1:length
                if(board(i) == 3 | board(i) == 4)
                    % calculate the distance to the ghost index;
                    [row, col] = ind2sub(size(board), i);
                    d = abs(row-g_row) + abs(col-g_col);
                    if(d < y(ghost_ind))
                        y(ghost_ind) = d;
                    end
                end
            end
        else %% 1, 2
            for i = 1:length
                if(board(i) == 1 | board(i) == 2)
                    % calculate the distance to the ghost index;
                    [row, col] = ind2sub(size(board), i);
                    d = abs(row-g_row) + abs(col-g_col);
                    if(d < y(ghost_ind))
                        y(ghost_ind) = d;
                    end
                end
            end
        end
    end
end