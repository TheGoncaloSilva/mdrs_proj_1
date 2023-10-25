C = 10;              % Link bandwidth (Mbps)
f = 1e6;             % Queue size (Bytes)
P = 1e5;             % Stopping criterion (number of packets)
b = 1e-5;            % Bit error rate
lambda_values = [1000, 1300, 1600, 1900];  % Packet arrival rate (pps)

N = 20; % Number of simulations

% Vectors to store the results for Simulator2
average_packet_delay_sim2 = zeros(length(lambda_values), 1);
average_throughput_sim2 = zeros(length(lambda_values), 1);
confidence_intervals_delay_sim2 = zeros(length(lambda_values), 2);
confidence_intervals_throughput_sim2 = zeros(length(lambda_values), 2);

for i = 1:length(lambda_values)
    lambda = lambda_values(i);
    
    % Create vectors to store results of simulations for Simulator2
    delays_sim2 = zeros(N, 1);
    throughputs_sim2 = zeros(N, 1);
    
    for j = 1:N
        [PL, APD, ~, TT] = Simulator2(lambda, C, f, P, b);
        delays_sim2(j) = APD;
        throughputs_sim2(j) = TT;
    end
    
    % Calculate the mean and confidence interval for delay for Simulator2
    media = mean(delays_sim2);
    term = norminv(0.95) * sqrt(var(delays_sim2) / N);
    fprintf('Average Packet Delay for Simulator2 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_packet_delay_sim2(i) = media;
    confidence_intervals_delay_sim2(i, :) = [media - term, media + term];
    
    % Calculate the mean and confidence interval for throughput for Simulator2
    media = mean(throughputs_sim2);
    term = norminv(0.95) * sqrt(var(throughputs_sim2) / N);
    fprintf('Average Throughput for Simulator2 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_throughput_sim2(i) = media;
    confidence_intervals_throughput_sim2(i, :) = [media - term, media + term];
end

% Display the results in bar charts for Simulator2
figure;
subplot(2, 1, 1);
bar(average_packet_delay_sim2);
title('Average Packet Delay (Simulator2)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Delay (ms)');
hold on;
errorbar(1:length(lambda_values), average_packet_delay_sim2, average_packet_delay_sim2 - confidence_intervals_delay_sim2(:, 1), confidence_intervals_delay_sim2(:, 2) - average_packet_delay_sim2, 'r.', 'LineWidth', 1);

subplot(2, 1, 2);
bar(average_throughput_sim2);
title('Average Throughput (Simulator2)');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold on;
errorbar(1:length(lambda_values), average_throughput_sim2, average_throughput_sim2 - confidence_intervals_throughput_sim2(:, 1), confidence_intervals_throughput_sim2(:, 2) - average_throughput_sim2, 'r.', 'LineWidth', 1);
