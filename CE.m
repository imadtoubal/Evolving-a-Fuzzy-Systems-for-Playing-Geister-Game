function y = CE(captured, turn) 
    c = captured(:);
    if(mod(turn,2) == 0)
        y = sum(c == 4);
    else
        y = sum(c == 2);
    end
end

