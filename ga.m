% START
popsize = 20;
mutation = .3;
parents = 5;
d = 5;
generations = 10;
gen = 0;
% Generate the initial population
population = normrnd(1, .1, [popsize d]);
% Compute fitness
fitness = ones(popsize, 1);
for i = 1:population
    fitness(i) = fitnessFunc(population);
end
convergence = false;
% REPEAT
while ~convergence
    % Selection
    sorted_population = sortrows([population fitness], d + 1);
    sorted_population = sorted_population(:,1:end-1);
	% Crossover
    crossover_point = randi(d); % 1 - d
    newpop = zeros(popsize, d);
    for i = 1:popsize
        newpop(i,:) = [sorted_population(randi(parents),1:crossover_point) ...
                       sorted_population(randi(parents),crossover_point+1:end)];
    end
    % Mutation
    for i = 1:popsize
        xi = rand();
        if(xi < mutation) 
            randint = randi(d);
             newpop(i,randint) = newpop(i,randint) + normrnd(0,.5);
        end
    end
	population = newpop;
    % Compute fitness
    for i = 1:population
        fitness(i) = fitnessFunc(population);
    end
    best_fitness = min(fitness);
    gen = gen + 1;
    if(gen == generations)
        convergence = true;
    end
% UNTIL population has converged
end
% STOP
