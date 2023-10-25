C = 10;              % Link bandwidth (Mbps)
f = 1e6;             % Queue size (Bytes)
P = 1e5;             % Stopping criterion (number of packets)
lambda_values = [1000, 1300, 1600, 1900];  % Packet arrival rate (pps)

% Vectors to store the results for Simulator1 with new packet size distribution
average_packet_delay_new_sizes_sim1 = zeros(length(lambda_values), 1);
average_throughput_new_sizes_sim1 = zeros(length(lambda_values), 1);
confidence_intervals_delay_new_sizes_sim1 = zeros(length(lambda_values), 2);
confidence_intervals_throughput_new_sizes_sim1 = zeros(length(lambda_values), 2);

% Vectors to store the results for Simulator2 with new packet size distribution
average_packet_delay_new_sizes_sim2 = zeros(length(lambda_values), 1);
average_throughput_new_sizes_sim2 = zeros(length(lambda_values), 1);
confidence_intervals_delay_new_sizes_sim2 = zeros(length(lambda_values), 2);
confidence_intervals_throughput_new_sizes_sim2 = zeros(length(lambda_values), 2);

% Define the new packet size probabilities
packet_size_probabilities = [0.25, 0.17, 0.11];
packet_sizes = [64, 110, 1518];
num_simulations = 20;

for i = 1:length(lambda_values)
    lambda = lambda_values(i);
    
    % Create vectors to store results of simulations for both simulators
    delays_sim1 = zeros(num_simulations, 1);
    throughputs_sim1 = zeros(num_simulations, 1);
    delays_sim2 = zeros(num_simulations, 1);
    throughputs_sim2 = zeros(num_simulations, 1);
    
    for j = 1:num_simulations
        % Generate random packet sizes based on the specified probabilities
        packet_size_sim1 = randsample(packet_sizes, 1, true, packet_size_probabilities);
        packet_size_sim2 = randsample(packet_sizes, 1, true, packet_size_probabilities);
        
        % Run Simulator1 with new packet size
        [PL, APD, ~, TT] = Simulator1(lambda, C, packet_size_sim1, P);
        delays_sim1(j) = APD;
        throughputs_sim1(j) = TT;
        
        % Run Simulator2 with new packet size and BER
        [PL, APD, ~, TT] = Simulator2_e(lambda, C, packet_size_sim2, P, b);
        delays_sim2(j) = APD;
        throughputs_sim2(j) = TT;
    end
    
    % Calculate the mean and confidence interval for delay and throughput for both simulators
    media = mean(delays_sim1);
    term = norminv(0.95) * sqrt(var(delays_sim1) / num_simulations);
    fprintf('Average Packet Delay for Simulator1 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_packet_delay_new_sizes_sim1(i) = media;
    confidence_intervals_delay_new_sizes_sim1(i, :) = [media - term, media + term];
    
    media = mean(throughputs_sim1);
    term = norminv(0.95) * sqrt(var(throughputs_sim1) / num_simulations);
    fprintf('Average Throughput for Simulator1 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_throughput_new_sizes_sim1(i) = media;
    confidence_intervals_throughput_new_sizes_sim1(i, :) = [media - term, media + term];
    
    media = mean(delays_sim2);
    term = norminv(0.95) * sqrt(var(delays_sim2) / num_simulations);
    fprintf('Average Packet Delay for Simulator2 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_packet_delay_new_sizes_sim2(i) = media;
    confidence_intervals_delay_new_sizes_sim2(i, :) = [media - term, media + term];
    
    media = mean(throughputs_sim2);
    term = norminv(0.95) * sqrt(var(throughputs_sim2) / num_simulations);
    fprintf('Average Throughput for Simulator2 with lambda = %d: %.2f +- %.2f\n', lambda, media, term);
    
    average_throughput_new_sizes_sim2(i) = media;
    confidence_intervals_throughput_new_sizes_sim2(i, :) = [media - term, media + term];
end

% Bar Charts for Simulator1 with new packet size distribution
figure;
subplot(2, 1, 1);
bar(average_packet_delay_new_sizes_sim1);
title('Average Packet Delay (Simulator1) - New Packet Size Distribution');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Delay (ms)');
hold on;
errorbar(1:length(lambda_values), average_packet_delay_new_sizes_sim1, average_packet_delay_new_sizes_sim1 - confidence_intervals_delay_new_sizes_sim1(:, 1), confidence_intervals_delay_new_sizes_sim1(:, 2) - average_packet_delay_new_sizes_sim1, 'r.', 'LineWidth', 1);

subplot(2, 1, 2);
bar(average_throughput_new_sizes_sim1);
title('Average Throughput (Simulator1) - New Packet Size Distribution');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold on;
errorbar(1:length(lambda_values), average_throughput_new_sizes_sim1, average_throughput_new_sizes_sim1 - confidence_intervals_throughput_new_sizes_sim1(:, 1), confidence_intervals_throughput_new_sizes_sim1(:, 2) - average_throughput_new_sizes_sim1, 'r.', 'LineWidth', 1);

% Bar Charts for Simulator2 with new packet size distribution
figure;
subplot(2, 1, 1);
bar(average_packet_delay_new_sizes_sim2);
title('Average Packet Delay (Simulator2) - New Packet Size Distribution');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Delay (ms)');
hold on;
errorbar(1:length(lambda_values), average_packet_delay_new_sizes_sim2, average_packet_delay_new_sizes_sim2 - confidence_intervals_delay_new_sizes_sim2(:, 1), confidence_intervals_delay_new_sizes_sim2(:, 2) - average_packet_delay_new_sizes_sim2, 'r.', 'LineWidth', 1);

subplot(2, 1, 2);
bar(average_throughput_new_sizes_sim2);
title('Average Throughput (Simulator2) - New Packet Size Distribution');
xlabel('Packet Arrival Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold on;
errorbar(1:length(lambda_values), average_throughput_new_sizes_sim2, average_throughput_new_sizes_sim2 - confidence_intervals_throughput_new_sizes_sim2(:, 1), confidence_intervals_throughput_new_sizes_sim2(:, 2) - average_throughput_new_sizes_sim2, 'r.', 'LineWidth', 1);



