classdef ResultsLine < Results
    properties
        acl
        
        yV
        unitsV = '[V]'
        limV
        
        yI
        unitsI = '[A]'
        limI
    end
    
    methods
        function obj = ResultsLine(inObj)
            if not(isobject(inObj))
                error('@Results : ACL needs to be an Object')
            end         
            obj@Results(inObj)
            
            % Voltage and Line Object
            if isa(inObj, 'Line')
                obj.acl = inObj;
                %- Voltage (max V is voltageNoLoad)
                vMax = inObj.voltageNoLoad;
            else
                vMax = max(inObj.voltageArray);
            end
            
            obj.yV = inObj.voltageArray;
            
            if vMax < 1e3
                obj.unitsV = '[V]';
            else
                obj.yV = obj.yV / 1e3;
                obj.unitsV ='[kV]';
            end
            obj.limV = getLimits(obj, obj.yV);
            
            %- Current
            obj.yI = inObj.currentArray;
            if max(obj.yI) < 1e3
                obj.unitsI = '[A]';
            else
                obj.yI = obj.yI / 1e3;
                obj.unitsI ='[kA]';
            end
            obj.limI = getLimits(obj, obj.yI);
        end
    end
    
    methods
        function plotProfile(obj)
            % 2 Axes plot Time
            % Axes 1 : Power and Voltage yyaxis
            % axes 2 : Current and Voltage yyaxis
            
            hf = figure('Name', obj.acl.name);
            set(hf, 'Units', 'normalized', 'Position', [.32 .09 .36 .75])
            set(hf, 'invertHardcopy', 'off')
            set(groot, 'defaultLineLineWidth', 1.4)
            
            %--- axes 1 : Power and Voltage yyaxis
            ax1 = subplot(2,1,1);
            set(ax1,'Position', get(ax1,'Position') .* [.85, 1, 1, 1])
            plotPowerCurrent(obj, ax1)
            
            ht1 = title({obj.acl.name,...
                sprintf('Substation no-load voltage : %d V',...
                obj.acl.voltageNoLoad),...
                sprintf('Substation resistance : %.0f m\x2126',...
                obj.acl.subR * 1e3),...
                sprintf('Line resistance per meter : %.0f n\x2126', ...
                obj.acl.lineRPM * 1e6)});
            
            % Rise legend up
            ax1.Legend.Position(2) = sum(ax1.Position([2,4])) * 1.005;
            
            % Axis 2 : Current and Voltage
            ax2 = subplot(2,1,2);
            set(ax2,'Position', get(ax2,'Position') .* [.85, .9, 1, 1])
            plotCurrentVoltage(obj, ax2)
            
            ht2 = title({
                sprintf('ACL length (each section) : %d m',...
                obj.acl.len),...
                sprintf('Clearance : %d m', obj.acl.clearance)});
            
            set([ht1, ht2], 'FontSize', 9.5,'HorizontalAlignment', 'left')
            
            % Rise legend up
            ax2.Legend.Position(2) = sum(ax2.Position([2,4])) * 1.01;
            
            set(groot, 'defaultLineLineWidth', 'default')
        end
    end
    
    methods (Access = protected)
        % Make these methods accessible to ResultsCap
        function plotPowerCurrent(obj, ax)
            % Plots yyaxis power left, current right
            % Followwing the analog : course, effect
            axes(ax)
            yyaxis left     % power
            plot(obj.xTm, obj.yPe)
            ylabel(['Power ', obj.unitsPe])
            % For constant power demand testing
            if obj.limPe(2) - obj.limPe(1) < 5
                obj.limPe(2) = obj.limPe(2) + 1;
                obj.limPe(1) = obj.limPe(1) - 1;
                yticks(round(obj.limPe(1) : obj.limPe(2)))
            end
            ylim(obj.limPe)
            
            yyaxis right
            plot(obj.xTm, obj.yV, 'LineWidth', 0.8); box off
            ylabel(['Voltage ', obj.unitsV])
            ylim(obj.limV)
            xlabel({['Time ', obj.unitsTm], 'a)'})
            xlim(obj.limTm)
            hlg = legend({'Power', 'Voltage'}, 'Location', 'northwest');
            % Rise legend up axes
            hlg.Position(2) = sum(ax.Position([2, 4]));
        end
        function plotCurrentVoltage(obj, ax)
            % Plots yyaxis current left, voltage right
            % Followwing the analog : course, effect
            axes(ax)
            yyaxis left
            plot(obj.xTm, obj.yI)
            ylabel(['Current  ', obj.unitsI])
            ylim(obj.limI)
            
            yyaxis right
            plot(obj.xTm, obj.yV, 'LineWidth', 0.8); box off
            ylabel(['Voltage  ', obj.unitsV])
            xlabel({['Time ', obj.unitsTm] , 'b)'})
            xlim(obj.limTm)
            
            hlg = legend({'Current', 'Voltage'}, 'Location', 'northwest');
            % Rise legend up axes
            hlg.Position(2) = sum(ax.Position([2, 4]));
        end
    end
end