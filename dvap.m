function [y,P,ym,ys]=dvap(lat,lon,P,hasl,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,i,j)
%
% function [y,P,ym,ys]=itur836_4_vapd(lat,lon,P,hasl[,topo_1dot125,vsch,vsch_prob,vsch_mv,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,vapd_gl_mv,vapd_gl_st])
%
% The function itur836_4_vapd calculates, for specified 
% latitude, longitude and probability, the yearly statistics of 
% water vapour density (at ground level).
% The units of the water vapour density are g/m^3.
% As for probability a linear interpolation is performed 
% between available values.
%
% Other input variables from file itur836_4_vapd.mat:
% topo_1dot125: ground level altitude a.m.s.l. 1.125 x 1.125 res. in lat. and long. (km)
% vsch: water vapour scale height (161x321x18)
% vsch_prob: probabilities % (18) corresponding to vsch
% vsch_mv: yearly mean value of water vapour scale height (161x321x18)
% Mlat_1dot125: Matrix of latitudes (90 to -90)
% Mlong_1dot125: Matrix of longitudes (0 to 360 degrees)
% vapd_gl: water vapour density (at ground level) (161x321x18)
% vapd_gl_prob: probabilities % (18) corresponding to vapd_gl
% vapd_gl_mv: yearly mean value of water vapour density (at ground level) (161x321)
% vapd_gl_st: yearly standard deviation of water vapour (161x321)
% Comment: text comment to the file
%
% Input
% lat: latitude (deg N)
% lon: longitude (deg E)
% P: probability (%) (can be a vector)
% hasl: site altitude (km)
%
% Output
% y(P): yearly value of water vapour  density (at ground level) (g/m^3)
%       (if P is a vector, y is a vector)
% P: probabilities (%) corresponding to y
% ym: yearly mean value of water vapour density (at ground level) (g/m^3)
% ys: yearly standard deviation of water vapour density (at ground level)
%     (g/m^3)
%
% By: C. Riva
% Release: 05.VI.2009

I=find(P<min(vapd_gl_prob));%Test s'il y une valeur inférieur a 0.1 dans vecteur P 
if isempty(I)==0, %si on trouve une une indice
   P(I)=zeros(size(I))+min(vapd_gl_prob); %alors on le raméne à 0.1
end
I=find(P>max(vapd_gl_prob));%test s'il y a une valeur supérieur a 99 dans vecteur P
if isempty(I)==0, %Si on trouve une indice
   P(I)=zeros(size(I))+max(vapd_gl_prob); %alors on le raméne a 99
end

if (lat<-90)||(lat>90),
  error('Latitude should be between -90 and 90.');
  y=0;
  return
end
while lon>=360,
  lon=lon-360;
end
while lon<0,
  lon=lon+360;
end

%% Calcule de Pabove et Pbelow
ind_Pabove=find(vapd_gl_prob>=P, 1 );
ind_Pbelow=find(vapd_gl_prob<=P, 1, 'last' );

Pabove=vapd_gl_prob(ind_Pabove);
Pbelow=vapd_gl_prob(ind_Pbelow);

if Pabove==Pbelow
    aux_vapd(1:2,1:2)=vapd_gl(i:i+1,j:j+1,ind_Pabove) ;%on copie le contenue de chauqe concentration pour diiférent porcentage
    aux_vsch(1:2,1:2)=vsch(i:i+1,j:j+1,ind_Pabove); %on copie le contenue de chaque hauteur de concentration pour diiférent porcentage
    aux(1:2,1:2)=aux_vapd.*exp(-(hasl-topo_1dot125(i:i+1,j:j+1))./aux_vsch);% Calcule du vapeur d'eau à l'altitude voulue 
    y=interp2(Mlong_1dot125(i:i+1,j:j+1),Mlat_1dot125(i:i+1,j:j+1),aux,lon,lat,'linear');%Calcule concentration en vapeur d'eau a l'emplacement voulue par intrepolation(axe z)
    return
   
elseif Pabove~=Pbelow
    %% Cet Boucle sert a calculer la valeur de la vapeur d'eau reportée a
    %l'atitude souhaitée et l'mplacement voulues
    z=1;
    for ii=[ind_Pbelow ind_Pabove],
     aux_vapd(1:2,1:2)=vapd_gl(i:i+1,j:j+1,ii); %on copie le contenue de chauqe concentration pour diiférent porcentage
     aux_vsch(1:2,1:2)=vsch(i:i+1,j:j+1,ii); %on copie le contenue de chaque hauteur de concentration pour diiférent porcentage
     aux(1:2,1:2)=aux_vapd.*exp(-(hasl-topo_1dot125(i:i+1,j:j+1))./aux_vsch);% Calcule du vapeur d'eau à l'altitude voulue 
     local_vapd_gl(z)=interp2(Mlong_1dot125(i:i+1,j:j+1),Mlat_1dot125(i:i+1,j:j+1),aux,lon,lat,'linear');%Calcule concentration en vapeur d'eau a l'emplacement voulue par intrepolation(axe z)
     z=z+1;
    end
    y=interp1(log([Pbelow Pabove]),local_vapd_gl,log(P),'linear');
end

% ym=interp2(Mlong_1dot125,Mlat_1dot125,vapd_gl_mv.*exp(-(hasl-topo_1dot125)./vsch_mv),lon,lat,'linear');
% ys=interp2(Mlong_1dot125,Mlat_1dot125,vapd_gl_st,lon,lat,'linear');

return
