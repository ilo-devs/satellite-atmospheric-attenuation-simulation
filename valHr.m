function [h]=valHr(lat,lon)
%% Fonction qui  nous donnera hauteur de la pluie en fonction de la longitude et latitude
%% Test et adjustement latitude et longitude
if (lat<-90)|(lat>90),
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
load('data_hauteur_pluie.mat');
%% Intepolationde la carte pour obtenir H0 a l'altitude souhaitée
h0_actu=interp2(Long_1dot5,Lat_1dot5,h0,lon,lat,'linear');%Calcule de H0 a l'emplacement voulue par intrepolation bilineaire(axe z)


%% Finalement l'altitude moyenne annuelle de pluie
h=h0_actu+0.36;