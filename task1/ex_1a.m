C = [10,20,30,40];
APD = zeros(length(C), 2);
for i=1:length(C)
    APD(i,:) = average_packet_delay(C(i));
end

bar(C,APD(:,1));
hold on
er = errorbar(C,APD(:,1),APD(:,2),APD(:,2));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

function [avg,trust]=average_packet_delay(capacity)
    N = 20;         %number of simulations
    Lambda = 1800;  %pps
    F = 1000000;    %Bytes
    P = 100000;
    PL = zeros(1,N); %vector with N simulation values
    APD = zeros(1,N); %vector with N simulation values
    MPD = zeros(1,N); %vector with N simulation values
    TT = zeros(1,N); %vector with N simulation values
    
    for it= 1:N
        [PL(it),APD(it),MPD(it),TT(it)] = Simulator1(Lambda, capacity, F, P);
    end
    alfa= 0.1; % 90% confidence interval %
    avg = mean(APD);
    trust = norminv(1-alfa/2)*sqrt(var(APD)/N);
end