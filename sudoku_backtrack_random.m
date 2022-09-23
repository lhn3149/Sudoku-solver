function [problem, max_level] = sudoku_backtrack_random(problem)
max_level = 1;
global level % Check which recursive level of recursive_solve is being called (Can gauge hardness!)
level = 1;
problem = recursive_solve(problem);
function problem = recursive_solve(problem)
% *** Attempts to solve problem by filling in all entries with only 1 possible candidate
C = candidates(problem);
len = cellfun(@length, C); % Number of candidates for an unfilled entry

empt = find(problem==0 & len==0,1); % Stores all indices of entries with 0 candidate

if ~isempty(empt) % If no more candidates, stop function
    if level == 1 % If returning at lowest level of recursive_solve, there are no solutions!
        sprintf("Unsolvable!!!")
    end
    level = level-1; % Decrement level by 1 before exiting recursive_solve
    return 
end  

% *** If there are no more entries with single candidates but problem is still not solved
if any(problem(:) == 0)    
    temp = problem;
    idx = find(problem==0, 1); % Find first unfilled entry (with multiple candidates)
    for candidate_arbitrary = cell2mat(C{idx}) 
        problem = temp;
        problem(idx) = candidate_arbitrary; % Pick an arbitrary candidate and fill in entry
        level = level+1; % Increment level by 1 before recursively calling recursive_solve
        max_level = level;
        problem = recursive_solve(problem);   % Call recursive_solve again to see if this (arbitrarily) chosen candidate works
           if ~any(problem(:) == 0)       % All entries filled. Problem solved!
              return 
           end 
    end
end
end
if any(problem(:) == 0)       % If still have zero entries, report errors
    sprintf("Unsolvable!!!")
end 
end

function C = candidates(problem) % Find candidates for the whole 9x9 matrix
C = cell(9,9); % 9x9 candidates cell array
for i = 1:1:9
    for j = 1:1:9
        if problem(i,j) == 0
            C{i,j} = candidate_single(i,j,problem); % Find candidates for a single entry
        end
    end
end
end
    
function C = candidate_single(i,j,problem)
ib = floor((i-1)/3)+1; % index of 3x3 blocks (1 to 3) 
jb = floor((j-1)/3)+1;
cand = [1,2,3,4,5,6,7,8,9];
for k = 1:1:9
    cand(cand==problem(k,j)) = [];  % Check column
    cand(cand==problem(i,k)) = [];   % Check row
end
for k = 1:1:3 % Check 3x3 block
    for l = 1:1:3
        cand(cand==problem(3*ib-3+k,3*jb-3+l)) = [];  
    end
end
C = num2cell(cand); % Convert from array to cell
end