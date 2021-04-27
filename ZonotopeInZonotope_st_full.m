function res = ZonotopeInZonotope_st_full(c1, G1, c2, G2)
% Sadraddini, Tedrake Implementation
nx = size(G1, 2);
ny = size(G2, 2);

% yalmip constructs linear programming matrices
Gamma = sdpvar(ny, nx, 'full');
beda = sdpvar(ny, 1);
constraints = [...
    G1 == G2*Gamma, ...
    c2 - c1 == G2*beda];
cost = norm([Gamma, beda], Inf); % norm([Gamma, beda], Inf); check only feasibility -> no cost function
options = sdpsettings('solver','linprog', 'verbose',0, 'allownonconvex',0); % 'solver','mosek'

% solve linear programming problem
yalmipOptimizer = optimizer(constraints, cost, options,[],{Gamma, beda});
%elapsedTime = tic;
[optimizationResults, exitFlag] = yalmipOptimizer();
%toc(elapsedTime);
%optimizationResults{1};
%optimizationResults{2};
res = norm([optimizationResults{1}, optimizationResults{2}], Inf);
end