classdef ClAtom < Atom
    
    methods
        
        function obj = ClAtom(ind)
            obj@Atom(ind);
            obj.SetAtomicParameters();
        end
        
    end
    
    methods (Access = protected)
        
        function SetAtomicParameters(obj)
            obj.atomType = AtomType.Cl;
            obj.atomicMass = 35.453*Parameters.GetInstance().GetGMolin2AU();
            obj.coreCharge = 7.0;
            obj.numberValenceElectrons = 7;
            obj.valenceShellType = ShellType.mShell;
            obj.valence{1} = OrbitalType.s;
            obj.valence{2} = OrbitalType.py;
            obj.valence{3} = OrbitalType.pz;
            obj.valence{4} = OrbitalType.px;
            if(Parameters.GetInstance().GetCurrentTheory() == TheoryType.CNDO2)
                obj.valence{5} = OrbitalType.dxy;
                obj.valence{6} = OrbitalType.dyz;
                obj.valence{7} = OrbitalType.dzz;
                obj.valence{8} = OrbitalType.dzx;
                obj.valence{9} = OrbitalType.dxxyy;
            end
            for i=1:length(obj.valence)
                obj.realSphericalHarmonicsIndices{i} = RealSphericalHarmonicsIndex(obj.valence{i});
            end
            obj.vdWCoefficient = 8.00*Parameters.GetInstance().GetJ2AU()...
                *power(Parameters.GetInstance().GetNm2AU(),6.0)...
                /Parameters.GetInstance().GetAvogadro();
            obj.vdWRadii = 1.820*Parameters.GetInstance().GetAngstrom2AU();
            obj.bondingParameter = -22.330*Parameters.GetInstance().GetEV2AU();
            obj.imuAmuS = 21.591*Parameters.GetInstance().GetEV2AU();
            obj.imuAmuP = 8.708*Parameters.GetInstance().GetEV2AU();
            obj.imuAmuD = 0.977*Parameters.GetInstance().GetEV2AU();
            obj.effectiveNuclearChargeK = 16.70;
            obj.effectiveNuclearChargeL = 12.85;
            if(Parameters.GetInstance().GetCurrentTheory() == TheoryType.ZINDOS)
                obj.effectiveNuclearChargeMsp = 2.130*3.0; % from orca 3.0.1
                obj.effectiveNuclearChargeMd  = 0.0;       % not used
            else
                obj.effectiveNuclearChargeMsp = 6.10;
                obj.effectiveNuclearChargeMd  = 6.10;
            end
            
            % ORCA parameter 3.0.1 set
            % see "ORCA 2.8"( http:%www.thch.uni-bonn.de/tc/orca/ ).
            obj.zindoBondingParameterS = -11.0*Parameters.GetInstance().GetEV2AU();
            obj.zindoBondingParameterD =   0.0*Parameters.GetInstance().GetEV2AU();
            obj.zindoF0ss = 11.25 * Parameters.GetInstance().GetEV2AU();
            obj.zindoF0sd = 0.0;
            obj.zindoF0dd = 0.0;
            obj.zindoG1sp = 8.8027 * Parameters.GetInstance().GetEV2AU();
            obj.zindoF2pp = 6.4470 * Parameters.GetInstance().GetEV2AU();
            obj.zindoG2sd = 0.0;
            obj.zindoG1pd = 0.0;
            obj.zindoF2pd = 0.0;
            obj.zindoG3pd = 0.0;
            obj.zindoF2dd = 0.0;
            obj.zindoF4dd = 0.0;
            % end (ORCA 2.8 parameter set)
            
            obj.zindoL = 2;
            obj.zindoM = 5;
            obj.zindoN = 0;
            obj.zindoIonPotS = 25.23 * Parameters.GetInstance().GetEV2AU();
            obj.zindoIonPotP = 15.03 * Parameters.GetInstance().GetEV2AU();
            obj.zindoIonPotD =  6.00 * Parameters.GetInstance().GetEV2AU();
            obj.mndoCoreintegralS = -100.227166 * Parameters.GetInstance().GetEV2AU();
            obj.mndoCoreintegralP = -77.378667 * Parameters.GetInstance().GetEV2AU();
            obj.mndoOrbitalExponentS = 3.784645;
            obj.mndoOrbitalExponentP = 2.036263;
            obj.mndoBondingParameterS = -14.262320 * Parameters.GetInstance().GetEV2AU();
            obj.mndoBondingParameterP = -14.26320 * Parameters.GetInstance().GetEV2AU();
            obj.mndoAlpha = 2.542201 / Parameters.GetInstance().GetAngstrom2AU();
            obj.mndoElecEnergyAtom = -353.137667 * Parameters.GetInstance().GetEV2AU();
            obj.mndoHeatsFormAtom = 28.99 * Parameters.GetInstance().GetKcalMolin2AU();
            obj.mndoGss =  15.03 * Parameters.GetInstance().GetEV2AU();
            obj.mndoGpp =  11.30 * Parameters.GetInstance().GetEV2AU();
            obj.mndoGsp =  13.16 * Parameters.GetInstance().GetEV2AU();
            obj.mndoGpp2 =  9.97 * Parameters.GetInstance().GetEV2AU();
            obj.mndoHsp =   2.42 * Parameters.GetInstance().GetEV2AU();
            obj.mndoDerivedParameterD(1) =   0.0;
            obj.mndoDerivedParameterD(2) =   0.4986870220;
            obj.mndoDerivedParameterD(3) =   0.8217602800;
            obj.mndoDerivedParameterRho(1) = 0.5/0.5523379209;
            obj.mndoDerivedParameterRho(2) = 0.5/0.8061021276;
            obj.mndoDerivedParameterRho(3) = 0.5/0.6053315152;
            obj.am1CoreintegralS = -111.613948 * Parameters.GetInstance().GetEV2AU();
            obj.am1CoreintegralP =  -76.640107 * Parameters.GetInstance().GetEV2AU();
            obj.am1OrbitalExponentS = 3.631376;
            obj.am1OrbitalExponentP = 2.076799;
            obj.am1BondingParameterS = -24.594670 * Parameters.GetInstance().GetEV2AU();
            obj.am1BondingParameterP = -14.637216 * Parameters.GetInstance().GetEV2AU();
            obj.am1Alpha = 2.919368 / Parameters.GetInstance().GetAngstrom2AU();
            obj.am1Gss  = obj.mndoGss;
            obj.am1Gpp  = obj.mndoGpp;
            obj.am1Gsp  = obj.mndoGsp;
            obj.am1Gpp2 = obj.mndoGpp2;
            obj.am1Hsp  = obj.mndoHsp;
            obj.am1DerivedParameterD(1) = 0.0;
            obj.am1DerivedParameterD(2) = 0.5406286370;
            obj.am1DerivedParameterD(3) = 0.8057207525;
            obj.am1DerivedParameterRho(1) = 0.5/0.5523379209;
            obj.am1DerivedParameterRho(2) = 0.5/0.7693007940;
            obj.am1DerivedParameterRho(3) = 0.5/0.6133247965;
            obj.am1ParameterK(1) = 0.094243 * Parameters.GetInstance().GetEV2AU();
            obj.am1ParameterK(2) = 0.027168 * Parameters.GetInstance().GetEV2AU();
            obj.am1ParameterK(3) = 0.00 * Parameters.GetInstance().GetEV2AU();
            obj.am1ParameterK(4) = 0.00 * Parameters.GetInstance().GetEV2AU();
            obj.am1ParameterL(1) = 4.00 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.am1ParameterL(2) = 4.00 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.am1ParameterL(3) = 0.00 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.am1ParameterL(4) = 0.00 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.am1ParameterM(1) = 1.30 * Parameters.GetInstance().GetAngstrom2AU();
            obj.am1ParameterM(2) = 2.10 * Parameters.GetInstance().GetAngstrom2AU();
            obj.am1ParameterM(3) = 0.00 * Parameters.GetInstance().GetAngstrom2AU();
            obj.am1ParameterM(4) = 0.00 * Parameters.GetInstance().GetAngstrom2AU();
            obj.am1DCoreintegralS = obj.am1CoreintegralS;
            obj.am1DCoreintegralP = obj.am1CoreintegralP;
            obj.am1DBondingParameterS = obj.am1BondingParameterS;
            obj.am1DBondingParameterP = obj.am1BondingParameterP;
            obj.am1DAlpha = obj.am1DAlpha;
            obj.pm3CoreintegralS = -100.626747 * Parameters.GetInstance().GetEV2AU();
            obj.pm3CoreintegralP =  -53.614396 * Parameters.GetInstance().GetEV2AU();
            obj.pm3OrbitalExponentS = 2.246210;
            obj.pm3OrbitalExponentP = 2.151010;
            obj.pm3BondingParameterS = -27.528560 * Parameters.GetInstance().GetEV2AU();
            obj.pm3BondingParameterP = -11.593922 * Parameters.GetInstance().GetEV2AU();
            obj.pm3Alpha = 2.517296 / Parameters.GetInstance().GetAngstrom2AU();
            obj.pm3DerivedParameterD(1) = 0.0;
            obj.pm3DerivedParameterD(2) = 0.9175855709;
            obj.pm3DerivedParameterD(3) = 0.7779229539;
            obj.pm3DerivedParameterRho(1) = 0.5/0.5884843036;
            obj.pm3DerivedParameterRho(2) = 0.5/0.6814322305;
            obj.pm3DerivedParameterRho(3) = 0.5/0.2074800643;
            obj.pm3ParameterK(1) = -0.171591 * Parameters.GetInstance().GetEV2AU();
            obj.pm3ParameterK(2) = -0.013458 * Parameters.GetInstance().GetEV2AU();
            obj.pm3ParameterK(3) = 0.0;
            obj.pm3ParameterK(4) = 0.0;
            obj.pm3ParameterL(1) = 6.000802 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.pm3ParameterL(2) = 1.966618 / power(Parameters.GetInstance().GetAngstrom2AU(),2.0);
            obj.pm3ParameterL(3) = 0.00;
            obj.pm3ParameterL(4) = 0.00;
            obj.pm3ParameterM(1) = 1.087502 * Parameters.GetInstance().GetAngstrom2AU();
            obj.pm3ParameterM(2) = 2.292891 * Parameters.GetInstance().GetAngstrom2AU();
            obj.pm3ParameterM(3) = 0.00;
            obj.pm3ParameterM(4) = 0.00;
            obj.pm3Gss  = 16.013601 * Parameters.GetInstance().GetEV2AU();
            obj.pm3Gpp  =  7.522215 * Parameters.GetInstance().GetEV2AU();
            obj.pm3Gsp  =  8.048115 * Parameters.GetInstance().GetEV2AU();
            obj.pm3Gpp2 =  7.504154 * Parameters.GetInstance().GetEV2AU();
            obj.pm3Hsp  =  3.481153 * Parameters.GetInstance().GetEV2AU();
            
            obj.pm3DCoreintegralS = obj.pm3CoreintegralS;
            obj.pm3DCoreintegralP = obj.pm3CoreintegralP;
            obj.pm3DBondingParameterS = obj.pm3BondingParameterS;
            obj.pm3DBondingParameterP = obj.pm3BondingParameterP;
            obj.pm3DAlpha = obj.pm3Alpha;
        end
        
    end
    
end