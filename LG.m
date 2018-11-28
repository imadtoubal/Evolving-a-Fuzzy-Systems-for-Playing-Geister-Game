function y = LG(captured, turn) 
    if(mod(turn,2) == 0)
        y = sum(captured == 1);
    else
        y = sum(captured == 3);
    end
end

