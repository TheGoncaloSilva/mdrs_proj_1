%% Ex: 2.a
n = [10,20,30,40];
APD = zeros(length(n), 4);
for i=1:length(n)
    [APD(i,1), APD(i,2),APD(i,3), APD(i,4)] = average_packet_delay(n(i));
    fprintf('For n=%d VoIP flows, the Av. Packet Delay of data (ms)  = %.2e +- %.2e\n', n(i), APD(i,1), APD(i,2))
    fprintf('For n=%d VoIP flows, the Av. Packet Delay od VoIP (ms)  = %.2e +- %.2e\n', n(i), APD(i,3), APD(i,4))
end

bar(n,APD(:,1));
hold on
title('Avg Packet Delay of Data based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg Data Packet Delay (ms)');
er = errorbar(n,APD(:,1),APD(:,2),APD(:,2), 'r.');                               
er.LineStyle = 'none';
hold off

bar(n,APD(:,3));
hold on
title('Avg Packet Delay of VoIP based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg VoIP Packet Delay (ms)');
er = errorbar(n,APD(:,3),APD(:,4),APD(:,4), 'r.');                               
er.LineStyle = 'none';
hold off

function [avg_data,trust_data, avg_voip, trust_voip]=average_packet_delay(n)
    Iter = 20;         %number of simulations
    Lambda = 1800;  %pps
    F = 1000000;    %Bytes
    P = 100000;
    C = 10;
    PLdata = zeros(1,Iter); %vector with N simulation values
    PLvoip = zeros(1,Iter); %vector with N simulation values
    APDdata = zeros(1,Iter); %vector with N simulation values
    APDvoip = zeros(1,Iter); %vector with N simulation values
    MPDdata = zeros(1,Iter); %vector with N simulation values
    MPDvoip = zeros(1,Iter); %vector with N simulation values
    TT = zeros(1,Iter); %vector with N simulation values
    
    for it= 1:Iter
        [PLdata(it),PLvoip(it),APDdata(it),APDvoip(it),MPDdata(it),MPDvoip(it),TT(it)] = Simulator3(Lambda, C, F, P, n);
    end
    alfa= 0.1; % 90% confidence interval %
    avg_data = mean(APDdata);
    trust_data = norminv(1-alfa/2)*sqrt(var(APDdata)/Iter);
    avg_voip = mean(APDvoip);
    trust_voip = norminv(1-alfa/2)*sqrt(var(APDvoip)/Iter);
end