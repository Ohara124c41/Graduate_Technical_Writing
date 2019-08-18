clc;clear all;close all;

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

%% Bestimmung kritischer Punkt

% Variante 1:
%  Schwerpunkte von Raktenspitze aus (Aus CATIA)
x1 = 1410.105;
x2 = 1521.916;
x3 = 1442.948;
% Zugehörige Massen
m1 = 29.193;
m2 = 12.915;
m3 = 0;

x = [m1 m2 m3];
y = [x1 x2 x3];

x1 = linspace(37,0);
p = polyfit(x,y,2);
f1 = polyval(p,x1);

max_SP_1 = max(f1);
m_SP_1 = x1(f1==(max(f1)));

col = 4;
figure (1)
hold on
h1 = plot(x1,f1,'linewidth',LineWidth,'Color', ColOrder_new(col,:));
set(gca, 'XDir','reverse')
xlim([0 29])
line([m_SP_1 m_SP_1],[1400 max_SP_1],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')
line([m_SP_1 37],[max_SP_1 max_SP_1],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')
xlabel('Wassermasse [kg]')
ylabel('Schwerpunktentfernung von Raketenspitze [mm]')
ylim([1420 1540])
grid on

%Variante 2
%  Schwerpunkte von Raktenspitze aus (Aus CATIA)
x1 = 1409.535;
x2 = 1522.287;
x3 = 1442.781;
% Zugehörige Massen
m1 = 29.193;
m2 = 12.915;
m3 = 0;

x = [m1 m2 m3];
y = [x1 x2 x3];

x1 = linspace(37,0);
p = polyfit(x,y,2);
f1 = polyval(p,x1);

max_SP_2 = max(f1);
m_SP_2 = x1(f1==(max(f1)));

col = 8;
h2 = plot(x1,f1,'linewidth',LineWidth,'Color', ColOrder_new(col,:));
line([m_SP_2 m_SP_2],[1420 max_SP_2],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')
line([m_SP_2 37],[max_SP_2 max_SP_2],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')

% Variante 3
%  Schwerpunkte von Raktenspitze aus (Aus CATIA)
x1 = 1408.057;
x2 = 1519.654;
x3 = 1440.08;
% Zugehörige Massen
m1 = 29.193;
m2 = 12.915;
m3 = 0;

x = [m1 m2 m3];
y = [x1 x2 x3];

x1 = linspace(37,0);
p = polyfit(x,y,2);
f1 = polyval(p,x1);

max_SP_3 = max(f1);
m_SP_3 = x1(f1==(max(f1)));

col = 2;
h3 = plot(x1,f1,'linewidth',LineWidth,'Color', ColOrder_new(col,:));
line([m_SP_3 m_SP_3],[1420 max_SP_3],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')
line([m_SP_3 37],[max_SP_3 max_SP_3],'linewidth',LineWidth,'Color', ColOrder_new(col,:),'Linestyle','--')

legend([h1,h2,h3],['Variante 1'],...
       ['Variante 2'],['Variante 3'],'location','northeast');
print -dpng Schwerpunkt.png -r500 





