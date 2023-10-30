C = [10,20,30,40]; % Mbps
K = 1800;

for i=1:length(C)
    capacity = C(i)*10^6;
    fprintf('For C=%d:\n', C(i));
    prob_left = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 65 + 1) + (1517 - 111 + 1));
    avg_bytes = 0.19*64 + 0.23*110 + 0.17*1518 + sum((65:109)*(prob_left)) + sum((111:1517)*(prob_left));
    avg_time = avg_bytes * 8 / capacity;
 
    fprintf("\tAverage packet size is: %.2f Bytes\n", avg_bytes);
    fprintf("\tAverage packet trasmission time is: %.2e seconds\n", avg_time);
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
    end
    
    Es = sum(s);
    Es2 = sum(s2);

    fprintf('\tE[S] = %.2e seconds\n', Es);
    fprintf('\tE[S2] = %.2e seconds\n', Es2);
    
    Wq = (K * Es2) / (2 * (1 - K * Es));
    W = Wq + Es;% W = Wq + E[s]
    fprintf('\tWq = %.4f ms\n', Wq*1000);
    fprintf('\tW = %.4f ms\n', W*1000);

end