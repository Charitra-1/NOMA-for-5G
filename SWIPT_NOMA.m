clc; clear variables; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%source, 2 users. strong user acts as energy harvesting 
%relay to weak. No direct path exists between the source
%to weak user due to extreme shadowing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 10^6;   

dsn = 10;   %Source to near user distance
dnf = 10;   %Near user to far user distance

eta = 4;    %Path loss exponent
%Rayleigh fading coefficients
hsn = (sqrt(dsn^-eta))*(randn(N,1)+1i*randn(N,1))/sqrt(2);  %BS - near user
hnf = (sqrt(dnf^-eta))*(randn(N,1)+1i*randn(N,1))/sqrt(2);  %near user - far user
%channel gains
gsn = (abs(hsn)).^2;
gnf = (abs(hnf)).^2;

Pt = 0:5:20;    %Transmit power in dBm
pt = (10^-3)*db2pow(Pt);    %Transmit power in linear scale0
BW = 10^9;      %1 GHz bandwidth
No = -174 + 10*log10(BW);   %Noise power in dBm
no = (10^-3)*db2pow(No);    %noise power in linear scale


%Power allocation factors
af = 0.8; an = 0.2;
ratetarget = 1; %Target rate for both users
snrtarget = (2^(2*ratetarget))-1;   %target snr for both users
eff = 0.7;  %power harvesting efficiency of the near user
del = 10^-6; %a small number

%Some buffers
pn = zeros(1,length(pt));
pf = zeros(1,length(pt));

cn = zeros(1,length(pt));
cf = zeros(1,length(pt));
for u = 1:length(pt)    
    %Fraction of power harvested by near user
    frac =  max(0, (1 - snrtarget*no./((af - snrtarget*an)*pt(u)*gsn))-del); %To ensure the fraction in non-negative
    
    %Amount of power harvested by near user
    ph = pt(u)*gsn.*frac*eff;
    
    %Achievable rate of near user
    Rnf = 0.5*log2(1 + af*pt(u)*(1-frac).*gsn./(an*pt(u)*(1-frac).*gsn + no));
    Rnn = 0.5*log2(1 + an*pt(u)*(1-frac).*gsn/no);
    %Achievable rate of far user
    Rf = 0.5*log2(1 + ph.*gnf/no);
    
    cn(u) = mean(Rnn);
    cf(u) = mean(Rf);
    
    for k = 1:N
       if (Rnn(k)<ratetarget)||(Rnf(k)<ratetarget) 
           pn(u) = pn(u) + 1;
       end
       if Rf(k) < ratetarget
           pf(u) = pf(u) + 1;
       end
    end
end

poutn1 = pn/N;
poutf1 = pf/N;

figure;
plot(Pt, cn, 'linewidth', 2); hold on; grid on;
plot(Pt, cf, 'linewidth', 2);
legend('Near user','Far user');
xlabel('Transmit power (dBm)');
ylabel('Average Achievable rate (bps/Hz)');

figure;
semilogy(Pt, poutn1, 'linewidth', 2); hold on; grid on;
semilogy(Pt, poutf1, 'linewidth', 2);
legend('Near user','Far user');
xlabel('Transmit power (dBm)');
ylabel('Outage probability');

figure;
plot(1:200,Rnn(1:200),'linewidth',1.5); hold on; grid on;
plot(1:200,Rf(1:200)); 
plot(1:200,ones(1,200)*ratetarget,'linewidth',1.5);
xlabel('Instance of channel realization');
ylabel('Instantaneous achievable rate (bps/Hz)');
legend('Near user','Far user','Target rate');

















