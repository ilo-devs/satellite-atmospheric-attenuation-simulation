function [ n ] = indRefract(lat,lon,h,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j,T,P,e)
%Calcule de l'indice de refraction dans l'atmosphére P453-11
%   en fonction de l'altitude

if nargin<=13
%Calcule de la pression partielle en vapeur d'eau , pression et température
    [T,P,rho,e]=get_TPe2(lat,lon,h,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j);
end

%Terme sec et terme Humide du coincide de réfraction
Nsec=(77.6*P)/T;
Nhum=(72*(e/T))+((3.75*(10^5)*e)/(T^2));
%Calcule du coincide de réfraction
N=Nsec+Nhum;

%Calcule de l'indice de réfraction
n=1+(N*1e-6);



end

