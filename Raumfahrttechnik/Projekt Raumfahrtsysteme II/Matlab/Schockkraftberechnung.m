clear all;close all;clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Raumfahrtsysteme                                     %%%%%%%%%%%%%%%%%
%%%% Gruppe Mechanic                                      %%%%%%%%%%%%%%%%%
%%%% 05.03.2019                                           %%%%%%%%%%%%%%%%%
%%%% Maurer,D., Klioner, E., Berger,R., Block,N.          %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Color Order for plots
ColLimit     = [0.6 0.6 0.6];    % Grenzen, grey
ColOrder_new = [...
    0.3010    0.7450    0.9330   % Zustand 1, light blue
    0         0.4470    0.7410   % Zustand 2, blue
    0.4940    0.1840    0.5560   % Zustand 3, violet
    0.6650    0.0780    0.1840   % Zustand 4, dark red
    0.9500    0.3750    0.0980   % Zustand 5, orange
    0.9290    0.6940    0.1250   % Zustand 6, dark yellow
    0.4660    0.6740    0.1880   % Zustand 7, light green
    0.2660    0.4740    0.3880]; % Zustand 8, dark green
% Change to new colors for all plots
set(gca, 'ColorOrder', ColOrder_new, 'NextPlot', 'replacechildren');
LineWidth = 1; % linewidth for all plots

%% Berechnung Geschwindigkeiten 
%Maximale last
maxLast = 20700; % Aus dem Zugversuch in N
A = 34; % Fläche des Fallschirms in m^2
roh = 1.225; % Luftdichte auf Meereshöhe in kg/m^3
roh_v = [1.2247 1.202 1.179 1.156 1.134 1.111]; % kg/m^3
cw = 1.8; %cw-Wert des Fallschirms
cw_v = [1 1.2 1.4 1.6 1.8 2.0];%cw-Wert
cx = 1.8;% Schockkraftmultiplikator
cx_v = [1.5 1.6 1.7 1.8 1.9 2.0];


figure(1)

% Variation des cw Wertes
subplot(2,2,1)
for j =1:6 
    for i =1:1:50000
        V(i) = i/1000;
        F.V_A(j,i) = cw_v(j) * A * roh_v(1)/2 * V(i)^2*cx;
    end
end

hold on
for j=1:6
set(1,'Name','Bodennähe Dichte')
hold on
h_plot(j) = plot(V,F.V_A(j,:),...
                 'Color', ColOrder_new(j+1,:),'MarkerSize', 8, ...
                 'LineWidth', LineWidth);
xlabel('Geschwindigkeit [m/s]','interpreter','latex')
ylabel('Kraft [N]','interpreter','latex')
ylim([0 40000])
xlim([0 40])
grid on
end
line([0 50] ,[maxLast maxLast],'Color','r','linewidth',1.5);
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['cw = 1,0'],...
    ['cw = 1,2'],['cw = 1,4'],['cx = 1,6'],['cx = 1,8'],['cx = 2'],'location','northwest');

clear ('F.V_A')

% Variation der Dichte
subplot(2,2,2)
for j =1:6 
    for i =1:1:50000
        V(i) = i/1000;
        F.V_A(j,i) = cw * A * roh_v(j)/2 * V(i)^2*cx;
    end
end

hold on

for j=1:6
set(1,'Name','Bodennähe Dichte')
hold on
h_plot(j) = plot(V,F.V_A(j,:),...
    'Color', ColOrder_new(j+1,:),'MarkerSize', 8, ...
'LineWidth', LineWidth);
legend();
xlabel('Geschwindigkeit [m/s]','interpreter','latex')
ylabel('Kraft [N]','interpreter','latex')
grid on
end
ylim([0 40000])
xlim([0 40])
line([0 50] ,[maxLast maxLast],'Color','r','linewidth',1.5);
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['Höhe = 0m'],...
    ['Höhe = 200m'],['Höhe = 400m'],['Höhe = 600m'],['Höhe = 800m'],['Höhe = 1000m'],'location','southeast');

clear ('F.V_A')

% Variation des Schockfaktors
subplot(2,2,3)
for j =1:6 
    for i =1:1:50000
        V(i) = i/1000;
        F.V_A(j,i) = cw * A * roh/2 * V(i)^2*cx_v(j);
    end
end
hold on
for j=1:6
set(1,'Name','Bodennähe Dichte')
hold on
h_plot(j) = plot(V,F.V_A(j,:),...
    'Color', ColOrder_new(j+1,:),'MarkerSize', 8, ...
'LineWidth', LineWidth);
legend();
xlabel('Geschwindigkeit [m/s]','interpreter','latex')
ylabel('Kraft [N]','interpreter','latex')
grid on
end
ylim([0 40000])
xlim([0 40])
line([0 50] ,[maxLast maxLast],'Color','r','linewidth',1.5);
legend([h_plot(1),h_plot(2),h_plot(3),h_plot(4),h_plot(5),h_plot(6)],['cx = 1,5'],...
    ['cx = 1,6'],['cx = 1,7'],['cx = 1,8'],['cx = 1,9'],['cx = 2'],'location','northwest');

clear ('F.V_A')
%% Unterschied des EIfnlusses vom "neuen" und "altem" cx  Wert
figure(2)

cw = 1;
cx_v = [1.6 1.8];
for j=1:2
    for i =1:1:50000
    V(i) = i/1000;
    F.V_A(j,i) = cw * A * roh/2 * V(i)^2*cx_v(j);
    end
end

for j=1:2
set(1,'Name','Bodennähe Dichte')
hold on
h_plot(j) = plot(V,F.V_A(j,:),...
    'Color', ColOrder_new(j*4,:),'MarkerSize', 8, ...
'LineWidth', LineWidth);
legend();
xlabel('Geschwindigkeit [m/s]','interpreter','latex')
ylabel('Kraft [N]','interpreter','latex')
ylim([0 40000])
xlim([0 40])
grid on
end
%line([0 50] ,[maxLast maxLast],'Color','r','linewidth',1.5);
legend([h_plot(1),h_plot(2)],['cx = 1,6 -> alte Berechnungsgrundlage'],...
        ['cx = 1,8 -> neue Berechnungsgrundlage'],'location','northwest');
print -dpng Schockkraft_alt_neu.png -r500 