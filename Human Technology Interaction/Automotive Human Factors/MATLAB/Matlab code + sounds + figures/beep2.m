clc, clear all, close all
%% Parameters
dur1 = 0.3;                         % duration of the tones
sf1 = 44100;                        % sample frequency
t1 = 0:1/sf1:dur1;                  % array of the sample times
% dur2 = 0.3;                         % duration of the tones
% sf2 = 44100;                        % sample frequency
% t2 = 0:1/((dur1/dur2)*sf2):dur2;    % array of the sample times
f0 = 440;                           % the fundamental frequency
n = 10;                             % the number of harmonics
a1 = 2/n;                           % amplitude of the harmonics
% a2 = 5/n;
s = 0;                              % the sound array set to zero.  
%% Make sound
freq = f0*4.2;      
s = s + a1*sin(2*pi*freq*t1);
pauze = zeros(size(s));         % pauze will be as long as the signal
s = horzcat(s,pauze,s);
sound(s, sf1)                    % play the sound
% plot(t1, s)                      % plot the sound
% axis([0 4/f0 -1 1])              % plot 4 periods
pause(dur1)                      % pause after sound is finished
audiowrite('beepbeep.wav',s,sf1);
% freq = f0*7;
% s = s + a2*sin(2*pi*freq*t2);
% sound(s, sf2)                    % play the sound
% plot(t2, s)                      % plot the sound
% axis([0 4/f0 -1 1])              % plot 4 periods
% close all