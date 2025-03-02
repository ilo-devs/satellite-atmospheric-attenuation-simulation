function [rr,p0] = taux_precipitation(p,lat,lon)
%
%-------------------------------------------------------------------------------------------------------------------
%
% function [rr,p0] = itur_p837_5(p,lat,lon)
%
% This function calculates the rainfall rate exceeded for p% of an average year, 
% according to the prediction method defined in Recommendation ITU-R P.837-5 (Annex 1).
%
% France (G. Blarzino, N. Jeannin, L. Castanet), Italy (D. Ferraro, L. Luini, C. Capsoni), ESA (A. Martellucci) :
% “Discussion document about Recommendation ITU-R P.837-4”, Input document 3J/185-3M/217, 11 April 2007.
%
% Castanet L., Blarzino G., Jeannin N., Testoni A., Capsoni C., Ferraro D., Luini L.,
% Rogers D., Amaya C., Bouchard P., Pontes M., Sila-Mello L. :
% "Assessment of radiowave propagation for satellite communication and navigation systems
% in tropical and equatorial areas",
% Final Report ESA study n° ESTEC 18278/04/NL/US, Report ONERA RF 4/09521 DEMR, June 2007.
%
%
% Input parameters :
%   p   = probability level (%)  (more than 1 level is possible ONLY if 1 location is desired)
%   lat = latitude          (deg)
%   lon = longitude         (deg)
%   If rainfall rate is to be calculated at 1 specific location, bilinear interpolation
%   (INTERP2.M) is used to obtain values at (lat,lon) coordinates specified in input.
%   If a map of rainfall rate is to be calculated all over the world,
%   DO NOT ENTER (lat,lon) coordinates as input.
%
% Output parameters :   
%   rr = rainfall rate exceeded for p% of an average year  (mm/h)
%   p0 = percentage probability of rain in an average year (%)
%
% Note :
%   The function automatically loads meteorological input parameters required by 
%   Rec. ITU-R P.837-5 from the following files :
%       ESARAIN_MT_v5.TXT :     mean annual rainfall amount                   (mm)
%       ESARAIN_BETA_v5.TXT :   ratio of convective to total rainfall amount  (-)
%       ESARAIN_PR6_v5.TXT :    probability of rainy 6-hours periods          (%)
%       ESARAIN_LAT_v5.TXT :    latitudes of grid points (90:-1.125:-90)      (deg)
%       ESARAIN_LON_v5.TXT :    longitudes of grid points (0:1.125:360)       (deg)
%
% Called functions :
%   No
%
% Necessary toolboxes :
%   No
%
% by Giulio BLARZINO,
% ONERA, France
% Giulio.Blarzino@onera.fr
% Any questions : email <Laurent.Castanet@onera.fr> or <Antonio.Martellucci@esa.int>
%
% rel. 1.0
% release history:
%   0.0 (26/04/2007)    - original version
%   1.0 (11/07/2007)
%
%-------------------------------------------------------------------------------------------------------------------

% load input meteorological paramaters
load('data_rain_rate');


if nargin > 1
    % convert longitudes to 0E .. 360E format 
    if lon < 0
        lon = lon + 360;
    end

    % bi-linear interpolation of parameters @ the required coordinates
    pr6i  = interp2(Long_1dot125,Lat_1dot125,Pr6_1dot125,lon,lat,'linear');
    mti   = interp2(Long_1dot125,Lat_1dot125,Mt_1dot125,lon,lat,'linear');
    betai = interp2(Long_1dot125,Lat_1dot125,Beta_1dot125,lon,lat,'linear');

    % extract mean annual rainfall amount of stratiform type
    msi = mti.*(1 - betai);

    % percentage probability of rain in an average year
    p0 = pr6i.*(1 - exp(-0.0079.*(msi./pr6i)));

    % calculate rainfall rate exceeded for p% of the average year 
    % for all the probability levels given in input
    if isnan(p0)
       p0 = 0;
       rr = 0;
    else
       rr = zeros(size(p));
       ix = find(p > p0);
       if ~isempty(ix),
          rr(ix) = 0;
       end;
       ix = find(p <= p0);
       if ~isempty(ix),
          a = 1.09;
          b = mti./(21797.*p0);
          c = 26.02.*b;
          A = a.*b;
          B = a + c.*log(p(ix)./p0);
          C = log(p(ix)./p0);
          rr(ix) = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
       end
    end
else

    % extract mean annual rainfall amount of stratiform type
    ms = Mt_1dot125.*(1 - Beta_1dot125);

    % percentage probability of rain in an average year
    p0 = Pr6_1dot125.*(1 - exp(-0.0079.*(ms./Pr6_1dot125)));

    % calculate rainfall rate exceeded for p% of the average year 
    % for all the probability levels given in input
    if isnan(p0)
        p0 = 0;
        rr = 0;
    else
        rr = zeros(size(Mt_1dot125));
        if p > p0
           rr(:,:) = 0;
        else
           a = 1.09;
           b = Mt_1dot125./(21797.*p0);
           c = 26.02.*b;
           A = a.*b;
           B = a + c.*log(p./p0);
           C = log(p./p0);
           rr = (-B + sqrt(B.^2 - 4*A.*C))./(2*A);
        end
    end
end
    
return
