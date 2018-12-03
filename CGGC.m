function y = CGGC(board, turn)
    b = board(:);
    if mod(turn, 2) == 0
        eg = sum(b == 3);
        ag = eg + sum(b == 4);
    else
        eg = sum(b == 1);
        ag = eg + sum(b == 2);        
    end
    y = eg / ag;
end

