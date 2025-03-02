function [ T,P,rho,e ] = get_TPe2( lat,lon,h,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j )
%Fonction qui nous permet d'avoir la température et la pression selon la
% latitude et l'altitude considérée
%   Entrée
%lat:latitude [Degrée]
%h: altitude [Km]
%%rho:densitée en vapeur d'eau [g/cm3] (ITUP.836)
%
%   Sortie
%T: Température [K]
%P:Pression [Hpa]

%On se met dans le cas ou l'utilisateur ne veut que T ou P 
if nargout>2
    %Dans le cas l'utilsiateur n'entre pas les index corspondant aux coins donc
    %on les calcule
    if nargin==11
        [r,c]=find(Mlong_1dot125<=lon);
        coins_j=max(c);
        [r,c]=find(Mlat_1dot125>=lat);
        coins_i=max(r);
        %Calcule de la concentration en vapeur d'eau selon latitude et longitude
        rho=dvap(lat,lon,perc,h,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j);
    elseif nargin==12
        rho=coins_i;
    elseif nargin==13
        %Calcule de la concentration en vapeur d'eau selon latitude et longitude
        rho=dvap(lat,lon,perc,h,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob,coins_i,coins_j);
    end
    
    
end

%Pour latitude basse
if lat<22
    %Calcule Température
    if h>=0 && h<17
        T=300.4222-(6.3533*h)+(0.005886*(h^2));
    elseif h>=17 && h<47
        T=194+((h-17)*2.533);
    elseif h>=47 && h<52
        T=270;
    elseif h>=52 && h<80
        T=270-((h-52)*3.0714);
    elseif h>=80 && h<=100
        T=184;
    end

    %Calcule Pression
    if h>=0 && h<=10
        P=1012.0306-(109.0338*h)+(3.6316*(h^2));
    elseif h>10 && h<=72
        [t,P10]=get_TPe2(lat,lon,10,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
        P=P10*exp(-0.147.*(h-10));
    elseif h>72 && h<=100
        [t,P72]=get_TPe2(lat,lon,72,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
        P=P72*exp(-0.165.*(h-72));
    end
    if nargout==2
        return
    end
%Pour latitude moyenne,cas été et hiver
elseif lat>=22 && lat<=45    
    if strcmp(saison,'été')
        %Calcule Température
        if h>=0 && h<13
            T=294.9838-(5.2159*h)+(0.07109*(h^2));
        elseif h>=13 && h<17
            T=215.5;
        elseif h>=17 && h<47
            T=215.5*exp((h-17)*0.008128);
        elseif h>=47 && h<53
            T=275;
        elseif h>=53 && h<80
            T=275+(20*(1-(exp((h-53)*0.06))));
        elseif h>=80 && h<=100
            T=175;
        end

        %Calcule Pression
        if h>=0 && h<=10
            P=1012.8186-(111.5569*h)+(3.8646*(h^2));
        elseif h>10 && h<=72
            [t,P10]=get_TPe2(lat,lon,10,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P10*exp(-0.147.*(h-10));
        elseif h>72 && h<=100
            [t,P72]=get_TPe2(lat,lon,72,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P72*exp(-0.165.*(h-72));
        end
   
    elseif strcmp(saison,'hiver')
        %Calcule Température
        if h>=0 && h<10
            T=272.7241-(3.6217*h)-(0.1759*(h^2));
        elseif h>=10 && h<33
            T=218;
        elseif h>=33 && h<47
            T=218+((h-33)*3.3571);
        elseif h>=47 && h<53
            T=265;
        elseif h>=53 && h<80
            T=265-((h-53)*2.0370);
        elseif h>=80 && h<=100
            T=210;
        end

        %Calcule Pression
        if h>=0 && h<=10
            P=1018.8627-(124.2954*h)+(4.8307*(h^2));
        elseif h>10 && h<=72
            [t,P10]=get_TPe2(lat,lon,10,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P10*exp(-0.147.*(h-10));
        elseif h>72 && h<=100
            [t,P72]=get_TPe2(lat,lon,72,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P72*exp(-0.155.*(h-72));
        end
            
    end
    if nargout==2
        return
    end

%Latitude élevée ,cas été et hiver
elseif lat>45   
    if strcmp(saison,'été')
        %Calcule Température
        if h>=0 && h<10
            T=286.8374-(4.7805*h)-(0.1402*(h^2));
        elseif h>=10 && h<23
            T=225;
        elseif h>=23 && h<48
            T=225*exp((h-23)*0.008317);
        elseif h>=48 && h<53
            T=277;
        elseif h>=53 && h<79
            T=277-((h-53)*4.0769);
        elseif h>=79 && h<=100
            T=171;
        end

        %Calcule Pression
        if h>=0 && h<=10
            P=1008.0278-(113.2494*h)+(3.9408*(h^2));
        elseif h>10 && h<=72
            [t,P10]=get_TPe2(lat,lon,10,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P10*exp(-0.140.*(h-10));
        elseif h>72 && h<=100
            [t,P72]=get_TPe2(lat,lon,72,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P72*exp(-0.165.*(h-72));
        end      
        
    elseif strcmp(saison,'hiver')
        %Calcule Température
        if h>=0 && h<8.5
            T=257.4345+(2.3474*h)-(1.5479*(h^2))+(0.08473*(h^3));
        elseif h>=8.5 && h<30
            T=217.5;
        elseif h>=30 && h<50
            T=217.5+((h-30)*2.125);
        elseif h>=50 && h<54
            T=260;
        elseif h>=54 && h<=100
            T=260-((h-54)*1.667);
        end

        %Calcule Pression
        if h>=0 && h<=10
            P=1010.8828-(122.2411*h)+(4.554*(h^2));
        elseif h>10 && h<=72
            [t,P10]=get_TPe2(lat,lon,10,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P10*exp(-0.147.*(h-10));
        elseif h>72 && h<=100
            [t,P72]=get_TPe2(lat,lon,72,perc,saison,topo_1dot125,vsch,Mlat_1dot125,Mlong_1dot125,vapd_gl,vapd_gl_prob);
            P=P72*exp(-0.150.*(h-72));
        end

            
    end 
    
    if nargout==2
        return
    end
    
end

%Calcule du pression partielle en vapeur d'eau
e=(rho*T)/216.7;

end

