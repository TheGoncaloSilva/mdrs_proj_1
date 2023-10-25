C = 10;              % Link bandwidth (Mbps)
f = 1e6;             % Queue size (Bytes)
P = 1e5;             % Stopping criterion (number of packets)
lambda_values = [1000, 1300, 1600, 1900];  % Packet arrival rate (pps)

N = 20; % Number of simulations

% Vectors to store the results
average_packet_delay = zeros(length(lambda_values), 1);
average_throughput = zeros(length(lambda_values), 1);
confidence_intervals_delay = zeros(length(lambda_values), 2);
confidence_intervals_throughput = zeros(length(lambda_values), 2);

for i = 1:length(lambda_values)
    lambda = lambda_values(i);
    
    % Create vectors to store results of simulations
    delays = zeros(N, 1);
    throughputs = zeros(N, 1);
    
    for j = 1:N
        [PL, APD, ~, TT] = Simulator1(lambda, C, f, P);
        delays(j) = APD;
        throughputs(j) = TT;
    end
    
    % Calculate the mean and confidence interval for delay
    media = mean(delays);
    term = norminv(0.95) * sqrt(var(delays) / N);
    fprintf('Average Packet Delay for lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_packet_delay(i) = media;
    confidence_intervals_delay(i, :) = [media - term, media + term];
    
    % Calculate the mean and confidence interval for throughput
    media = mean(throughputs);
    term = norminv(0.95) * sqrt(var(throughputs) / N);
    fprintf('Average Throughput for lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_throughput(i) = media;
    confidence_intervals_throughput(i, :) = [media - term, media + term];
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
