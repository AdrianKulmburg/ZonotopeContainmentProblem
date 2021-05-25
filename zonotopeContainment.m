function isIn = zonotopeContainment(Z2, Z1, varargin)
% zonotopeContainment - determines if the zonotope Z1 lies in the
%   zonotope Z2 (careful about the order!)
%
% Syntax:  
%    isIn = containsPoint(Z1,Z2)
%    isIn = containsPoint(Z1,Z2,method,tol)
%    isIn = containsPoint(Z1,Z2,method,tol,steps)
%
% Inputs:
%    Z1, Z2 - zonotope objects
%    method - method used for the containment check. The available options
%       are:
%           - 'venum': Checks for containment by enumerating all vertices
%               of Z1 (see Algorithm 1 in [2]). The runtime is exponential
%               w.r.t. the number of generators of Z1, polynomial w.r.t.
%               the other inputs.
%           - 'polymax': Checks for containment by maximizing the
%               polyhedral norm w.r.t. Z2 over Z1 (see Algorithm 2 in [2]).
%               The runtime is exponential w.r.t. the number of generators
%               of Z2, polynomial w.r.t. the other inputs.
%           - 'exact': Checks for containment by using either 'venum' or
%               'polymax', depending on the number of generators of Z1 and
%               Z2.
%           - 'opt': Solves the containment problem via optimization
%               (see [2]) using the subroutine surrogateopt. If a solution
%               using 'opt' returns that Z1 is not contained in Z2, then
%               this is guaranteed to be the case. The runtime is
%               polynomial w.r.t. maxEval and the other inputs.
%           - 'approx' or 'st': Solves the containment problem using the
%               approximative method from [1]. If a solution using 'opt'
%               returns that Z1 is contained in Z2, then this is guaranteed
%               to be the case. The runtime is polynomial w.r.t. all
%               inputs.
%    tol - tolerance for the containment check
%    maxEval - Only, if 'opt' is used: Number of maximal function 
%       evaluations for the surrogate optimization. By default, this is set 
%       to max(500, 200 * number of generators of Z1).
%
% Outputs:
%    isIn - boolean whether the Z1 is contained in Z2, or not
%
% Example: 
%    zono1 = zonotope([0.5 2 3 0;0.5 2 0 3]);
%    zono2 = zonotope([0 -1 1 0; 0 1 0 1]);
%    zono3 = zono2 + [3;0];
% 
%    zonotopeContainment(zono1,zono2)
%    zonotopeContainment(zono1,zono3)
% 
%    figure
%    hold on
%    plot(zono1,[1,2],'b');
%    plot(zono2,[1,2],'g');
%    
%    figure
%    hold on
%    plot(zono1,[1,2],'b');
%    plot(zono3,[1,2],'r');
%
% References:
%    [1] Sadraddini et. al: Linear Encodings for Polytope Containment
%        Problems, CDC 2019
%    [2] A. Kulmburg, M. Althoff. "On the co-NP-Completeness of the
%        Zonotope Containment Problem", 2021
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Adrian Kulmburg
% Written:      14-May-2021
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% parse input arguments
type = 'exact';
tol = 0;
maxEval = -1;

if nargin >= 3
    type = varargin{1};
    if ~ismember(type, {'venum', 'polymax', 'exact', 'opt', 'approx', 'st'})
        error('Unknown method name.')
    end
    if nargin >= 4
        tol = varargin{2};
        if ~isscalar(tol) || tol < 0
            error('tol must be non-negative.')
        end
        if nargin >= 5
            maxEval = varargin{3};
            if ~isscalar(maxEval) || maxEval <= 0 || floor(maxEval) ~= maxEval
                error('steps must be a positive integer or inf.')
            end
            if nargin >=6
                error("Too many input arguments.")
            end
        end
    end
end

% Remaining argument-checks
if dim(Z1) ~= dim(Z2)
    error("The two zonotopes do not have the same dimensions.")
end

% Set adaptive maxEval, if needed
if strcmp(type, 'opt') && maxEval == -1
    m1 = size(Z1.generators, 2);
    maxEval = max(500, 200 * m1);
end

% Simplify the zonotopes as much as possible
Z1 = deleteZeros(Z1);
Z2 = deleteZeros(Z2);

switch type
    case 'exact'
        % Compute the maximum number of facets of Z2
        m2 = size(Z2.generators,2);
        n = dim(Z2);
        facets_Z2 = 2*nchoosek(m2, n-1);
        
        % Compute the maximum number of vertices of Z1
        m1 = size(Z1.generators,2);
        vertices_Z1 = 2^m1;
        
        % Approximative runtime of both algorithms
        venum_time_estimation = vertices_Z1 * (m2 +1)^3;
        polymax_time_estimation = facets_Z2 * (n^3 + n^2 + n*(m1+1));
        
        %Due to the big for-loop, venum is about 10 times slower
        venum_time_estimation = venum_time_estimation * 10;
        
        % Compare those two quantities, and determine which algorithm is
        % more likely to take the most amount of time...
        if venum_time_estimation < polymax_time_estimation
            isIn = vertexEnumeration(Z1, Z2, tol);
        else
            isIn = polyhedralMaximization(Z1, Z2, tol);
        end
    case 'venum'
        isIn = vertexEnumeration(Z1, Z2, tol);
    case 'polymax'
        isIn = polyhedralMaximization(Z1, Z2, tol);
    case 'opt'
        isIn = surrogateMaximization(Z1, Z2, tol, maxEval);
    case 'approx'
        isIn = SadraddiniTedrake(Z1, Z2, tol);
    case 'st'
        isIn = SadraddiniTedrake(Z1, Z2, tol);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now come the different methods for the zonotope containment problem.

function isIn = vertexEnumeration(Z1, Z2, tol)
% Solves the zonotope containment problem by checking whether the maximum
% value of the Z2-norm at one of the vertices of Z1 exceeds 1+tol. Checks
% every vertex until an answer is found (see also [2, Algorithm 1]).

% Let c1, c2 be the centers of Z1, Z2. We prepare the norm-function,
% returning the norm of v-c2 w.r.t. the Z2-norm, where v is a given vertex
% of Z1. Since v = c1 +- g_1 +- ... +- g_m, where g_i are the generators of
% Z1, the norm of v-c2 is the same as the norm of G*nu + c1-c2, where
% G is the generator matrix of Z1, nu = [+-1;...;+-1].
G = Z1.generators;
norm_Z2_nu = @(nu) zonotopeNorm(Z2, G*nu + Z1.center-Z2.center);

% Number of generators of Z1
m = size(G, 2);

% Create list of all combinations of generators we have to check (i.e., the
% choices of the +- signs from above). Note that this is a better strategy
% than computing the vertices directly, since it takes requires less
% memory.
% The next two lines produce all m-combinations of +-1
combinations = dec2bin(0:2^m-1)-'0';
combinations = 2*(combinations - 0.5);

for iter = combinations'
    if norm_Z2_nu(iter) > 1 - tol
        % If one vertex has norm larger than 1, it lies outside Z2, and
        % thus Z1 is not in Z2
        isIn = false;
        return
    end
end
% If no vertex of Z1 lies outside of Z2, Z1 lies in Z2
isIn = true;
end

function isIn = polyhedralMaximization(Z1, Z2, tol)
% Solves the zonotope containment problem by computing the maximal value of
% the polyhedral norm over Z1 w.r.t. Z2 (see also [2, Algorithm 2]).

% First, we need to shift Z2 so that it is centered around the origin
Z = Z2 - Z2.center;
% Then, we compute the halfspace representation
Z = halfspace(Z);

% We then need the normalized halfspace-matrix
H_norm = Z.halfspace.H ./ Z.halfspace.K;

% Similarly to vertexEnum, we need to create combinations from the pool of
% vectors given by [G c1-c2], where G is the generator matrix of Z1, and
% c1, c2 are the centers of Z1, Z2.
V = [Z1.generators Z1.center-Z2.center];

% Polyhedral norm at a point p
poly_norm = @(p) max([0 max(H_norm * p)]);

% Store signs for the main step (these are the signs that matter for the
% decision of the sign of the x_j in [2, Algorithm 2]).
M = sign(H_norm * V);

n = size(M, 1);

% Iterate over each row of M
for i = 1:n
    mu = M(i,:); % Sign-combination
    maximum = poly_norm(V*mu'); % Compute the resulting polyhedral norm
    if maximum > 1-tol % If we found a point with polyhedral norm larger
                       % than 1, we can stop the algorithm.
        isIn = false;
        return
    end
end
% If no point has norm larger than 1, this means that Z1 is contained
% within Z2.
isIn = true;
end

function isIn = surrogateMaximization(Z1, Z2, tol, maxEval)
% Solves the zonotope containment problem by checking whether the maximum
% value of the Z2-norm at one of the vertices of Z1 exceeds 1+tol, using
% surrogate optimization, see also [2].

% Retrieve the generator matrix of Z1 and determine its size
G = Z1.generators;
m = size(G, 2);

% Prepare objective function to be minimized (see [2], or also
% vertexEnumeration above, since the idea is similar).
% Note that we need to use nu' here instead of nu, since for surrogateopt
% the points are given as 1xn-arrays, unlike fmincon for example.
norm_Z2_nu = @(nu) -zonotopeNorm(Z2, G*nu' + Z1.center-Z2.center);

% Setting up options
options = optimoptions('surrogateopt',...
    'Display', 'none',... % Suppress output
    'PlotFcn', [],... % Supress plot output
    'ObjectiveLimit', -1+tol,... % Stop when a maximum > 1+tol has been
                             ... % found (i.e., a point of Z1 outside
                             ... % of Z2 has been found)
    'MaxFunctionEvaluations', maxEval); % Set maximum number of
                                        % function evaluations
                                        
% Launch the optimization. Note that the fourth argument ensures that the
% points that are tested are integer-points, since a maximum can only
% happen on one of the vertices of Z1, meaning that nu should only have
% the values +-1, i.e., integer values.
[~, fval] = surrogateopt(norm_Z2_nu, -ones([m 1])', ones([m 1])', ones([m 1])', options);

if -fval > 1 - tol
    isIn = false;
else
    isIn = true;
end
    
end

function isIn = SadraddiniTedrake(Z1, Z2, tol)
% Solves the containment problem using the method described in
% [1, Theorem 3]. Same notation as [1].

% Implemented by Felix Gruber

% extract data
x = Z1.center;
y = Z2.center;
X = Z1.generators;
Y = Z2.generators;
nx = size(X, 2);
ny = size(Y, 2);

% yalmip constructs linear programming matrices
Gamma = sdpvar(ny, nx, 'full');
beda = sdpvar(ny, 1);
constraints = [...
    X == Y*Gamma, ...
    y - x == Y*beda, ...
    norm([Gamma, beda], Inf) <= 1-tol];
cost = []; % It suffices to check feasibility here, so no cost function
options = sdpsettings('solver','linprog', 'verbose',0, 'allownonconvex',0); 

% solve linear programming problem
yalmipOptimizer = optimizer(constraints, cost, options,[],{Gamma, beda});

[~, exitFlag] = yalmipOptimizer();

isIn = ~exitFlag;
end  
