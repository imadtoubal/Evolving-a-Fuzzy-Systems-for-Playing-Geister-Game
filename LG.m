function y = LG(captured, turn) 
    c = captured(:);
    if(mod(turn,2) == 0)
        y = sum(c == 1);
    else
        y = sum(c == 3);
    end
end

