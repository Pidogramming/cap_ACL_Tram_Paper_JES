classdef Route < matlab.mixin.SetGet
    properties (Hidden)
        AM = 1;         % Altitude Scaler
        HDM = 1;        % Horizontal Distance Scaler
    end
    properties
        name
        numStn   % Number of stations
        stnNames
        
        numSections
        sectionNames
        sectionDist
        
        hozDist {mustBeNonnegative, mustBeReal} %Horizontal distance
        actDist           % 'actDistance' : actual distance
        atd               % 'atd' : altitudes
        
        stnPos_hozDist
        stnPos_actDist                  % Actual distances
        stnAtd                         % Stations Altitudes
    end
    
    methods % Constructor
        function obj = Route(routeData)
            obj.name = routeData.name;
            obj.stnNames = routeData.stnNames;
            obj.hozDist = routeData.hozDistance * obj.HDM;
            obj.atd = routeData.altitude * obj.AM;
            obj.stnPos_hozDist = routeData.stnPositions;
            obj.numStn = length(routeData.stnPositions);
            
            obj.numSections = obj.numStn - 1;
            obj.sectionNames = ...
                obj.stnNames(1 : end-1) + "-" + obj.stnNames(2:end);
                       
            obj.actDist = obj.hozDist * NaN;   % Maintain dimension
            computeActualDistance(obj);
                 
            obj.stnPos_actDist = obj.stnPos_hozDist * NaN;
            obj.stnAtd         = obj.stnPos_hozDist * NaN;
            adjustStnPostionAltitude(obj);
            obj.sectionDist = ...
                obj.stnPos_hozDist(2:end) - obj.stnPos_hozDist(1:end-1);
        end
    end
    
    methods %APIs
        function grad = getGradient(obj, s)
            %- Returns gradient given distance s from terminal
            distPts = obj.actDist;  % Route distance Points to be used
            
            if max(s) > max(distPts) || min(s) < min(distPts)
                error('Point(s) is outside the route')
            end
            
            grad = s * NaN;
            for k = 1 : length(s)
                indexLB = find((obj.actDist <= s(k)), 1, 'last');
                indexUB = find((obj.actDist > s(k)), 1, 'first');
                
                if isempty(indexUB), indexUB = indexLB; end
                
                run = obj.hozDist(indexUB) - obj.hozDist(indexLB);
                rise = obj.atd(indexUB) - obj.atd(indexLB);
                if run == 0   % if indexLB == indexUB, the last point
                    grad(k) = 0;
                else
                    grad(k) = rise/run;
                end
            end
        end
        
        function plotRoute(obj)
            plot_route(obj)
        end
        
        function sectTable = tableSectionDistances(obj)
            varNames = {'Section', 'Distance_m'};
            sectTable = table(obj.sectionNames',...
                uint16(obj.sectionDist),...
                'VariableNames', varNames);
        end
    end
    
    methods (Sealed, Access = private)
        function computeActualDistance(obj)
            % From horizontal distance and altitude, compute actual dist
            obj.actDist(1) = obj.hozDist(1);         
            for k = 2 : length(obj.hozDist)
                % Pythagoras theorem
                ds = sqrt((obj.hozDist(k) - obj.hozDist(k-1))^2 + ...
                    (obj.atd(k) - obj.atd(k-1))^2);
                obj.actDist(k) = obj.actDist(k-1) + ds;
            end
            
            if any(isnan(obj.actDist))
                error('Some actual distance data are NaN')
            end
            if any(obj.actDist - obj.hozDist < 0)
                error('Actual distace should be >= horizontal distance');
            end
            %  For small gradients, One may assume actual distance(actDist)
            %  to be equal horizontal distance (hozDist)
        end
        
        function adjustStnPostionAltitude(obj)
            % Adjusts station positions and [assign] altitutes
            % Moves station position to the closest horizontalDistance data
            % point
            % NOTE: Station positions are given in horizontal distances
            
            for k = 1 : obj.numStn
                % Find closest point to station
                % min of All_hozDist - stnPos_hozDist(k)
                [~, index] = min(abs(obj.hozDist - obj.stnPos_hozDist(k)));
                % Adjust station Position
                obj.stnPos_hozDist(k) = obj.hozDist(index);
                obj.stnPos_actDist(k) = obj.actDist(index);
                % Map station positions with altitudes
                obj.stnAtd(k) = obj.atd(index);
            end
        end
    end
end