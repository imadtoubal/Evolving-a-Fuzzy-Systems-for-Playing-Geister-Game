function y = CG(captured, turn) 
    c = captured(:);
    if(mod(turn,2) == 0)
        y = sum(c == 3);
    else
        y = sum(c == 1);
    end
end

