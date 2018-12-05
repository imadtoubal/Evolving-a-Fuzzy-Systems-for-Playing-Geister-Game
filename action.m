function y = action(board, turn, ind, ac)
    cgi = CGI(board, turn);
    cgd = CGD(board, turn);
    dhe = DHE(board, turn);
     % 1: up, 2: down, 3: left, 4: right
    if(ac == 1) %% CAP
        [t_row, t_col] = ind2sub(size(board), cgi(ind));
        [g_row, g_col] = ind2sub(size(board), ind);
        d_row = g_row - t_row;
        d_col = g_col - t_col;
        if d_row >= 1 & g_row ~= 1
            y = 1;
        elseif d_row <= -1 & g_row ~= 6
            y = 2;
        elseif d_col >= 1 & g_col ~= 1
            y = 3;
        elseif d_col <= -1 & g_col ~= 6
            y = 4;
        end
    elseif (ac == 2) %% BLOCK
        [t_row, t_col] = ind2sub(size(board), dhe(ind));
        [g_row, g_col] = ind2sub(size(board), ind);
        d_row = g_row - t_row;
        d_col = g_col - t_col;
        if d_row >= 1 & g_row ~= 1
            y = 1;
        elseif d_row <= -1 & g_row ~= 6
            y = 2;
        elseif d_col >= 1 & g_col ~= 1
            y = 3;
        elseif d_col <= -1 & g_col ~= 6
            y = 4;
        end
    elseif (ac == 3) %% EXIT
        if(ind > 18)
            y = 4;
        else
            y = 3;
        end
    elseif (ac == 4) %% ESC
        [g_row, g_col] = ind2sub(size(board), ind);
        g_row = g_row + 1;
        g_col = g_col + 1;
        pboard = ones(8, 8) * 10; %% board with padding
        pboard(2:7,2:7) = cgd;
        nexti = [pboard(g_row - 1, g_col),...
                 pboard(g_row + 1, g_col),...
                 pboard(g_row, g_col - 1),...
                 pboard(g_row, g_col + 1)];
        [m, y] = min(nexti);
    elseif (ac == 5) %% TEMPT
        [t_row, t_col] = ind2sub(size(board), cgi(ind));
        [g_row, g_col] = ind2sub(size(board), ind);
        d_row = g_row - t_row;
        d_col = g_col - t_col;
        if d_row >= 1 & g_row ~= 1
            y = 1;
        elseif d_row <= -1 & g_row ~= 6
            y = 2;
        elseif d_col >= 1 & g_col ~= 1
            y = 3;
        elseif d_col <= -1 & g_col ~= 6
            y = 4;
        end
%         pboard = ones(8, 8) * 0; %% board with padding
%         pboard(2:7,2:7) = board;
%         [g_row, g_col] = ind2sub(size(board), ind);
%         pg_row = g_row + 1;
%         pg_col = g_col + 1;
%         if      pboard(pg_row + 1, pg_col + 1) >= 3 % top right
%             if(g_row ~= 1)
%                 y = 1;
%             elseif(g_col ~= 6)
%                 y = 4;
%             end
%         elseif  pboard(pg_row - 1, pg_col + 1) >= 3 % bottom right
%             if(g_row ~= 6)
%                 y = 1;
%             elseif(g_col ~= 6)
%                 y = 4;
%             end
%         elseif  pboard(pg_row + 1, pg_col - 1) >= 1 % top left
%             if(g_row ~= 1)
%                 y = 1;
%             elseif(g_col ~= 6)
%                 y = 4;
%             end
%         elseif  pboard(pg_row - 1, pg_col - 1) >= 1 % bottom left
%             if(g_row ~= 1)
%                 y = 1;
%             elseif(g_col ~= 6)
%                 y = 4;
%             end
%         end
    end        
end

