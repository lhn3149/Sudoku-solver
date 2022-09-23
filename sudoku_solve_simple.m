function solution = sudoku_solve_simple(problem)
global solution;
result = sudoku_solve(1,1,problem);
function result = sudoku_solve(i,j,problem)
% *** Attempts to solve problem by filling in all entries with only 1 possible candidate
if i == 9 && j == 10 % Reached final cell. Done!
    solution = problem; % Print result when done
    result = true;
    return
end

if j ==10 % Reached end of row, move to the beginning of next row
    i = i+1;
    j = 1;
end
    
if problem(i,j) > 0 % Cell already filled, move to next cell
    result = sudoku_solve(i,j+1,problem);
    return
end

for cand = 1:1:9 % Check all candidates for a cell
    if issafe(i,j,problem,cand)
        problem(i,j) = cand; % Fill cell with candudate
        if sudoku_solve(i,j+1,problem) % Solve problem again with this cell filled 
            result = true;
            return
        end
    end
    problem(i,j) = 0;  % If that candidate did not work, unfill cell  
end
result = false;
return 
end
    
function result = issafe(i,j,problem, cand)
ib = floor((i-1)/3)+1; % index of 3x3 blocks (1 to 3) 
jb = floor((j-1)/3)+1;

for k = 1:1:9
    if cand==problem(k,j) % Check column
        result = false;
        return
    end
    if cand==problem(i,k) % Check column
        result = false;
        return
    end
end
for k = 1:1:3 % Check 3x3 block
    for l = 1:1:3
        if cand==problem(3*ib-3+k,3*jb-3+l) % Check column
        result = false;
        return
        end
    end
end

result = true;
return
end
end