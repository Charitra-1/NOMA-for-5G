clc; clear variables; close all;

N = 10^5;
df = 5000; dn = 1000; %Distances

eta = 4;
hf = sqrt(df^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);
hn = sqrt(dn^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);

gf = (abs(hf)).^2;
gn = (abs(hn)).^2;

R1 = 1;  %Target rate bps/Hz

epsilon = (2^(R1))-1; %Target SINR

%Transmit power
Pt = 0:30;
pt = (10^-3)*db2pow(Pt);

%Noise power
No = -114;
no = (10^-3)*db2pow(No);

b1 = 0.75; b2 = 0.25; %Fixed PA for comparison
for u = 1:length(pt)
    a1 = epsilon*(no + pt(u)*gf)./(pt(u)*gf*(1+epsilon));
    a1(a1>1) = 0;
    a2 = 1 - a1;
    
    %Sum rate of fair PA
    C1 = log2(1 + pt(u)*a1.*gf./(pt(u)*a2.*gf + no));
    C2 = log2(1 + pt(u)*a2.*gn/no);
    
    C_sum(u) = mean(C1+C2);
    
    %Sum rate of fixed PA
    C1f = log2(1 + pt(u)*b1.*gf./(pt(u)*b2.*gf + no));
    C2f = log2(1 + pt(u)*b2.*gn/no);
    C_sumf(u) = mean(C1f+C2f);
end

plot(Pt,C_sum,'linewidth',1.5); hold on; grid on;
plot(Pt,C_sumf,'linewidth',1.5);
legend('Fair PA','Fixed PA \alpha_1 = 0.75, \alpha_2 = 0.25')
xlabel('Transmit power (dBm)');
ylabel('Sum rate (bps/Hz)');









