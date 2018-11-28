function y = CE(captured, turn) 
    if(mod(turn,2) == 0)
        y = sum(captured == 4);
    else
        y = sum(captured == 2);
    end
end

