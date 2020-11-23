function result = inLinearProgram(ZX, ZY)
% check if zonotope ZX is contained in ZY, i.e., ZX subset ZY?
% in contrast to "in.m", a linear programming problem is solved
% -> no enumeration of faces -> also works for many generators
% same notation as Sadraddini2019

% extract data
x = ZX.center;
y = ZY.center;
X = ZX.generators;
Y = ZY.generators;
nx = size(X, 2);
ny = size(Y, 2);

% yalmip constructs linear programming matrices
Gamma = sdpvar(ny, nx, 'full');
beda = sdpvar(ny, 1);
constraints = [...
    X == Y*Gamma, ...
    y - x == Y*beda, ...
    norm([Gamma, beda], Inf) <= 1];
cost = []; % norm([Gamma, beda], Inf); check only feasibility -> no cost function
options = sdpsettings('solver','linprog', 'verbose',0, 'allownonconvex',0); % 'solver','mosek'

% solve linear programming problem
yalmipOptimizer = optimizer(constraints, cost, options,[],{Gamma, beda});
%elapsedTime = tic;
[optimizationResults, exitFlag] = yalmipOptimizer();
%toc(elapsedTime);
%optimizationResults{1};
%optimizationResults{2};
result = exitFlag;

% tic
% solution = optimize(constraints, cost, options);
% toc
%
% % set result
% if solution.problem == 0 % successfully solved
%     result = true;
% elseif solution.problem == 1 % infeasible problem
%     result = false;
% else
%     result = false;
%     warning('zonotope containment problem -> check "yalmiperror"');
% end