N = [10,20,30,40]; % Mbps
K = 1500;

w_data = zeros(size(N));
wq_data = zeros(size(N));
w_voip = zeros(size(N));
wq_voip = zeros(size(N));


for i=1:length(N)
    capacity = 10*10^6;
    flow = N(i);
    fprintf('For N=%d:\n', flow);

    % higher priority
    [Esvoip, Esvoip2] = calculate_voip_meanStime(capacity, flow);  
    p1 = K * Esvoip;
    Wq1 = (K * Esvoip2) / (2 * (1 - p1));
    W1 = Wq1 + Esvoip;% W = Wq + E[s]
    fprintf('\tWq voip = %.4f ms\n', Wq1*1000);
    fprintf('\tW voip = %.4f ms\n', W1*1000);
    wq_voip(i) = Wq1*1000;
    w_voip(i) = W1*1000;
    

    % lower priority
    [Esdata, Esdata2] = calculate_data_meanStime(capacity, flow);
    p2 = K * Esdata;
    Wq2 = (K * Esdata2) / (2 * (1 - p1) * (1 - p1 - p2));
    W2 = Wq2 + Esdata;% W = Wq + E[s]
    fprintf('\tWq data = %.4f ms\n', Wq2*1000);
    fprintf('\tW data = %.4f ms\n', W2*1000);
    wq_data(i) = Wq2*1000;
    w_data(i) = W2*1000;

end

figure;
subplot(2, 1, 1);
bar(N,w_data);
hold on
title('Avg Packet Delay of Data based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg Data Packet Delay (ms)');
hold off

subplot(2, 1, 2);
bar(N,w_voip);
hold on
title('Avg Packet Delay of VoIP based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg VoIP Packet Delay (ms)');
hold off

figure;
subplot(2, 1, 1);
bar(N,wq_data);
hold on
title('Avg Queuing Delay of Data based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg Data Queuing Delay (ms)');
hold off

subplot(2, 1, 2);
bar(N,wq_voip);
hold on
title('Avg Queuing Delay of VoIP based on VoIP flows');
xlabel('n (VoIP flows)');
ylabel('Avg VoIP Queuing Delay (ms)');
hold off

function [Es, Es2] = calculate_voip_meanStime(capacity, flows)
    indiv_prob = 1/(130-110);
    avg_bytes = sum((110:130)*(indiv_prob));
    avg_time = avg_bytes * 8 / capacity;
 
    %fprintf("\tAvg voip packet size is: %.2f Bytes\n", avg_bytes);
    %fprintf("\tAvg voip packet trans. time is: %.2e seconds\n", avg_time);
    x = 110:130;
    s = (x .* 8) ./ (capacity);
    s2 = (x .* 8) ./ (capacity);
    for i = 1:length(x)
        % Also account for the impact of VoIP flows in the mean service time
        s(i) = s(i) * indiv_prob * (1 - 1/flows);
        s2(i) = s2(i)^2 * indiv_prob * (1 - 1/flows);;
    end
    
    Es = sum(s);
    Es2 = sum(s2);

    %fprintf('\tE[S] voip = %.2e seconds\n', Es);
    %fprintf('\tE[S2] voip = %.2e seconds\n', Es2);
end

function [Es, Es2] = calculate_data_meanStime(capacity,flows)
    prob_left = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 65 + 1) + (1517 - 111 + 1));
    avg_bytes = 0.19*64 + 0.23*110 + 0.17*1518 + sum((65:109)*(prob_left)) + sum((111:1517)*(prob_left));
    avg_time = avg_bytes * 8 / capacity;
 
    %fprintf("\tAvg data packet size is: %.2f Bytes\n", avg_bytes);
    %fprintf("\tAvg data packet trans. time is: %.2e seconds\n", avg_time);
    x = 64:1518;
    s = (x .* 8) ./ (capacity);
    s2 = (x .* 8) ./ (capacity);
    for i = 1:length(x)
        if i == 1
            s(i) = s(i) * 0.19;
            s2(i) = s2(i)^2 * 0.19;
        elseif i == 110-64+1
            s(i) = s(i) * 0.23;
            s2(i) = s2(i)^2 * 0.23;
        elseif i == 1518-64+1
            s(i) = s(i) * 0.17;
            s2(i) = s2(i)^2 * 0.17;
        else
            s(i) = s(i) * prob_left;
            s2(i) = s2(i)^2 * prob_left;
        end
        % Account for the impact of VoIP flows in the mean service time
        s(i) = s(i) * (1 - 1/flows);  
        s2(i) = s2(i) * (1 - 1/flows);  
    end
    
    Es = sum(s);
    Es2 = sum(s2);

    %fprintf('\tE[S] data = %.2e seconds\n', Es);
    %fprintf('\tE[S2] data = %.2e seconds\n', Es2);
end