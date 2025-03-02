function [hs]=valHs2(lat,lon)
%% Fonction qui  nous donnera hauteur du site en fonction de la longitude et latitude
%% Test et adjustement latitude et longitude
if (lat<-90)||(lat>90),
  errordlg('La Latitude doit être entre -90 et 90.','Erreur Latitude');
  return
end
while lon>=360,
  lon=lon-360;
end
while lon<0,
  lon=lon+360;
end
%% Chargement des donnée nécessaire a l'interpolation
load('data_topo.mat');

%% Intepolationde la carte pour obtenir H0 a l'altitude souhaitée
    hs=interp2(Long_0dot5r,Lat_0dot5r,topo_0dot5r,lon,lat,'linear');%Calcule de Hs a l'emplacement voulue par intrepolation bilineaire(axe z)
end

