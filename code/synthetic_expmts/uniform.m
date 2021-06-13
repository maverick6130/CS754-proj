clear;
close all;
clc;
 
% Uniform distribution rotated 30 degree acw
theta = 30;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
X = R * (10.*rand(2, 1000) - 5);
H = eye(2);
lambda = 1;
epsilon = 1e-5;

% SOT Result with annealing
l_term = 10;
while l_term > lambda
    G = basicSOT(H,X,lambda, epsilon);
    l_term = l_term - 2;
end
scatter(X(1,:), X(2,:));
hold on;
plot([0, 10*G(1,1)], [0, 10*G(2,1)], 'r');
hold on;
plot([0, 10*G(1,2)], [0, 10*G(2,2)], 'r');

% KLT Result
[V,D] = eig(X * X.');
hold on;
plot([0, 10*V(1,1)], [0, 10*V(2,1)], 'g');
hold on;
plot([0, 10*V(1,2)], [0, 10*V(2,2)], 'g');

Sot_Cost = CNCost(G, X, lambda)
Klt_Cost = CNCost(V, X, lambda)
Rel = abs(Sot_Cost - Klt_Cost)/Klt_Cost

title('SOT vs KLT for Uniform Distribution Rotated at angle');