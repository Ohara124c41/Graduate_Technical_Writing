close all;
clear all;
%%
Data=load('si.bands.gnu');

figure
plot(Data(:,1),Data(:,2),'o','color',[0.8 0 0])
xlabel('Wave vector, $q$ [$\pi$/a$_{lat}$]','interpreter','latex','FontSize',16)
ylabel('Energy, $$[meV]$$','interpreter','latex','FontSize',16)
xlim([0 3.3])
ylim([-8 15])
%% bandplot of each band

n_band=8;% number of bands
n_k=121;% number of kpoints 91 or 121

WaveVector=reshape(Data(:,1),n_k,n_band);
Energy=reshape(Data(:,2),n_k,n_band);

figure
plot(WaveVector(:,:),Energy(:,:),'-','color',[0.8 0 0])
xlabel('Wave vector, $q$ [$\pi$/a$_{lat}$]','interpreter','latex','FontSize',16)
ylabel('Energy, $$[meV]$$','interpreter','latex','FontSize',16)
xlim([0 3.3])
ylim([-8 15])

