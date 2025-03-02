function [ sens,CsurNdesire,EbNoreq ] = sensibilite( TEB,B,Rb,NFsys,Tsys,mod,etat )
%% 1-Calcule de sensibilit� du recepteur
%Calcule du bruits a l'entr�e du recepteur
    Ne=10*log10((1.38*10^-23)*Tsys*B)+30        %[dBm]
    %CAlcule du "receiver Noise Floor"
    RNF=Ne+NFsys; %[dBm]
    %calcule du Eb/No requis pout TEB souhait�e
    BER=berawgn(0:0.1:18,mod,etat,'nondiff');
    EbNoreq=interp1(BER,0:0.1:18,TEB,'linear');%[dB]
    %Calcule de C/N
    CsurNdesire=EbNoreq+(10*log10(Rb))-(10*log10(B)); %[dB]
    %Calcule du sensibilit� du recpterur
    sens=RNF+CsurNdesire;%[dBm]
end

