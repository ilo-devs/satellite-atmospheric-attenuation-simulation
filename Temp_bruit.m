function [ Tciel ] = Temp_bruit(At,temps)
%Calcule du temperature de brillance du ciel selon UIT-R-P618-11
%   Entrée
% Ap:Affaiblisemmen atmosphérique totale e
% Temps: indique le temps considérée:clair(absence d'agitaion moleculaire),nuageux ou pluvieux 

%   Sortie
% Tciel: Température de brillance ou température de bruit du ciel [K]


if strcmp(temps,'nuageux')|| strcmp(temps,'clair')
    Tm=280;
elseif strcmp(temps,'pluvieux')
    Tm=260;
end

%Calcule du température de bruit du ciel
Tciel=Tm*(1-(10^(-At/10)));


end