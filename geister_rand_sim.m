clear all;
% Reading FIS
fis = readfis('geister_fis.fis');

% Whether or not to draw the board
draw = false;


victoryType = zeros(1,6);
% 1: No more self good ghosts. Opponent wins.
% 2: No more self evil ghosts. You win!      
% 3: No more opponent good ghosts. You win!  
% 4: No more opponent evil ghosts. Opponent wins.            
% 5: Self good ghost moved off the board. You win!           
% 6: Opponent good ghost moved off the board. Opponent wins.

% How many games to play
games = 100;

for trial = 1:games

    % Define initial board state
    board = zeros(6);
    captured = zeros(1);
    captured_count = 1;
    turn = 0;
    playing = true;
    
    % Place ghosts
    % Initial placement of ghosts.
    board(1:2, 2:5) = reshape(randperm(8) > 4, 2, 4)+3;
    board(5:6, 2:5) = reshape(randperm(8) > 4, 2, 4)+1;
    
    if draw
    
        % Create figure
        figHandle = figure;

        % Create axes
        axesHandle = axes;
        set(axesHandle, 'box', 'on');
        set(axesHandle, 'xtick', []);
        set(axesHandle, 'ytick', []);
        axis([0 6 0 6]);
        axis square;
        axis ij;

    end

    while playing
        
        %% Drawing
        if draw

            % Clear board
            cla;

            % Draw grid
            for i = 0:6
                line([i i], [0 6], 'color', 'k');
                line([0 6], [i i], 'color', 'k');
            end

            % Draw escape arrows
            patch([0.2 0.4 0.4 0.8 0.8 0.4 0.4], [0.5 0.35 0.45 0.45 0.55 0.55 0.65], [1 1 0.7]);
            patch([0.2 0.4 0.4 0.8 0.8 0.4 0.4], [5.5 5.35 5.45 5.45 5.55 5.55 5.65], [1 1 0.7]);
            patch([5.8 5.6 5.6 5.2 5.2 5.6 5.6], [0.5 0.35 0.45 0.45 0.55 0.55 0.65], [1 1 0.7]);
            patch([5.8 5.6 5.6 5.2 5.2 5.6 5.6], [5.5 5.35 5.45 5.45 5.55 5.55 5.65], [1 1 0.7]);

            % Draw ghosts
            for i = 1:6
                for j = 1:6
                    if board(i,j) == 1
                        % Self good
                        patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [0 0 1]);
                    elseif board(i,j) == 2
                        % Self evil
                        patch([j-0.75 j-0.5 j-0.25], [i-0.25 i-0.75 i-0.25], [1 0 0]);
                    elseif board(i,j) == 3
                        % Opponent good
                        patch([j-0.75 j-0.5 j-0.25], [i-0.75 i-0.25 i-0.75], [0.6 0.6 0.9]);
                    elseif board(i,j) == 4
                        % Opponent evil
                        patch([j-0.75 j-0.5 j-0.25], [i-0.75 i-0.25 i-0.75], [0.9 0.6 0.6]);
                    end
                end
            end
            drawnow;
        end
        %% End of drawing
        % Check for victory
        if isempty(find(board==1, 1))
            disp('No more self good ghosts. Opponent wins.');
            playing = false;
            victoryType(1) = victoryType(1)+1;
        elseif isempty(find(board==2, 1))
            disp('No more self evil ghosts. You win!');
            playing = false;
            victoryType(2) = victoryType(2)+1;
        elseif isempty(find(board==3, 1))
            disp('No more opponent good ghosts. You win!');
            playing = false;
            victoryType(3) = victoryType(3)+1;
        elseif isempty(find(board==4, 1))
            disp('No more opponent evil ghosts. Opponent wins.');
            playing = false;
            victoryType(4) = victoryType(4)+1;
        end

        if ~playing
            break;
        end
        
        % Delay: to watch the game.
%         pause(1);

        %% Make random move
        if mod(turn,2) == 0
            % player 1
            inds = find(board==1 | board==2);
        else
            % player 2
            inds = find(board==3 | board==4);
        end
        valid = false;
        output = zeros(36,5);
        cg = CG(board, turn);
        ce = CE(board, turn);
        lg = LG(board, turn);
        le = LE(board, turn);
        cgd = CGD(board, turn);
        cgi = CGI(board, turn);
        doe = DOE(board, turn);
        ec = EC(board, turn);
        odhe = ODHE(board, turn);
        dhe = DHE(board, turn);
        otdhe = OTDHE(board, turn);
        for i = 1:36
            if sum(inds == i) > 0
                cggc = CGGC(board, turn);
                cgec = CGEC(board, turn);
                inputs = [min(cg, 3), min(ce, 3), min(lg, 3), min(le, 3), ...
                    cgd(i), cggc, cgec, doe(i), ec(i), odhe, dhe(i), otdhe(i)];
                output(i,:) = evalfis(fis, inputs);
            else
                output(i,:) = zeros(1,5);
            end
        end
        % Only if an action was taken (i.e. a player makes a valid move),
        % the variable valid changes to true. Else, we pick another ghost
        % and another move. Repeat until valid is true.
        while ~valid 
            
            % inds: list of all current player pieces indeces
            % ind: the index of the player's piece to move next
            % dir: the direction in which the piece moves 
            % 1: up, 2: down, 3: left, 4: right
            if(mod(player, 2) == 0) 
                ind = inds(randi(length(inds)));
                [row, col] = ind2sub(size(board), ind);
                dir = randi(4);
            else 
                [values, indeces] = max(output);
                [best_value, best_index] = max(values);
                ind = indeces(best_index);
                [row, col] = ind2sub(size(board), ind);
                dir = action(board, turn, ind, best_index);
            end 
            if dir == 1
                % Move up      
                if row > 1
                    if (mod(turn,2) == 0 && board(row-1, col) ~= 1 && board(row-1, col) ~= 2) || ...
                       (mod(turn,2) == 1 && board(row-1, col) ~= 3 && board(row-1, col) ~= 4)  
                        if(board(row-1, col) ~= 0) 
                            captured(captured_count) = board(row-1, col);
                            captured_count = captured_count + 1;
                        end
                        board(row-1, col) = board(ind);
                        board(ind) = 0;
                        valid = true;
                    end
                elseif row == 1 && (col == 1 || col == 6) && board(ind) == 1
                    disp('Self good ghost moved off the board. You win!');
                    playing = false;
                    valid = true;
                    victoryType(5) = victoryType(5)+1;
                end
            elseif dir == 2
                % Move down      
                if row < 6
                    if (mod(turn,2) == 0 && board(row+1, col) ~= 1 && board(row+1, col) ~= 2) || ...
                       (mod(turn,2) == 1 && board(row+1, col) ~= 3 && board(row+1, col) ~= 4)  
                        if(board(row+1, col) ~= 0) 
                            captured(captured_count) = board(row+1, col);
                            captured_count = captured_count + 1;    
                        end
                        board(row+1, col) = board(ind);
                        board(ind) = 0;
                        valid = true;
                    end
                elseif row == 6 && (col == 1 || col == 6) && board(ind) == 3
                    disp('Opponent good ghost moved off the board. Opponent wins.');
                    playing = false;
                    valid = true;
                    victoryType(6) = victoryType(6)+1;
                end
            elseif dir == 3
                % Move left      
                if col > 1
                    if (mod(turn,2) == 0 && board(row, col-1) ~= 1 && board(row, col-1) ~= 2) || ...
                       (mod(turn,2) == 1 && board(row, col-1) ~= 3 && board(row, col-1) ~= 4)  
                        if(board(row, col-1))
                            captured(captured_count) = board(row, col-1);
                            captured_count = captured_count + 1;
                        end
                        board(row, col-1) = board(ind);
                        board(ind) = 0;
                        valid = true;
                    end
                elseif row == 1 && col == 1 && board(ind) == 1
                    disp('Self good ghost moved off the board. You win!');
                    playing = false;
                    valid = true;
                    victoryType(5) = victoryType(5)+1;
                elseif row == 6 && col == 1 && board(ind) == 3
                    disp('Opponent good ghost moved off the board. Opponent wins.');
                    playing = false;
                    valid = true;
                    victoryType(6) = victoryType(6)+1;
                end 
             elseif dir == 4
                % Move right     
                if col < 6
                    if (mod(turn,2) == 0 && board(row, col+1) ~= 1 && board(row, col+1) ~= 2) || ...
                       (mod(turn,2) == 1 && board(row, col+1) ~= 3 && board(row, col+1) ~= 4)  
                        if(board(row, col+1)) 
                            captured(captured_count) = board(row, col+1);
                            captured_count = captured_count + 1;
                        end
                        board(row, col+1) = board(ind);
                        board(ind) = 0;
                        valid = true;
                    end
                elseif row == 1 && col == 6 && board(ind) == 1
                    disp('Self good ghost moved off the board. You win!');
                    playing = false;
                    valid = true;
                    victoryType(5) = victoryType(5)+1;
                elseif row == 6 && col == 6 && board(ind) == 3
                    disp('Opponent good ghost moved off the board. Opponent wins.');
                    playing = false;
                    valid = true;
                    victoryType(6) = victoryType(6)+1;
                end
            end
        end

        turn = turn + 1;
    end
    %% 
    if draw
%         close(figHandle);
    end
    
    disp(' ');
    disp('Victory Types');
    disp('---------------------------');
    disp(['No more self good ghosts. Opponent wins.                : ' num2str(victoryType(1)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(1))]);
    disp(['No more self evil ghosts. You win!                      : ' num2str(victoryType(2)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(2))]);
    disp(['No more opponent good ghosts. You win!                  : ' num2str(victoryType(3)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(3))]);
    disp(['No more opponent evil ghosts. Opponent wins.            : ' num2str(victoryType(4)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(4))]);
    disp(['Self good ghost moved off the board. You win!           : ' num2str(victoryType(5)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(5))]);
    disp(['Opponent good ghost moved off the board. Opponent wins. : ' num2str(victoryType(6)/sum(victoryType)*100,'%.1f') '% ' num2str(victoryType(6))]);
    disp(' ');
    disp(' ');
    
end