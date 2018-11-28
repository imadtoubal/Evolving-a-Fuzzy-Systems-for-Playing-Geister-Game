function y = CG(captured, turn) 
    if(mod(turn,2) == 0)
        y = sum(captured == 3);
    else
        y = sum(captured == 1);
    end
end

