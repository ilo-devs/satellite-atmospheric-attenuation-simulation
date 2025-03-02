function [ Nwet ] = valNwet( lat,lon,Lat_1dot5,Long_1dot5,Nwet_1dot5)
%% Fonction qui  nous donnera le terme humide du coincide de refraction à la surface de la terre en fonction de la longitude et latitude
%   Entrée
%lat: latitude  [-90 à 90 Degrée]
%lon: longitude [0 à 360 Degrée]
%   Sortie
%Nwet: Terme humide du coincide [N]

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

% %% Chargement des donnée nécessaire a l'interpolation
% load('data_Nwet.mat');

%% Intepolationde la carte pour obtenir H0 a l'altitude souhaitée
Nwet=interp2(Long_1dot5,Lat_1dot5,Nwet_1dot5,lon,lat,'linear');%Calcule de Nwet a l'emplacement voulue par intrepolation bilineaire(axe z)
end

