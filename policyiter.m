%{
This files computes the numerical value and policy functions for the 
neo-classical growth model with log utility by iterating on the policy 
function.

Created: 27-Aug-2022 15:48:10
Author: Aamir Rafique Hashmi
        Department of Economics
        University of Calgary
        Calgary, AB, Canada
Email: Aamir.Hashmi@UCalgary.ca
%}
%% Step 0: Preliminaries
clear
tic
%% Step 1: Choose parameter values
alpha = 0.33;   % Share of capital in output
beta = 0.90;    % Discount factor
rho = 1/beta - 1;   % Discount rate
delta = 0.10;   % Capital depreciation rate
%% Step 2: Solve for the steady-state capital
k_ss = ( alpha*beta/(1-beta*(1-delta)) )^(1/(1-alpha)); % Steady-state k
%% Step 3: Choose the state space for capital
n = 1e3; % Size of the state space
k_min = 0.05*k_ss;  % Minimum capital
k_max = 2.00*k_ss;  % Maximum capital
k_space = linspace(k_min,k_max,n);
k_space=k_space';
k = k_space;
%% Step 4: Guess a feasible initial policy function gk0
gk0 = k_space; %Initial policy function
%% Step 5: Use gk0 to compute value function vk
conv = 0; 
iter = 1;
while conv == 0 && iter <100
    gk = gk0;
    %get the value function vk operating on gk (use linear interpolation)
    T = 1000;
    vk = zeros(size(k));
    k_old = k;
    for t = 0:T
        k_new = interp1(k_space,gk,k_old);
        c = k_old.^alpha+(1-delta)*k_old-k_new;
        c = c.*(c>0)+eps*(c<=0);%set non-positive consumption equal to 'eps'
        r = (beta^t).*log(c);
        vk = vk + r;
        k_old = k_new;
    end
    %% Step 6: Update gk0 to gk1
    %use vk to update the policy function gk
    k_diff = diff(k_space);%find the differences between k values
    vk_diff = diff(vk);%find the differences between vk values
    %find numerical derivative of vk
    dvk0 = vk_diff./k_diff;
    dvk = [dvk0(1);zeros(length(dvk0)-1,1);dvk0(length(dvk0))];
    for i = 2:length(dvk0)
        dvk(i) = (dvk0(i-1)+dvk0(i))/2;
    end
    %find k' that solves the FOC: k' + (1/beta*dv(k')) - k^alpha - (1-alpha)*k = 0;
    k_fine = linspace(k_min,k_max,100*n);
    dvk_fine = interp1(k_space,dvk,k_fine);
    gk1 = zeros(size(k_space));
    for i = 1:n
        dif = k(i)^alpha + (1-delta)*k(i) - k_fine - (1./(beta*dvk_fine));
        [Y,I] = min(abs(dif));
        gk1(i) = k_fine(I);
    end
     %figure;plot(k,gk1);hold;plot(k,k,'r');hold;
    %% Step 7: Check for convergence
    if abs(gk1-gk0)<eps
        conv=1;
        %disp('iter');
        disp('convergence!');
    else
        iter = iter+1;
        disp([num2str(iter) ' ' datestr(now)]);
        gk0 = gk1;
    end
end
c = k.^alpha + (1-delta)*k - gk;
c_ss = k_ss.^alpha + (1-delta)*k_ss - k_ss;
y = k.^alpha;
s = y - c;
s_rate = s./y;
s_rate_ss = alpha*delta/(delta+rho);

kdotzero = y - delta*k;

figure('color','w','Units','centimeters','Position',[5 5 15 10]);
plot(k,gk,'k','LineWidth',1.5);hold;
plot(k,k,'r','LineWidth',0.5);
line([k_ss k_ss],[0    k_ss],'color','k','LineWidth',0.5,'LineStyle','--');
line([0    k_ss],[k_ss k_ss],'color','k','LineWidth',0.5,'LineStyle','--');
axis([0 k_max 0 k_max]);
xlabel('k');
ylabel('g(k)');
title('Policy Function g(k)');
text(2.4,3.3,"45-degree line",'Color','red')
text(3,2.7,"g(k)",'Color','black')
set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
saveas(gcf,'policyiter1.pdf')

figure('color','w','Units','centimeters','Position',[5 5 15 10]);
plot(k,kdotzero,'r','LineWidth',0.5);hold;
line([k_ss k_ss],[0 2],'color','r','LineWidth',0.5);
plot(k,c,'k','LineWidth',2.0);
line([0    k_ss],[c_ss c_ss],'color','k','LineWidth',0.5,'LineStyle','--');
axis([0 k_max 0 2]);
xlabel('k');
ylabel('c');
title('Saddle Path');
text(2,1.8,"c-dot=0 line",'Color','red')
text(3,1.08,"k-dot=0 line",'Color','red')
text(3,1.47,"c(k)",'Color','black')
set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
saveas(gcf,'policyiter2.pdf')

figure('color','w','Units','centimeters','Position',[5 5 15 10]);
plot(k,vk,'k','LineWidth',1.5);hold;
%line([k_ss k_ss],[0    k_ss],'color','k','LineWidth',0.5,'LineStyle','--');
%line([0    k_ss],[k_ss k_ss],'color','k','LineWidth',0.5,'LineStyle','--');
%axis([0 k_max 0 k_max]);
xlabel('k');
ylabel('v(k)');
title('Value Function v(k)');
set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
saveas(gcf,'policyiter3.pdf')

figure('color','w','Units','centimeters','Position',[5 5 15 10]);
plot(k,s_rate,'k','LineWidth',2.0);
line([k_min k_max],[s_rate_ss s_rate_ss],'color','r','LineWidth',0.5);
axis([k_min k_max 0 0.50]);
xlabel('k');
ylabel('Saving Rate');
title('Saving Rate in Transition');
text(2.5,0.18,"Steady-state saving rate",'Color','red')
set(gcf, 'PaperPositionMode', 'auto'); % The saved figure will have the same size as we see it on screen
saveas(gcf,'policyiter4.pdf')

save('policyiter.mat', 'k_space', 'vk', 'gk1', 'k_ss')

toc