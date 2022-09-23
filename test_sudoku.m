close all
clc
clear
%% Read data
fileID = fopen('dataset.txt','r');
A = fscanf(fileID,'%s',Inf);

%% Check if known solution matches found solution
num_simulation = 1000;
num_algo = 3;
max_level_list = zeros(num_simulation,2);
check = false(num_simulation,num_algo);
time = zeros(num_simulation, num_algo);
for i = 1:1:num_simulation
    problem = str2arr(A(163*(i-1)+1:163*(i-1)+81)); % Read problem    
    solution_check = str2arr(A(163*(i-1)+83:163*(i-1)+163)); % Read known solution\

    % Algorithm 1:
    tic;
    solution = sudoku_solve_simple(problem); % Solve problem
    time1 = toc;
    tic;
    solution = sudoku_solve_simple(problem'); % Solve problem
    time2 = toc;
    time(i,1) = abs(time2-time1)/((time1+time2)/2);
    check(i,1) = all(solution == solution_check, 'all'); % Check if found solution matches known solution

    % Algorithm 2:
    tic;
    solution = sudoku_backtrack_single(problem); % Solve problem
    time1 = toc;
    tic;
    solution = sudoku_backtrack_single(problem'); % Solve problem
    time2 = toc;
    time(i,2) = abs(time2-time1)/((time1+time2)/2);
    check(i,2) = all(solution == solution_check, 'all'); % Check if found solution matches known solution
    
    % Algorithm 3:
    tic;
    solution = sudoku_backtrack_random(problem); % Solve problem
    time1 = toc;
    tic;
    solution = sudoku_backtrack_random(problem'); % Solve problem
    time2 = toc;
    time(i,3) = abs(time2-time1)/((time1+time2)/2);
    check(i,3) = all(solution == solution_check, 'all'); % Check if found solution matches known solution
end
all(check) % Return 1 if match for all simulations

figure
histogram(time(:,1))
title('Naive Solution')
xlabel('normalized time difference')
figure
histogram(time(:,2))
title('Backtracking with naked single')
xlabel('normalized time difference')
figure
histogram(time(:,3))
title('Random Backtracking')
xlabel('normalized time difference')
% figure
% histogram(max_level_list(:,1))
% figure
% histogram(max_level_list(:,2))

function problem = str2arr(problem_txt) % Convert problem in text format to 9x9 array
problem = zeros(81,1);
for i = 1:1:81
    problem(i) = str2double(problem_txt(i));
end
problem = reshape(problem,9,9);
end