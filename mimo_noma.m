clc; clear variables; close all;

%Distances
d1 = 500; d2 = 200;

%Power allocation coefficients
a1 = 0.75; a2 = 0.25;

N = 5*10^5;
eta = 4;%Path loss exponent

%Rayleigh fading channels
h11 = sqrt(d1^-eta)*(randn(N,1) + 1i*randn(N,1))/sqrt(2);
h12 = sqrt(d1^-eta)*(randn(N,1) + 1i*randn(N,1))/sqrt(2);
h21 = sqrt(d2^-eta)*(randn(N,1) + 1i*randn(N,1))/sqrt(2);
h22 = sqrt(d2^-eta)*(randn(N,1) + 1i*randn(N,1))/sqrt(2);

h1 = h11+h12;
h2 = h21+h22;

%Channel gains
g1 = (abs(h1)).^2;
g2 = (abs(h2)).^2;

%Transmit power
Pt = -30:5:30; %in dBm
pt = (10^-3)*db2pow(Pt); %linear scale

BW = 10^6;  %bandwidth
%Noise power
No = -174 + 10*log10(BW);   %in dBm
no = (10^-3)*db2pow(No);    %in linear scale

%Target rates
R1 = 1;
R2 = 3;

p1n = zeros(1,length(pt));
p2n = zeros(1,length(pt));
p1o = zeros(1,length(pt));
p2o = zeros(1,length(pt));

for u = 1:length(pt)
   
   %Achievable rates for MIMO-NOMA
   R1n = log2(1 + pt(u)*a1.*g1./(pt(u)*a2.*g1 + no));
   R12n = log2(1 + pt(u)*a1.*g2./(pt(u)*a2.*g2 + no));
   R2n = log2(1 + pt(u)*a2.*g2/no);
   
   %Achievable rates for MIMO-OMA
   R1o = 0.5*log2(1 + pt(u)*g1/no);
   R2o = 0.5*log2(1 + pt(u)*g2/no);
    
   %Sum rates
   Rn(u) = mean(R1n+R2n);    %MIMO-NOMA
   Ro(u) = mean(R1o+R2o);    %MIMO-OMA
   
   %Invidual user rates
   R1n_av(u) = mean(R1n);   %MIMO-NOMA USER 1 (WEAK)
   R2n_av(u) = mean(R2n);   %MIMO-NOMA USER 2 (STRONG)
   
   R1o_av(u) = mean(R1o);   %MIMO-OMA USER 1 (WEAK)
   R2o_av(u) = mean(R2o);   %MIMO-OMA USER 1 (WEAK)
   
   %Outage calculation
   for k = 1:N
       %MIMO-NOMA USER 1 (WEAK)
       if R1n(k) < R1
           p1n(u) = p1n(u)+1;
       end
       %MIMO-NOMA USER 2 (STRONG)
       if (R12n(k)<R1)||((R12n(k)>R1)&&(R2n(k) < R2))
           p2n(u) = p2n(u)+1;
       end
       %MIMO-OMA USER 1 (WEAK)
       if R1o(k) < R1
           p1o(u) = p1o(u)+1;
       end
       %MIMO-OMA USER 2 (STRONG)
       if R2o(k) < R2
           p2o(u) = p2o(u)+1;
       end
   end
end
figure;
plot(Pt, Rn, '-*b', 'linewidth',1.5); hold on; grid on;
plot(Pt, Ro, '-*r','linewidth',1.5);
legend('MIMO-NOMA','MIMO-OMA');
xlabel('Transmit power (dBm)');
ylabel('Achievable sum rates (bps/Hz)');
title('Sum rate comparison');

figure;
semilogy(Pt,p1n/N,'-*b','linewidth',1.5); hold on; grid on;
semilogy(Pt,p2n/N,'-ob','linewidth',1.5);
semilogy(Pt,p1o/N,'-*r','linewidth',1.5); hold on; grid on;
semilogy(Pt,p2o/N,'-or','linewidth',1.5);
legend('MIMO-NOMA weak','MIMO-NOMA strong','MIMO-OMA weak', 'MIMO-OMA strong')
xlabel('Transmit power (dBm)');
ylabel('Outage probability');
title('Outage comparison');

figure;
plot(Pt,R1n_av,'-*b','linewidth',1.5); hold on; grid on;
plot(Pt,R2n_av,'-ob','linewidth',1.5); 
plot(Pt,R1o_av,'-*r','linewidth',1.5); 
plot(Pt,R2o_av,'-or','linewidth',1.5); 
legend('MIMO-NOMA weak','MIMO-NOMA strong','MIMO-OMA weak', 'MIMO-OMA strong')
xlabel('Transmit power (dBm)');
ylabel('Achievable rates (bps/Hz)');
title('Individual user rates')