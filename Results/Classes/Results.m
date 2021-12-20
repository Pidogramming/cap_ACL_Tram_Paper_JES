classdef Results < matlab.mixin.SetGet
    properties
        alpha = 0.01;
        xTm     % Time plotting data
        limTm   % Time plotting limit
        unitsTm
        
        yPe   % Electrical power demand
        unitsPe
        limPe
    end
    
    methods
        function obj = Results(inObj)
            if nargin >= 1 && isobject(inObj)
                obj.xTm = inObj.timeArray;
                
                if obj.xTm(inObj.k) < 120  % < 2 minutes
                    obj.unitsTm = '[sec]';
                else
                    obj.xTm = obj.xTm / 60;
                    obj.unitsTm ='[minutes]';
                end
                
                if isa(inObj, 'Tram')
                    obj.yPe = inObj.peArray;
                else
                    obj.yPe = inObj.powerArray;
                end
                
                if any(obj.yPe > 1e3)
                    obj.yPe = obj.yPe/ 1e3;
                    obj.unitsPe = '[kW]';
                else
                    obj.unitsPe = '[W]';
                end
                
                obj.limTm = getLimits(obj, obj.xTm);
                obj.limPe = getLimits(obj, obj.yPe);
            end
            
        end
    end
    
    methods (Access = protected)
        function lim = getLimits(obj, data)
            % Limits for plotting
            [minx, maxx] = bounds(data);
            lower = minx - (obj.alpha * (maxx - minx));
            upper = maxx + (obj.alpha * (maxx - minx));
            lim = [lower, upper];
        end
    end
end