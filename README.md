# MDRS Mini-Project 1

This is a report the First Mini-Project of MDRS university class, entitled **Performance Evaluation of Point-to-Point Links Supporting Packet Services**. The work carried out was conducted by:
* Gonçalo Silva, 103244 - Participation 50%
* Catarina Barroqueiro, 103895 - Participation 50%

## Exercise 1.a
### Code
Taking advantage of the already developed *Simulator1* we used the *average_packet_delay* to process the data and return de average and confidence levels. Using a *for* we processed this information for all values of the Link capacity. A complete rundown of the code can be found bellow: 

```matlab
C = [10,20,30,40];
APD = zeros(length(C), 2);
for i=1:length(C)
    [APD(i,1), APD(i,2)] = average_packet_delay(C(i));
    fprintf('For C=%dMdps, the Av. Packet Delay (ms)  = %.2e +- %.2e\n', C(i), APD(i,1), APD(i,2))
end

bar(C,APD(:,1));
hold on
xlabel = 'Capacity (Mbps)';
ylabel = 'Avg Packet Delay (ms)';
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
```

### Result
The generated Bar plot is present in the image bellow. Take into account that the y-axis is the Average Packet delay (ms) and the x-axis, the Capacity (Mbps). The Confidence Interval with `C > 10` isn't clearly visible in the image due to the fact that the values are very small, so not easily visible.

![Exercise 1.a image](./task1/images/ex_1a.jpg)
The recorded values in the terminal were:
```text
For C=10Mdps, the Av. Packet Delay (ms)  = 4.34e+00 +- 7.20e-02
For C=20Mdps, the Av. Packet Delay (ms)  = 4.36e-01 +- 1.08e-03
For C=30Mdps, the Av. Packet Delay (ms)  = 2.31e-01 +- 3.60e-04
For C=40Mdps, the Av. Packet Delay (ms)  = 1.57e-01 +- 2.45e-04
```

### Conclusion 
The results clearly indicate that increasing/doubling the Link Capacity will lead to lower average packet delays, since the link will support more bytes being sent per second (doubling the available bandwidth). 
It's extremely recommended for the link to have at least 20 Mbps of capacity, since the we can get more than 8 times lower packet delay compared to a 10 Mbps link. However, something should still be said about the law of diminishing returns, because after the 20 Mbps of link capacity the values are lower, but nowhere near the reduction noticed before. If a network operator wanted advice on the cables to buy and each upgraded link capacity costed double the price, clearly anything but essential services (and even then...) should use a 20 Mbps link.
In summary, the effect of increasing link capacity and it's impact in average packet delay isn't linear. Smaller increases in capacity have more substantial impact when the link is initially congested, but the improvement slow down as higher link capacities are reached.
