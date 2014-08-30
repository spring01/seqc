classdef Molecule < handle
    
    properties (SetAccess = private)
        
        atomVect = {};
        epcVect = {};      % Vector of Environmental Point Charges
        xyzCOM; % x, y, z coordinates of the center of atomic mass;
        xyzCOC; % x, y, z coordinates of the center of core's mass;
        distanceAtoms;    % distance between each atom;
        distanceEpcs;     % distance between each environmental point charge;
        distanceAtomsEpcs;% distance between each atom and environmental point charge;
        totalNumberAOs;
        totalNumberValenceElectrons;
        totalCoreMass;
        
    end
    
    methods
        
        function obj = Molecule()
        end
        
        function res = GetAtomVect(obj)
            res = obj.atomVect;
        end
        
        function res = GetEpcVect(obj)
            res = obj.epcVect;
        end
        
        function AddAtom(obj, atom)
            obj.atomVect{end+1} = atom;
        end
        
        function AddEpc(obj, epc)
            obj.epcVect{end+1} = epc;
        end
        
        function res = GetXyzCOM(obj)
            res = obj.xyzCOM;
        end
        
        function res = GetXyzCOC(obj)
            res = obj.xyzCOC;
        end
        
        function res = GetXyzDipoleCenter(obj)
            res = obj.xyzCOC;
        end
        
        function CalcBasics(obj)
            obj.CalcTotalNumberAOs();
            obj.CalcTotalNumberValenceElectrons();
            obj.CalcTotalCoreMass();
            obj.CalcBasicsConfiguration();
        end
        
        function CalcBasicsConfiguration(obj)
            obj.CalcXyzCOM();
            obj.CalcXyzCOC();
            obj.CalcDistanceAtoms();
            obj.CalcDistanceEpcs();
            obj.CalcDistanceAtomsEpcs();
        end
        
        function res = GetTotalNumberAOs(obj)
            res = obj.totalNumberAOs;
        end
        
        function res = GetTotalNumberValenceElectrons(obj)
            res = obj.totalNumberValenceElectrons;
        end
        
        function res = GetTotalCoreMass(obj)
            res = obj.totalCoreMass;
        end
        
        function [inertiaMoments, inertiaTensor] = CalcPrincipalAxes(obj)
            obj.CalcXyzCOM();
            inertiaTensorOrigin = obj.xyzCOM;
            inertiaTensor = obj.CalcInertiaTensor(inertiaTensorOrigin);
            inertiaMoments = eig(inertiaTensor);
        end
        
        function res = GetDistanceAtoms(obj, arg1, arg2)
            if(isnumeric(arg1) && isnumeric(arg2))
                indexAtomA = arg1;
                indexAtomB = arg2;
            elseif(isa(arg1, 'Atom') && isa(arg2, 'Atom'))
                indexAtomA = arg1.GetIndex();
                indexAtomB = arg2.GetIndex();
            else
                throw(MException('Molecule:GetDistanceAtoms', 'Input argument type wrong.'));
            end
            res = obj.distanceAtoms(indexAtomA, indexAtomB);
        end
        
        function res = GetDistanceEpcs(obj, arg1, arg2)
            if(isnumeric(arg1) && isnumeric(arg2))
                indexEpcA = arg1;
                indexEpcB = arg2;
            elseif(isa(arg1, 'Atom') && isa(arg2, 'Atom'))
                indexEpcA = arg1.GetIndex();
                indexEpcB = arg2.GetIndex();
            else
                throw(MException('Molecule:GetDistanceEpcs', 'Input argument type wrong.'));
            end
            res = obj.distanceEpcs(indexEpcA, indexEpcB);
        end
        
        function res = GetDistanceAtomEpc(obj, arg1, arg2)
            if(isnumeric(arg1) && isnumeric(arg2))
                indexAtom = arg1;
                indexEpc = arg2;
            elseif(isa(arg1, 'Atom') && isa(arg2, 'Atom'))
                indexAtom = arg1.GetIndex();
                indexEpc = arg2.GetIndex();
            else
                throw(MException('Molecule:GetDistanceAtomEpc', 'Input argument type wrong.'));
            end
            res = obj.distanceAtomsEpcs(indexAtom, indexEpc);
        end
        
    end
    
    methods (Access = private)
        
        function CalcTotalNumberAOs(obj)
            obj.totalNumberAOs = 0; 
            for i = 1:length(obj.atomVect)
                obj.atomVect{i}.SetFirstAOIndex(obj.totalNumberAOs + 1);
                obj.totalNumberAOs = obj.totalNumberAOs + obj.atomVect{i}.GetValenceSize();
            end
        end
        
        function CalcTotalNumberValenceElectrons(obj)
            obj.totalNumberValenceElectrons = 0;
            for i = 1:length(obj.atomVect)
                obj.totalNumberValenceElectrons = obj.totalNumberValenceElectrons + obj.atomVect{i}.GetNumberValenceElectrons();
            end
        end
        
        function CalcTotalCoreMass(obj)
            obj.totalCoreMass = 0; 
            for i = 1:length(obj.atomVect)
                coreMass = obj.atomVect{i}.GetCoreMass();
                obj.totalCoreMass = obj.totalCoreMass + coreMass;
            end
        end
        
        function CalcXyzCOM(obj)
            totalAtomicMass = 0.0;
            obj.xyzCOM = zeros(1, 3);
            for i = 1:length(obj.atomVect)
                atomicXyz = obj.atomVect{i}.GetXyz();
                atomicMass = obj.atomVect{i}.GetAtomicMass();
                totalAtomicMass = totalAtomicMass + atomicMass;
                obj.xyzCOM = obj.xyzCOM + atomicXyz .* atomicMass;
            end
            obj.xyzCOM = obj.xyzCOM ./ totalAtomicMass;
        end
        
        function CalcXyzCOC(obj)
            totalCoreMass_ = 0.0;
            obj.xyzCOC = zeros(1, 3);
            for i = 1:length(obj.atomVect)
                atomicXyz = obj.atomVect{i}.GetXyz();
                coreMass = obj.atomVect{i}.GetCoreMass();
                totalCoreMass_ = totalCoreMass_ + coreMass;
                obj.xyzCOC = obj.xyzCOC + atomicXyz .* coreMass;
            end
            obj.xyzCOC = obj.xyzCOC ./ totalCoreMass_;
        end
        
        function CalcDistanceAtoms(obj)
            for a = 1:length(obj.atomVect)
                atomA = obj.atomVect{a};
                for b = a:length(obj.atomVect)
                    atomB = obj.atomVect{b};
                    obj.distanceAtoms(a, b) = norm(atomA.GetXyz() - atomB.GetXyz());
                end
            end
            obj.distanceAtoms = obj.distanceAtoms + obj.distanceAtoms' - diag(diag(obj.distanceAtoms));
        end
        
        function CalcDistanceEpcs(obj)
            for a = 1:length(obj.epcVect)
                epcA = obj.epcVect{a};
                for b = a:length(obj.epcVect)
                    epcB = obj.epcVect{b};
                    obj.distanceEpcs(a, b) = norm(epcA.GetXyz() - epcB.GetXyz());
                end
            end
            obj.distanceEpcs = obj.distanceEpcs + obj.distanceEpcs' - diag(diag(obj.distanceEpcs));
        end
        
        function CalcDistanceAtomsEpcs(obj)
            for a = 1:length(obj.atomVect)
                atom = obj.atomVect{a};
                for b = 1:length(obj.epcVect)
                    epc = obj.epcVect{b};
                    obj.distanceAtomsEpcs(a, b) = norm(atom.GetXyz() - epc.GetXyz());
                end
            end
        end
        
        function inertiaTensor = CalcInertiaTensor(obj, inertiaTensorOrigin)
            inertiaTensor = zeros(3, 3);
            for a = 1:length(obj.atomVect)
                atomicMass = obj.atomVect{a}.GetAtomicMass();
                xyz = obj.atomVect{a}.GetXyz();
                x = xyz(1) - inertiaTensorOrigin(1);
                y = xyz(2) - inertiaTensorOrigin(2);
                z = xyz(3) - inertiaTensorOrigin(3);
                
                inertiaTensor(1, 1) = inertiaTensor(1, 1) + atomicMass*(y*y + z*z);
                inertiaTensor(1, 2) = inertiaTensor(1, 2) - atomicMass*x*y;
                inertiaTensor(1, 3) = inertiaTensor(1, 3) - atomicMass*x*z;
                
                inertiaTensor(2, 1) = inertiaTensor(2, 1) - atomicMass*y*x;
                inertiaTensor(2, 2) = inertiaTensor(2, 2) + atomicMass*(x*x + z*z);
                inertiaTensor(2, 3) = inertiaTensor(2, 3) - atomicMass*y*z;
                
                inertiaTensor(3, 1) = inertiaTensor(3, 1) - atomicMass*z*x;
                inertiaTensor(3, 2) = inertiaTensor(3, 2) - atomicMass*z*y;
                inertiaTensor(3, 3) = inertiaTensor(3, 3) + atomicMass*(x*x + y*y);

            end
        end
        
    end
    
end


