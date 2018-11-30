function y = LE(captured, turn) 
    c = captured(:);
    if(mod(turn,2) == 0)
        y = sum(c == 2);
    else
        y = sum(c == 4);
    end
end

