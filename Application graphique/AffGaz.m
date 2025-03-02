function [ gamao,gamaw,Agaz ] = AffGaz( lat,lon,saison,f,elev,T,P,rho,percent,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob)
%Calcule de l'attenuation due au gaz selon le P.676,Annexe-2

%   Entrée
%f:fréquence [Ghz]
%elev:Angle d'élévation [Degrée]
%P:Pression a l'air sec [Hpa]
%T:Température [K]
%e:Pression partiel en vapeur d'eau [Hpa]
%rho:Concentration en vapeur d'eau [g/cm3]

%   Sortie
%gamao:Affaiblissement linéique a l'air sec [dB/km]
%gamaw:Affaiblissement linéique vapeur d'eau [dB/km]
%Agaz:Affaiblissement due aux gaz sur le trajet Terre-Espace [dB]

T=convtemp(T,'K','C'); %Puisque température est en °C mais pas en °K
rt=288/(273+T);
rp=P/1013;
n1=0.955*rp*(rt.^0.68)+(0.006*rho);
n2=0.735*rp*(rt.^0.5)+(0.0353*(rt.^4)*rho);


%% Affaiblissement linéique vapeur d'eau
gamaw=(((3.98*n1*exp(2.23*(1-rt)))/(((f-22.235).^2)+9.42*(n1.^2)))*(1+((f-22)/(f+22)).^2)+...
((11.96*n1*exp(0.7*(1-rt)))./(((f-183.31).^2)+11.14*(n1.^2)))+((0.081*n1*exp(6.44*(1-rt)))/...
(((f-321.226).^2)+(6.29*(n1.^2))))+((3.66*n1*exp(1.6*(1-rt)))/(((f-325.153).^2)+9.22*(n1.^2)))+...
((25.37*n1*exp(1.09*(1-rt)))/((f-380).^2))+((17.4*n1*exp(1.46*(1-rt)))/((f-448).^2))+...
((844.6*n1*exp(0.17*(1-rt)))/((f-557).^2))*(1+((f-557)/(f+557)).^2)+((290*n1*exp(0.41*(1-rt)))/...
((f-752).^2))* (1+((f-752)/(f+752)).^2)+ ((83328*n2*exp(0.99*(1-rt)))/...
((f-1780).^2))* (1+((f-1780)/(f+1780)).^2))*((f.^2)*(rt.^2.5)*(rho*10.^(1-5)));



%% (2) Air Sec(seulement oxygéne)
ee1=(rp.^0.0717)*(rt.^(0-1.8132))*exp(0.0156*(1-rp)-1.6515*(1-rt));
ee2=(rp.^0.5146)*(rt.^(0-4.6368))*exp((0-0.1921)*(1-rp)-5.7416*(1-rt));
ee3=(rp.^0.3414)*(rt.^(0-6.5851))*exp(0.2130*(1-rp)-8.5854*(1-rt));
ee4=(rp.^(0-0.0112))*(rt.^(0.0092))*exp((0-0.1033)*(1-rp)-0.0009*(1-rt));
ee5=(rp.^0.2705)*(rt.^(0-2.7192))*exp((0-0.3016)*(1-rp)-4.1033*(1-rt));
ee6=(rp.^0.2445)*(rt.^(0-5.9191))*exp(0.0422*(1-rp)-8.0719*(1-rt));
ee7=(rp.^(0-0.1833))*(rt.^(6.5589))*exp((0-0.2402)*(1-rp)+6.131*(1-rt));
Y54=2.192*(rp.^1.8286)*(rt.^(0-1.9487))*exp(0.4051*(1-rp)-2.8509*(1-rt));
Y58=12.59*(rp.^1.0045)*(rt.^(3.5610))*exp(0.1588*(1-rp)+1.2834*(1-rt));
Y60=15*(rp.^0.9003)*(rt.^(4.1335))*exp(0.0427*(1-rp)+1.6088*(1-rt));
Y62=14.28*(rp.^0.9886)*(rt.^(3.4176))*exp(0.1827*(1-rp)+1.3429*(1-rt));
Y64=6.819*(rp.^1.4320)*(rt.^(0.6258))*exp(0.3177*(1-rp)-0.5914*(1-rt));
Y66=1.908*(rp.^2.0717)*(rt.^(0-4.1404))*exp(0.4910*(1-rp)-4.8718*(1-rt));
ss=(0-0.00306)*(rp.^3.211)*(rt.^(0-14.94))*exp(1.583*(1-rp)-16.37*(1-rt));

% Affaiblissement linéique a l'air sec
if f<=54
    gamao=(((7.2*(rt.^2.8))/((f.^2)+(0.34*(rp.^2)*(rt.^1.6))))+((0.62*ee3)/(((54-...
    f).^(1.16*ee1))+(0.83*ee2))))*((f.^2)*(rp.^2)*(10.^(0-3)));
elseif f>54 && f<=60
    gamao=exp(((log(Y54)./24)*(f-58)*(f-60))-((log(Y58)./8)*...
    (f-54)*(f-60))+((log(Y60)./12)*(f-54)*(f-58)));
elseif f>60 && f<=62
    gamao=Y60+((Y62-Y60)*((f-60)/2));
elseif f>62 && f<=66
    gamao=exp(((log(Y62)./8)*(f-64)*(f-66))-((log(Y64)./4)*(f-62)*...
(f-66))+((log(Y66)./8)*(f-62)*(f-64)));
elseif f>66 && f<=120
    gamao=((3.02*(10.^(0-4))*(rt.^3.5))+((0.283*(rt.^3.8))/(((f-...
    118.75).^2)+(2.91*(rp.^2)*(rt.^1.6))))+...
    ((0.502*ee6*(1-(0.0163*ee7*(f-66))))/(((f-66).^(1.4346*ee4))+...
    (1.15*ee5))))*((f.^2)*(rp.^2)*(10.^(1-4))); 
elseif f>120 && f<=350
    gamao=(((3.02*(10.^(0-4)))/(1+(1.9*(10.^(0-5))*(f.^1.5))))+...
    ((0.283*(rt.^0.3))/(((f-118.75).^(2))+(2.91*(rp.^2)*...
    (rt.^1.6)))))*((f.^2)*(rp.^2)*(rt.^3.5)*(10.^(0-3)))+ss;
end


%% Affiablissement lineique totale due aux gaz atmosphérique
Aff=gamao+gamaw;

%% Affaiblissement sur trajet terre espace
%Paramétre init
if nargout==3 
    Bn=acosd(sind(elev)); %angle du 1ére incidence
    rn=6378; % init:Rayon de la terre jusqu'au niveau niveau du sol(alt=0)Km
    Agaz=0; %Représente l'affaiblissement totoal due au trajet
    sigman=[0];
    alt=0;
    
    % Calcule de l'index de longitude et latitude au coins gauche des 4
    % points les plus proches de l'implacement voulues
    [r,c]=find(Mlong_1dot125<=lon);
    coins_j=max(c);
    [r,c]=find(Mlat_1dot125>=lat);
    coins_i=max(r);
    [t,p,rhoo,e]=get_TPe2(lat,lon,alt,percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,rho);

    for i=1:732 %15km
        %Calcule de l'épaisseur de la couches
        sigma=0.0001*exp((i-1)/100); %Km 10cm - 1Km
        sigman=[sigman sigma];
        rn=rn+sigman(i);

        an=(-rn*cosd(Bn))+(0.5*sqrt( (4*(rn^2)*(cosd(Bn)^2))+(8*rn*sigma)+(4*(sigma^2)) ));
        Agaz=Agaz+(an*(Aff));
        
        %Cacule de l'angle d'incidence de la couche suivant
        alphan=radtodeg(pi-acos((-(an^2)-(2*rn*sigma)-(sigma^2))/((2*an*rn)+(2*an*sigma))));
        [t2,p2,rhoo2,e2]=get_TPe2(lat,lon,(alt+sigma),percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,rho);
        Bn=asind(((indRefract(lat,lon,alt,percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j,t,p,e))/(indRefract(lat,lon,(alt+sigma),percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j,t2,p2,e2)))*sind(alphan)) ;
        alt=sum(sigman);
        
        
        %Calcule l'affeiblissemnt linéique du prochain couches en fonction
        %du paramétre de celle ci(P,T,rho)
        [Loo,Lww]=AffGaz(lat,lon,saison,f,elev,t2,p2,rhoo2,percent,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
        Aff=Loo+Lww;
        
        %On change la valeur de t,p,e pour la prochaine couche
        t=t2;
        p=p2;
        e=e2;
    end
    
    
    for i=733:922
        %Calcule de l'épaisseur de la couches
        sigma=0.0001*exp((i-1)/100); %Km 10cm - 1Km
        sigman=[sigman sigma];
        rn=rn+sigman(i);

        an=(-rn*cosd(Bn))+(0.5*sqrt( (4*(rn^2)*(cosd(Bn)^2))+(8*rn*sigma)+(4*(sigma^2)) ));
        Agaz=Agaz+(an*(Aff));
        %si on atteint la 922 couches alors on arrête la boucle sinon on va
        %calculer le prochain rayon incident 
        if i==922
            break
        end
        %Cacule de l'angle d'incidence de la couche suivant
        alphan=radtodeg(pi-acos((-(an^2)-(2*rn*sigma)-(sigma^2))/((2*an*rn)+(2*an*sigma))));
        [t2,p2,rhoo2,e2]=get_TPe2(lat,lon,(alt+sigma),percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j);
        Bn=asind(((indRefract(lat,lon,alt,percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j,t,p,e))/(indRefract(lat,lon,(alt+sigma),percent,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j,t2,p2,e2)))*sind(alphan)) ;
        alt=sum(sigman);
        
        
        %Calcule l'affeiblissemnt linéique du prochain couches en fonction
        %du paramétre de celle ci(P,T,rho)
        [Loo,Lww]=AffGaz(lat,lon,saison,f,elev,t2,p2,rhoo2,percent,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
        Aff=Loo+Lww;
        
        %On change la valeur de t,p,e pour la prochaine couche
        t=t2;
        p=p2;
        e=e2;
    end

end

end