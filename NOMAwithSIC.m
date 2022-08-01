clc; clear all; close all;

x1 = [1 0 1 0];
x2 = [0 1 1 0];

xmod1 = 2*x1-1;
xmod2 = 2*x2-1;

a1 = 0.75; a2 = 0.25;
x = sqrt(a1)*xmod1 + sqrt(a2)*xmod2;

xdec1 = ones(1,length(x1));
xdec1(x<0)=-1;

xrem = x - sqrt(a1)*xdec1;
xdec2 = zeros(1,length(x1));
xdec1(x<0)=0;
xdec2(xrem>0)=1;

%Plot figures

ay = -2:0.2:2;
ax = ones(1,length(ay));

figure;
subplot(2,1,1)
stairs([x1,x1(end)],'linewidth',2);
ylim([-2 2])
grid on; hold on;
title('Data of user 1 (x_1)')
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
subplot(2,1,2)
stairs([x2,x2(end)],'m','linewidth',2);
ylim([-2 2])
grid on; hold on;
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
title('Data of user 2 (x_2)')


figure;
subplot(2,1,1)
stairs([xmod1,xmod1(end)],'linewidth',2);
ylim([-2 2])
grid on; hold on;
title('Data of user 1 (x_1)')
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
subplot(2,1,2)
stairs([xmod2,xmod2(end)],'m','linewidth',2);
ylim([-2 2])
grid on; hold on;
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
title('Data of user 2 (x_2)');

t1 = sqrt(a1)*xmod1;
t2 = sqrt(a2)*xmod2;
figure;
subplot(2,1,1)
stairs([t1,t1(end)],'linewidth',2);
ylim([-2 2])
grid on; hold on;
title('Scaled data of user 1 ($$\sqrt{a_1}x_1$$)','Interpreter','latex','FontSize',13)
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
subplot(2,1,2)
stairs([t2,t2(end)],'m','linewidth',2);
ylim([-2 2])
title('Scaled data of user 2 ($$\sqrt{a_2}x_2$$)','Interpreter','latex','FontSize',13)
grid on; hold on;

for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end

figure;
stairs([x,x(end)],'r','linewidth',2);
grid on; hold on;
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
title('Superposition coded signal')
plot(1:5,zeros(1,5),'k','linewidth',1.5)

figure;
stairs([xrem,xrem(end)],'r','linewidth',2);
grid on; hold on;
for u = 1:3
   plot(ax*(u+1),ay,':k','linewidth',2);  
end
title('Superposition coded signal')
plot(1:5,zeros(1,5),'k','linewidth',1.5)

