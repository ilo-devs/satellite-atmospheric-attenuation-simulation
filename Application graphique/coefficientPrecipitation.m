function [k,alpha] = coefficientPrecipitation(f,elev,tau)
load('tableCoefficient.mat')
%% calcule de kh
ss=0;
for i=1:4
    s=(coefkh(1,i,1)*exp(-(((log10(f))-coefkh(1,i,2))/coefkh(1,i,3))^2));
    ss=ss+s;
end
kh=10^(ss+(coefkh(1,1,4)* log10(f))+coefkh(1,2,4));


%% calcule de kv
ss=0;
for i=1:4
    s=(coefkv(1,i,1)*exp(-(((log10(f))-coefkv(1,i,2))/coefkv(1,i,3))^2));
    ss=ss+s;
end
kv=10^(ss+(coefkv(1,1,4)*log10(f))+coefkv(1,2,4));

%% calcule de alphah
ss=0;
for i=1:5
    s=(coefAlphah(1,i,1)*exp(-(((log10(f))-coefAlphah(1,i,2))/coefAlphah(1,i,3))^2));
    ss=ss+s;
end
alphah=ss+(coefAlphah(1,1,4)*log10(f))+coefAlphah(1,2,4);

%% calcule de alphav
ss=0;
for i=1:5
    s=(coefAlphav(1,i,1)*exp(-(((log10(f))-coefAlphav(1,i,2))/coefAlphav(1,i,3))^2));
    ss=ss+s;
end
alphav=ss+(coefAlphav(1,1,4)*log10(f))+coefAlphav(1,2,4);

%% calcule de k et h
k=(kh+kv+((kh-kv)*((cosd(elev))^2) * cosd(2*tau)))/2;
alpha=((kh*alphah)+(kv*alphav)+(((kh*alphah) - (kv*alphav))*(cosd(elev)^2)*cosd(2*tau)))/(2*k);

end

