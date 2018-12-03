function y = CGEC(board, turn)
    b = board(:);
    if mod(turn) == 0
        eg = sum(b == 4);
        ag = eg + sum(b == 3);
    else
        eg = sum(b == 2);
        ag = eg + sum(b == 1);        
    end
    y = eg / ag;
end

