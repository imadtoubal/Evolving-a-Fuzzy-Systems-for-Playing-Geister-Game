function y = LE(captured, turn) 
    if(mod(turn,2) == 0)
        y = sum(captured == 2);
    else
        y = sum(captured == 4);
    end
end

