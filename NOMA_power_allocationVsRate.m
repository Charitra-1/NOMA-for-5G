clc; clear variables; close all;

N = 10^5;
Pt = 30;                        %Max BS Tx power (dBm)
pt = (10^-3)*db2pow(Pt);        %Max BS Tx power (Linear scale)
No = -114;                      %Noise power (dBm)
no = (10^-3)*db2pow(No);        %Noise power (Linear scale)


r = 0.5:0.5:10;                 %Far user target rate range (R*)

df = 1000; dn = 500;            %Distances

eta = 4;                        %Path loss exponent

p1 = zeros(1,length(r));
p2 = zeros(1,length(r));
pa1 = zeros(1,length(r));
pa2 = zeros(1,length(r));

af = 0.75; an = 0.25;       %Fixed PA (for comparison)



hf = sqrt(df^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);
hn = sqrt(dn^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);

g1 = (abs(hf)).^2;
g2 = (abs(hn)).^2;

for u = 1:length(r)
    epsilon = (2^(r(u)))-1;         %Target SINR for far user

        %BASIC FAIR PA%
        aaf = min(1,epsilon*(no + pt*g1)./(pt*g1*(1+epsilon)));
        aan = 1 - aaf;

%     %IMPROVED FAIR PA%
%     aaf = epsilon*(no + pt*g1)./(pt*g1*(1+epsilon));
%     aaf(aaf>1) = 0;
%     aan = 1 - aaf;



    gamma_f = pt*af*g1./(pt*g1*an + no);
    gamma_nf = pt*af*g2./(pt*g2*an + no);
    gamma_n = pt*g2*an/no;

    gamm_f = pt*aaf.*g1./(pt*g1.*aan + no);
    gamm_nf = pt*aaf.*g2./(pt*g2.*aan + no);
    gamm_n = pt*g2.*aan/no;


    Cf = log2(1 + gamma_f);
    Cnf = log2(1 + gamma_nf);
    Cn = log2(1 + gamma_n);

    Ca_f = log2(1 + gamm_f);
    Ca_nf = log2(1 + gamm_nf);
    Ca_n = log2(1 + gamm_n);

    for k = 1:N
        if Cf(k) < r(u)
            p1(u) = p1(u) + 1;
        end
        if (Cnf(k)<r(u))||(Cn(k) < r(u))
            p2(u) = p2(u) + 1;
        end

        if Ca_f(k) < r(u)
            pa1(u) = pa1(u) + 1;
        end
        if aaf(k) ~= 0
            if (Ca_n(k) < r(u)) || (Ca_nf(k) < r(u))
                pa2(u) = pa2(u) + 1;
            end
        else
            if Ca_n(k) < r(u)
                 pa2(u) = pa2(u) + 1;
            end
        end
    end
end
pout1 = p1/N;
pout2 = p2/N;
pouta1 = pa1/N;
pouta2 = pa2/N;



figure;
plot(r,pout1,'--+r','linewidth',2); hold on; grid on;
plot(r,pout2,'--ob','linewidth',2);
plot(r,pouta1,'r','linewidth',2);
plot(r,pouta2,'b','linewidth',2);
xlabel('Target rate of far user (R*) bps/Hz');
ylabel('Outage probability');
xlim([r(1) r(end)]);
legend('Far user (fixed PA)','Near user (fixed PA)','Far user (fair PA)','Near user (fair PA)');

















