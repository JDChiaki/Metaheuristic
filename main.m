% Define the sphere function
fitness_function = @(x) Branin(x);

% Parameters for PSO
num_particles = 100;
num_dimensions = 5;
num_iterations_pso = 100;
c1 = 2;
c2 = 2;

% Parameters for GA
population_size = 100;
chromosome_length = 5;
num_generations = 100;
mutation_rate = 0.01;

% Initialize arrays to store fitness values
ga_fitness_values = zeros(1, num_generations);
pso_fitness_values = zeros(1, num_iterations_pso);

% Particle Swarm Optimization
particles_pso = rand(num_particles, num_dimensions) * 10.24 - 5.12; % Initialize particles randomly
velocities_pso = zeros(num_particles, num_dimensions);
global_best_position = zeros(1, num_dimensions);
global_best_fitness_pso = inf;

for iteration = 1:num_iterations_pso
    for i = 1:num_particles
        fitness = fitness_function(particles_pso(i, :));
        if fitness < global_best_fitness_pso
            global_best_fitness_pso = fitness;
            global_best_position = particles_pso(i, :);
        end
        
        velocities_pso(i, :) = velocities_pso(i, :) + c1 * rand() * (global_best_position - particles_pso(i, :)) + c2 * rand() * (global_best_position - particles_pso(i, :));
        particles_pso(i, :) = particles_pso(i, :) + velocities_pso(i, :);
    end
    
    pso_fitness_values(iteration) = global_best_fitness_pso;
end

% Genetic Algorithm
% Initialize population
population = rand(population_size, chromosome_length) * 10.24 - 5.12; % Randomly initialize population within range [-5.12, 5.12]

% Initialize array to store best fitness value in each generation
best_fitness_history = zeros(1, num_generations);

% Main GA loop
for generation = 1:num_generations
    % Evaluate fitness for each individual in the population
    fitness_scores = arrayfun(@(idx) fitness_function(population(idx, :)), 1:population_size);
    
    % Find the best individual and its fitness value
    [best_fitness, best_idx] = min(fitness_scores);
    best_individual = population(best_idx, :);
    
    % Store the best fitness value for the current generation
    best_fitness_history(generation) = best_fitness;
    
    % Select parents (tournament selection)
    tournament_size = 2;
    selected_parents = zeros(population_size, chromosome_length);
    for i = 1:population_size
        tournament_idxs = randperm(population_size, tournament_size);
        [~, idx] = min(fitness_scores(tournament_idxs));
        selected_parents(i, :) = population(tournament_idxs(idx), :);
    end
    
    % Perform crossover (single-point crossover)
    crossover_point = randi(chromosome_length);
    crossover_mask = rand(population_size, chromosome_length) < 0.5;
    offspring = selected_parents;
    for i = 1:population_size
        if crossover_mask(i) == 1
            offspring(i, crossover_point:end) = selected_parents(i, crossover_point:end);
        end
    end

    
    % Perform mutation
    mutation_mask = rand(population_size, chromosome_length) < mutation_rate;
    mutation_values = rand(population_size, chromosome_length) * 10.24 - 5.12; % Random mutation values within range [-5.12, 5.12]
    offspring(mutation_mask) = mutation_values(mutation_mask);
    
    % Replace the old population with the new offspring
    population = offspring;
end


% Plotting
figure;
plot(1:num_generations, best_fitness_history, 'r', 'LineWidth', 2);
hold on;
plot(1:num_iterations_pso, pso_fitness_values, 'b', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Fitness');
title('Branin Function');
subtitle('Best Fitness ≈ 0.397887')
legend('Particle Swarm Optimization', 'Genetic Algorithm');
grid on;
hold off;
