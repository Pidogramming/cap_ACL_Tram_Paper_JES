classdef ResultsTram
    %--- Plot Variables
    %-- Time
    properties
        ID
        alpha = 0.01;
        xTime   % Time plotting data
        limTime % Time plotting limit
        unitsTime
        
        ySpd
        unitsSpd = '[km/h]'
        limSpd
        
        xDst
        yDist
        limDst
        unitsDst
        
        limForces
        unitsForces
        
        limPowers
        unitsPowers
    end
    
    methods
        function obj = ResultsTram(trm)
            obj.ID = trm.ID;
            %- Speed
            obj.ySpd = trm.spdArray * 3.6; %mps2kph
            [minx, maxx] = bounds(obj.ySpd);
            lower = minx - (obj.alpha * (maxx - minx));
            upper = maxx + (obj.alpha * (maxx - minx));
            obj.limSpd = [lower, upper];
            
            %- Time
            obj.xTime = trm.timeArray;
            if obj.xTime(trm.k) < 120  % < 2 minutes
                obj.unitsTime = '[sec]';
            else
                obj.xTime = obj.xTime/60;
                obj.unitsTime ='[minutes]';
            end
            [minx, maxx] = bounds(obj.xTime);
            lower = minx - (obj.alpha * (maxx - minx));
            upper = maxx + (obj.alpha * (maxx - minx));
            obj.limTime = [lower, upper];
            
            %- Distance
            obj.xDst = trm.dstArray;
            if obj.xDst(trm.k) < 1000  % < 1 km
                obj.yDist = obj.xDst;
                obj.unitsDst = '[m]';
            else
                [obj.xDst, obj.yDist] = deal(obj.xDst / 1e3);
                obj.unitsDst ='[km]';
            end
            [minx, maxx] = bounds(obj.xDst);
            lower = minx - (obj.alpha * (maxx - minx));
            upper = maxx + (obj.alpha * (maxx - minx));
            obj.limDst = [lower, upper];
        end
    end
    
    methods
        function plotSpeed(obj, ax)
            % It can plot on a given axes ax
            if nargin == 1
                plot(obj.xTime , obj.ySpd), box off
            end
            if narign == 2 && not(isempt(ax)) && isfinite(ax)
                plot(ax, obj.xTime , obj.ySpd), box off
            end
            ylabel(['Speed ', obj.unitsSpd]);
            ylim(obj.limSpd);
            
            xlabel (['Time ', obj.unitsTime]);
            xlim(obj.limTime)
        end
        function plotSpeed210(obj)
            % 2 axes
            % i)  Time, Speed
            % ii) Distance, speed
            set(groot, 'DefaultLineLineWidth', 1.2)
            hf = figure('name', obj.ID);
            set(hf, 'Units', 'normalized', 'Position', [.3 .09 .5 .75])
            set(hf, 'invertHardcopy', 'off' ) % Keep background @save
            
            %-- axes 1 --- Time , Speed
            ax1 = subplot(2,1,1);  
            set(ax1,'Position', get(ax1,'Position').* [.45, 1, 1.2, 1.1])
            plot(obj.xTime , obj.ySpd), box off
            lby = ylabel({['Speed ', obj.unitsSpd]});
            ylim(obj.limSpd);
            
            lbx = xlabel ({['Time ', obj.unitsTime], 'a)'});
            xlim(obj.limTime)
            title(obj.ID, 'FontSize',12, 'FontName','TimesNewRomans',...
                'HorizontalAlignment', 'right', 'Interpreter', 'none')
            
            %--- axes 2 --- Distance, Speed
            ax2 = subplot(2,1,2); 
            set(ax2,'Position', get(ax2,'Position').* [.45, 1, 1.2, 1.1])
            plot(obj.xDst , obj.ySpd), box off
            lby2 = ylabel({['Speed ', obj.unitsSpd]});
            ylim(obj.limSpd);
            
            lbx2 = xlabel ({['Distance ', obj.unitsSpd], 'b)'});
            xlim(obj.limDst)
            %-- Set labels text
            set([lby, lbx, lby2, lbx2],'FontSize',11,'FontWeight','bold')

            set(groot, 'DefaultLineLineWidth', 'default')
        end
        function plotSpeed212(obj, route)
            % axes 1 : yyaxis speed, distance, vs time
            % axes 2 : xTicks to be station position
        end
        function lim = getLimts(obj, data)
            [minx, maxx] = bounds(data);
            lower = minx - (obj.alpha * (maxx - minx));
            upper = maxx + (obj.alpha * (maxx - minx));
            lim = [lower, upper];
        end
    end
end