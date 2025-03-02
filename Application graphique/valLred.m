function varargout=valLred(lat,lon,P,mois)
%% Fonction qui  nous donnera le contenue totale en eau liquide de nuage reduit
%par interpolation des donnée dans la grille (kg/m^2)
% Le calcule se fait selon les valeur annuelle ou mensuelle


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
load('data_eau_liquide_reduit.mat');

%% Si le nombre d'entée est 3 alors on calcule sur une année moyenne
% Si 4 alors on calcule sur un mois
if nargin==3
    nbrp=length(Lred_annuel_prob);%Nombre de probabilité en année moyenne
    
    I=find(P<min(Lred_annuel_prob));%Test s'il y une valeur inférieur a 0.1 dans vecteur P 
    if isempty(I)==0, %si on trouve une indice
       P(I)=zeros(size(I))+min(Lred_annuel_prob); %alors on le raméne à 0.1
    end
    I=find(P>max(Lred_annuel_prob));%test s'il y a une valeur supérieur a 99 dans vecteur P
    if isempty(I)==0, %Si on trouve une indice
       P(I)=zeros(size(I))+max(Lred_annuel_prob); %alors on le raméne a 99
    end
    
    Lred_choix=Lred_annuel;
    Lred_prob_choix=Lred_annuel_prob;
    
elseif nargin==4
    
    I=find(P<min(Lred_mois_prob));%Test s'il y une valeur inférieur a 1 dans vecteur P 
    if isempty(I)==0, %si on trouve une indice
       P(I)=zeros(size(I))+min(Lred_mois_prob); %alors on le raméne à 1
    end
    I=find(P>max(Lred_mois_prob));%test s'il y a une valeur supérieur a 99 dans vecteur P
    if isempty(I)==0, %Si on trouve une indice
       P(I)=zeros(size(I))+max(Lred_mois_prob); %alors on le raméne a 99
    end
   Lred_choix=Lred_mois.(mois)(:,:,:);
   Lred_prob_choix=Lred_mois_prob;
    
else
    errordlg('Entrez pourcentage temps','Nbre entrée insufisant');
    return;
end


%% Calcule de Pabove et Pbelow
ind_Pabove=find(Lred_prob_choix>=P, 1 );
ind_Pbelow=find(Lred_prob_choix<=P, 1, 'last' );

Pabove=Lred_prob_choix(ind_Pabove);
Pbelow=Lred_prob_choix(ind_Pbelow);

if Pabove==Pbelow
    aux_Lred(1:161,1:321)=Lred_choix(:,:,ind_Pabove); %on copie le contenue de chauqe concentration pour diiférent porcentage
    varargout{1}=interp2(Long_1dot125,Lat_1dot125,aux_Lred,lon,lat,'linear');%Calcule contenue totale en eau liquide de nuage reduit a l'emplacement voulue par intrepolation bilineaire(axe z)
    return
    
elseif Pabove~=Pbelow    
    % Cet Boucle sert a calculer le contenue totale en eau liquide de nuage reduit à l'mplacement voulues pour chaque probabilitée
    i=1;
    for ii=[ind_Pbelow ind_Pabove],
     aux_Lred(1:161,1:321)=Lred_choix(:,:,ii); %on copie le contenue de chauqe concentration pour diiférent porcentage
     local_Lred(i)=interp2(Long_1dot125,Lat_1dot125,aux_Lred,lon,lat,'linear');%Calcule contenue totale en eau liquide de nuage reduit a l'emplacement voulue par intrepolation bilineaire(axe z)
     i=i+1;
    end
    % Finalement le contenue totale en eau liquide de nuage reduit a la
    % probabilitée voulues,annuel ou un mois précis
    varargout{1}=interp1(log([Pbelow Pabove]),local_Lred,log(P),'linear'); 
end

end