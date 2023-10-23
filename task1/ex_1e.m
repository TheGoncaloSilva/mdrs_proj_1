%% From ex: 1.c

C = 10;              % Link bandwidth (Mbps)
f = 1e6;             % Queue size (Bytes)
P = 1e5;             % Stopping criterion (number of packets)
lambda_values = [1000, 1300, 1600, 1900];  % Packet arrival rate (pps)

% Vectors to store the results
average_packet_delay = zeros(length(lambda_values), 1);
average_throughput = zeros(length(lambda_values), 1);
confidence_intervals_delay = zeros(length(lambda_values), 2);
confidence_intervals_throughput = zeros(length(lambda_values), 2);

% Run the simulator 20 times for each lambda value
for i = 1:length(lambda_values)
    lambda = lambda_values(i);
    num_simulations = 20;
    delays = zeros(num_simulations, 1);
    throughputs = zeros(num_simulations, 1);
    
    for j = 1:num_simulations
        [PL, APD, ~, TT] = Simulator1(lambda, C, f, P);
        delays(j) = APD;
        throughputs(j) = TT;
    end
    
    % Calculate the mean and 90% confidence interval
    average_packet_delay(i) = mean(delays);
    confidence_intervals_delay(i, :) = prctile(delays, [5, 95]);
    
    average_throughput(i) = mean(throughputs);
    confidence_intervals_throughput(i, :) = prctile(throughputs, [5, 95]);
end

% Bar Charts
figure;
subplot(2, 1, 1);
bar(average_packet_delay);
title('Average Packet Delay (Simulator1)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Delay (ms)');
hold on;
errorbar(1:length(lambda_values), average_packet_delay, average_packet_delay - confidence_intervals_delay(:, 1), confidence_intervals_delay(:, 2) - average_packet_delay, 'r.', 'LineWidth', 1);

subplot(2, 1, 2);
bar(average_throughput);
title('Average Throughput (Simulator1)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold on;
errorbar(1:length(lambda_values), average_throughput, average_throughput - confidence_intervals_throughput(:, 1), confidence_intervals_throughput(:, 2) - average_throughput, 'r.', 'LineWidth', 1);


%--------------------------------------------------------------------------
%% From ex: 1.d

C = 10;              % Link bandwidth (Mbps)
f = 1e6;             % Queue size (Bytes)
P = 1e5;             % Stopping criterion (number of packets)
b = 1e-5;            % Bit error rate
lambda_values = [1000, 1300, 1600, 1900];  % Packet arrival rate (pps)

% Vectors to store the results for Simulator2
average_packet_delay_sim2 = zeros(length(lambda_values), 1);
average_throughput_sim2 = zeros(length(lambda_values), 1);

% Run the simulations for each lambda value and the specified BER
for i = 1:length(lambda_values)
    lambda = lambda_values(i);
    num_simulations = 20;
    delays_sim2 = zeros(num_simulations, 1);
    throughputs_sim2 = zeros(num_simulations, 1);
    
    for j = 1:num_simulations
        [PL, APD, ~, TT] = Simulator2_e(lambda, C, f, P, b);
        delays_sim2(j) = APD;
        throughputs_sim2(j) = TT;
    end
    
    % Calculate the mean for Simulator2
    average_packet_delay_sim2(i) = mean(delays_sim2);
    average_throughput_sim2(i) = mean(throughputs_sim2);
end

% Display the results in bar charts for Simulator2
figure;
subplot(2, 1, 1);
bar(average_packet_delay_sim2);
title('Average Packet Delay (Simulator2)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Delay (ms)');
hold on;
errorbar(1:length(lambda_values), average_packet_delay_sim2, average_packet_delay_sim2 - confidence_intervals_delay(:, 1), confidence_intervals_delay(:, 2) - average_packet_delay_sim2, 'r.', 'LineWidth', 1);

subplot(2, 1, 2);
bar(average_throughput_sim2);
title('Average Throughput (Simulator2)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold on;
errorbar(1:length(lambda_values), average_throughput_sim2, average_throughput_sim2 - confidence_intervals_throughput(:, 1), confidence_intervals_throughput(:, 2) - average_throughput_sim2, 'r.', 'LineWidth', 1);
