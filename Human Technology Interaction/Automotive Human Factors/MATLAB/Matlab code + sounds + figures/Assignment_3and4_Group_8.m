clear all, close all, clc;

%% Declare variables
wait_time = 0.3; %seconden
%% Import sounds
[y1,Fs1] = audioread('warning_roadworks.mp3');
[y2,Fs2] = audioread('warning_accident.mp3');
[y3,Fs3] = audioread('beepbeep.wav');
%% Import figures
A = imread('roadworks_far.jpeg');
B = imread('roadworks_middle.jpeg');
C = imread('roadworks_close.jpeg');
D = imread('accident_far.png');
E = imread('accident_middle.png');
F = imread('accident_close.png');
%% Situation 1 - Lane change required day
figure(1)
imshow(A) % input roadworks_far
sound(y1,Fs1)
title('Road works - HUD & Audio')
pause(2)
xlabel('Press space to continue to next frame in current scenario','Color','red','FontSize',14)
pause(); % Wait for user input to continue
imshow(B) % input roadworks_middle
pause(2)
xlabel('Press space to continue to next frame in current scenario','Color','red','FontSize',14)
pause(); % Wait for user input to continue
imshow(C) % input roadworks_close
pause(wait_time);
sound(y3,Fs3)
pause(2)
xlabel('Press space to continue to next scenario','Color','blue','FontSize',14)
pause()
%% Situation 2 - Lane change required night
figure(2)
imshow(D) % input accident_far
sound(y2,Fs2)
title('Accident - HUD & Audio')
pause(2)
xlabel('Press space to continue to next frame in current scenario','Color','red','FontSize',14)
pause(); % Wait for user input to continue
imshow(E) % input accident_middle
pause(2)
xlabel('Press space to continue to next frame in current scenario','Color','red','FontSize',14)
pause(); % Wait for user input to continue
imshow(F) % input accident_close
pause(wait_time);
sound(y3,Fs3)
pause(4)
close all;