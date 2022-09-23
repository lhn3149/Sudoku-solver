close all
clc
clear
%% Read data
A = readtable('difficulties_short_3.txt');
diff = A.difficulty;
histogram(diff)
%% Test
num_simulation = 100;
num_algo = 2;
max_level_list = zeros(num_simulation, 2);
check = false(num_simulation,num_algo);
time = zeros(num_simulation,num_algo);

for i = 1:1:num_simulation    
    i    
    problem = str2arr(A.puzzle{i}); % Read problem
    solution_check = str2arr(num2str(A.solution(i),81)); % Read known solution            
    % Algorithm 1:
    tic;
    solution = sudoku_solve_simple(problem); % Solve problem
    time(i,1) = toc;    
    check(i,1) = all(solution == solution_check, 'all'); % Check if found solution matches known solution
    % Algorithm 2:
    tic;
    [solution, max_level] = sudoku_backtrack_single(problem); % Solve problem
    time(i,2) = toc;
    check(i,2) = all(solution == solution_check, 'all'); % Check if found solution matches known solution
    max_level_list(i,1) = max_level;
    % Algorithm 3:
%     tic;
%     [solution, max_level] = sudoku_backtrack_random(problem); % Solve problem
%     time(i,3) = toc;
%     check(i,3) = all(solution == solution_check, 'all'); % Check if found solution matches known solution
%     max_level_list(i,2) = max_level;
end
all(check) % Return 1 if match for all simulations

%% Sort difficulties
%{
easy = [];
medium = [];
hard = [];
for i = 1:1:num_simulation
    if diff(i)<1
        easy = [easy, time(i,1)];
    elseif diff(i)>=1 && diff(i)<2
        medium = [medium, time(i,1)];
    elseif diff(i)>2
        hard = [hard, time(i,1)];
    end
end

figure
histogram(easy, 'BinWidth', 0.01)
title('Simple Solution, Easy')
figure
histogram(medium, 'BinWidth', 0.01)
title('Simple Solution, Medium')
figure
histogram(hard, 'BinWidth', 0.01)
title('Simple Solution, Hard')

easy = [];
medium = [];
hard = [];
for i = 1:1:num_simulation
    if diff(i)<1
        easy = [easy, time(i,2)];
    elseif diff(i)>=1 && diff(i)<2
        medium = [medium, time(i,2)];
    elseif diff(i)>2
        hard = [hard, time(i,2)];
    end
end

figure
histogram(easy, 'BinWidth', 0.01)
title('Backtracking with naked single, Easy')
figure
histogram(medium, 'BinWidth', 0.01)
title('Backtracking with naked single, Medium')
figure
histogram(hard, 'BinWidth', 0.01)
title('Backtracking with naked single, Hard')

%}
%%

figure
scatter(A.clues(1:100), time(:,2))

sumtimevsclues = zeros(81,2);
timevsclues = zeros(81,2);
countvsclues = zeros(81,1);

for i = 1:1:num_simulation
    sumtimevsclues(A.clues(i),:) = sumtimevsclues(A.clues(i),:)+time(i,:);
    countvsclues(A.clues(i)) = countvsclues(A.clues(i))+1;
end
timevsclues = sumtimevsclues./countvsclues;
figure
hold on
scatter(1:81,timevsclues(:,1))
scatter(1:81,timevsclues(:,2))
% scatter(1:81,timevsclues(:,3))
legend('naive', 'backtrack with single')
xlabel('number of clues')
ylabel('time (s)')
hold off
%% Functions
function problem = str2arr(problem_txt) % Convert problem in text format to 9x9 array
problem_txt(problem_txt=='.') = '0';
problem = zeros(81,1);
for i = 1:1:81
    problem(i) = str2double(problem_txt(i));
end
problem = reshape(problem,9,9);
end