%% Ex: 2.a
n = [10,20,30,40];
APD = zeros(length(n), 4);
AQD = zeros(length(n), 4);
for i=1:length(n)
    [APD(i,1), APD(i,2),APD(i,3), APD(i,4), AQD(i,1), AQD(i,2),AQD(i,3), AQD(i,4)] = average_packet_delay(n(i));
    fprintf('For n=%d:\n',n(i));
    fprintf('\tVoIP flows, the Av. Packet Delay of data (ms)  = %.2e +- %.2e\n', APD(i,1), APD(i,2))
    fprintf('\tVoIP flows, the Av. Packet Delay of VoIP (ms)  = %.2e +- %.2e\n', APD(i,3), APD(i,4))
    fprintf('\tVoIP flows, the Av. Queuing Delay of data (ms)  = %.2e +- %.2e\n', AQD(i,1), AQD(i,2))
    fprintf('\tVoIP flows, the Av. Queuing Delay of VoIP (ms)  = %.2e +- %.2e\n', AQD(i,3), AQD(i,4))
end

figure;
subplot(2, 1, 1);
bar(n,APD(:,1));
hold on
title('Avg Packet Delay of Data based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg Data Packet Delay (ms)');
er = errorbar(n,APD(:,1),APD(:,2),APD(:,2), 'r.');                               
er.LineStyle = 'none';
hold off

subplot(2, 1, 2);
bar(n,APD(:,3));
hold on
title('Avg Packet Delay of VoIP based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg VoIP Packet Delay (ms)');
er = errorbar(n,APD(:,3),APD(:,4),APD(:,4), 'r.');                               
er.LineStyle = 'none';
hold off

figure;
subplot(2, 1, 1);
bar(n,AQD(:,1));
hold on
title('Avg Queuing Delay of Data based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg Data Queuing Delay (ms)');
er = errorbar(n,AQD(:,1),AQD(:,2),AQD(:,2), 'r.');                               
er.LineStyle = 'none';
hold off

subplot(2, 1, 2);
bar(n,AQD(:,3));
hold on
title('Avg Queuing Delay of VoIP based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg VoIP Queuing Delay (ms)');
er = errorbar(n,AQD(:,3),AQD(:,4),AQD(:,4), 'r.');                               
er.LineStyle = 'none';
hold off

function [avg_data,trust_data, avg_voip, trust_voip, avg_queue_data, trust_queue_data, avg_queue_voip, trust_queue_voip]=average_packet_delay(n)
    Iter = 20;         %number of simulations
    Lambda = 1500;  %pps
    F = 1000000;    %Bytes
    P = 100000;
    C = 10;
    APDdata = zeros(1,Iter); %vector with N simulation values
    APDvoip = zeros(1,Iter); %vector with N simulation values
    AQDdata = zeros(1,Iter); %vector with N simulation values
    AQDvoip = zeros(1,Iter); %vector with N simulation values
      
    for it= 1:Iter
        [~,~,APDdata(it),APDvoip(it),AQDdata(it),AQDvoip(it),~,~,~] = Simulator4(Lambda, C, F, P, n);
    end
    alfa= 0.1; % 90% confidence interval %
    avg_data = mean(APDdata);
    trust_data = norminv(1-alfa/2)*sqrt(var(APDdata)/Iter);
    avg_voip = mean(APDvoip);
    trust_voip = norminv(1-alfa/2)*sqrt(var(APDvoip)/Iter);
    avg_queue_data = mean(AQDdata);
    trust_queue_data = norminv(1-alfa/2)*sqrt(var(AQDdata)/Iter);
    avg_queue_voip = mean(AQDvoip);
    trust_queue_voip = norminv(1-alfa/2)*sqrt(var(AQDvoip)/Iter);
end