

%% Step 0: Preliminaries
clear
disp('-------------------------------------------------------------------')
disp(['Started: ' datestr(now)])
tic
%% Step 1: Choose parameter values
alpha = 0.33;
beta  = 0.90;
delta = 0.10;
%% Step 2: Solve for the steady-state capital
k_ss = ( alpha*beta/(1-beta*(1-delta)) )^(1/(1-alpha));%steady-state k
%% Step 3: Choose the state space for capital 
n = 1e3;
k_min = 0.05*k_ss;
k_max = 2.00*k_ss;
k_space = linspace(k_min,k_max,n)';
k = k_space; % size = [n 1]
K = repmat(k,1,n); % size = [n n]
K_prime = K';
%% Step 4: Choose the initial value function
% The initial value function
% Setting v0 = 0 works but it takes more iterations to converge
init_val = 2;
if init_val==1
    v0 = zeros(size(k));
elseif init_val==2
    v0 = log(k.^alpha - delta*k)./(1-beta);
else
    error("init_val must be 1 or 2")
end
    
%% Step 5: Update the value function
iter = 1;
conv = 0;
max_iter = 1e3;
tol = eps;

V = zeros(n,max_iter);
V(:,1) = v0;
while conv==0 && iter<max_iter
    %disp(iter);
    VK_prime = repmat(v0',n,1);
    C = K.^alpha + (1-delta)*K - K_prime;
    C = C.*(C>0) + eps*(C<=0);
    X = log(C) + beta*VK_prime;
    v1 = max(X,[],2);
    V(:,iter+1) = v1;
    %% Step 6: Check if the value function has converged
    if abs(v1-v0)<tol
        conv = 1;
        disp(['Converged in ' num2str(iter) ' iterations!'])
    else
        iter = iter + 1;
        v0 = v1;
    end
end
toc
%% Step 101: Plot the value function
figure('color','w','Units','centimeters','Position',[5 5 15 10]);
hold on
plot(k,V(:,1),'r','LineWidth',2);
for pp = 2:iter-1
    plot(k,V(:,pp));
end
plot(k,v1,'k','LineWidth',2);
hold off
xlabel('k');
ylabel('v(k)');
title('Value Function Convergence');
if init_val==1
    text(3.00,0.30,"v_0(k)",'Color','red')
    text(0.50,-2.1,"v(k)",'Color','black')
    text(2,-2,['Converged in ' num2str(iter) ' iterations'])
    set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
    saveas(gcf,'valueiter1.pdf')
elseif init_val==2
    text(0.25,-6.00,"v_0(k)",'Color','red')
    text(0.25,-1.3,"v(k)",'Color','black')
    text(2,-2,['Converged in ' num2str(iter) ' iterations'])
    set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
    saveas(gcf,'valueiter2.pdf')
end

figure('color','w','Units','centimeters','Position',[5 5 15 10]);
plot(k,v1,'k','LineWidth',2);
xlabel('k');
ylabel('v(k)');
title('The Value Function');
set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
saveas(gcf,'valueiter3.pdf')

%% Step 102: Save the necessary files
save('valueiter.mat', 'k', 'v1')
%% Step 103: End
toc
disp(['Ended: ' datestr(now)])
disp('-------------------------------------------------------------------')
