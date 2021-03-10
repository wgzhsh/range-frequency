%  for two-dimension data
% different epsilon

%% Plot setting
clc; clear; close all;
set(0,'defaulttextinterpreter','latex'); 
set(0,'defaultlinelinewidth',2); 
set(0,'DefaultLineMarkerSize',10); 
set(0,'DefaultTextFontSize', 12); 
set(0,'DefaultAxesFontSize',12); 

tempColor = hsv(5);
myColor.LE = tempColor(1,:); myMarker.LE = '^';
myColor.RR = tempColor(2,:); myMarker.RR = 'square';
myColor.OU = tempColor(3,:); myMarker.OU = 'o';
myColor.EM = tempColor(4,:); myMarker.EM = '*';
myColor.PL = tempColor(5,:); myMarker.PL = 'diamond';



%% setting
side = 10; 

N_loc = side^2;
myEpsilon =  [1:5];
N_epsilon = length(myEpsilon);



temp = randperm(N_loc);
temp = temp(1:ceil(N_loc/5));
xt = zeros(1,N_loc); 
xt(temp) = rand(1,length(temp));
xt = xt/sum(xt);

locations = zeros(N_loc,2);
for k = 1:side
    for j = 1:side
        index = side*(k-1)+j;
        locations(index,:) = [k j];
    end
end

     
D = zeros(N_loc,N_loc); % distance between locations
for k = 1:N_loc
    for j = 1:N_loc
        D(k,j) = norm(locations(k,:)-locations(j,:),2);
    end
end

%% error analysis

N_test = 3; % for experimental result
for i = 1:N_epsilon
    
    epsilon = myEpsilon(i);
    
    Prob.RR = RR(D, epsilon); 
    [MSE.RR(i), Err.RR(i)] = myMSE(Prob.RR,xt);  
    [exMSE.RR(:,i), exErr.RR(:,i)] = actualMSE(Prob.RR,xt,N_test);  
    
    [MSE.OU(i), Prob.OU] = OU(D, epsilon);   
    exMSE.OU(:,i) = actualMSE_unary(Prob.OU,xt,N_test); 
    
    Prob.EM = EM(D, epsilon);   
    [MSE.EM(i), Err.EM(i)] = myMSE(Prob.EM,xt);
    [exMSE.EM(:,i), exErr.EM(:,i)] = actualMSE(Prob.EM,xt,N_test); 
    
    Prob.LE = LE(D, epsilon);
    [MSE.LE(i), Err.LE(i)] = myMSE(Prob.LE,xt); 
    [exMSE.LE(:,i), exErr.LE(:,i)] = actualMSE(Prob.LE,xt,N_test); 
    
    [exMSE.PL(:,i), exErr.PL(:,i)] = PL(locations,D,epsilon,xt,N_test);
       
end


%% Plot
figure(1);
ah1 = TightPlots(1, 2, 700,[10 8],[80,80],[50,50],[70,20],'pixels');

axes(ah1(1));
plot(myEpsilon,Err.RR,'--','Color',myColor.RR,'Marker',myMarker.RR); hold on;
plot(myEpsilon,Err.EM,'--','Color',myColor.EM,'Marker',myMarker.EM); hold on;
plot(myEpsilon,Err.LE,'--','Color',myColor.LE,'Marker',myMarker.LE); hold on;
plot(myEpsilon,exErr.RR(1,:),'Color',myColor.RR,'Marker',myMarker.RR); hold on;
plot(myEpsilon,exErr.EM(1,:),'Color',myColor.EM,'Marker',myMarker.EM); hold on;
plot(myEpsilon,exErr.LE(1,:),'Color',myColor.LE,'Marker',myMarker.LE); hold on;
plot(myEpsilon,exErr.PL(1,:),'Color',myColor.PL,'Marker',myMarker.PL); hold on;
set(gca,'xtick',myEpsilon);
xlim([myEpsilon(1),myEpsilon(end)]);
ylim([0 1]);
xlabel('$\epsilon$');
ylabel('Error (Range Query)');
text(min(myEpsilon),1.16,'Theoretical:');
text(min(myEpsilon),1.08,'~~Empirical:');


axes(ah1(2));
plot(myEpsilon,MSE.RR,'--','Color',myColor.RR,'Marker',myMarker.RR); hold on;
plot(myEpsilon,MSE.OU,'--','Color',myColor.OU,'Marker',myMarker.OU); hold on;
plot(myEpsilon,MSE.EM,'--','Color',myColor.EM,'Marker',myMarker.EM); hold on;
plot(myEpsilon,MSE.LE,'--','Color',myColor.LE,'Marker',myMarker.LE); hold on;
plot(myEpsilon,exMSE.PL(1,:),'Color',[1 1 1],'Marker',myMarker.PL); hold on;
plot(myEpsilon,exMSE.RR(1,:),'Color',myColor.RR,'Marker',myMarker.RR); hold on;
plot(myEpsilon,exMSE.OU(1,:),'Color',myColor.OU,'Marker',myMarker.OU); hold on;
plot(myEpsilon,exMSE.EM(1,:),'Color',myColor.EM,'Marker',myMarker.EM); hold on;
plot(myEpsilon,exMSE.LE(1,:),'Color',myColor.LE,'Marker',myMarker.LE); hold on;
plot(myEpsilon,exMSE.PL(1,:),'Color',myColor.PL,'Marker',myMarker.PL); hold on;


set(gca,'xtick',myEpsilon);
set(gca,'ytick',10.^(-1:5));
set(gca,'yscale','log');
xlim([myEpsilon(1),myEpsilon(end)]);
xlabel('$\epsilon$');
ylabel('MSE (Frequency Estimation)');
ylim([0.05 3600]);
legend({'RR','OU','EM','LE',' ','RR','OU','EM','LE','PL'},'Box','off','Orientation','horizon','NumColumns',5);


