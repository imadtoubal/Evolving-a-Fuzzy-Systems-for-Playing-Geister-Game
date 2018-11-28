function y = CGD(board, ghost_ind, turn) 
    [g_row, g_col] = ind2sub(size(board), ghost_ind);
    [M, N]= size(board);
    length = M * N;
    if(mod(turn,2) == 0) %% 3, 4
        best_d = 100;
        for i = 1:length
            if(board(i) == 3 | board(i) == 4)
                % calculate the distance to the ghost index;
                [row, col] = ind2sub(size(board), i);
                d = abs(row-g_row) + abs(col-g_col);
                if(d < best_d) 
                    best_d = d;
                end
            end
        end
        y = best_d;
    else %% 1, 2
        best_d = 100;
        for i = 1:length
            if(board(i) == 1 | board(i) == 2)
                % calculate the distance to the ghost index;
                [row, col] = ind2sub(size(board), i);
                d = abs(row-g_row) + abs(col-g_col);
                if(d < best_d) 
                    best_d = d;
                end
            end
        end
        y = best_d;
    end
end

