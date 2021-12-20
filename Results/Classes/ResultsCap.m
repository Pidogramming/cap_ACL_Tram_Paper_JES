classdef ResultsCap < ResultsLine
    % ResultsLine has P, I, and V
    % ResultsCap needs P, I, V, and SoE
    properties
        cap
        
        ySoE
        limSoE
    end
    
    methods
        function obj = ResultsCap(cap)
            if not(isobject(cap))
                error('@Results : cap needs to be an Object')
            end
            obj@ResultsLine(cap);
            obj.cap = cap;
            obj.ySoE = cap.soeArray * 100;
            obj.limSoE = getLimits(obj, obj.ySoE);
        end
    end
    
    methods
        function plotChargeDisCharge(obj)
            % 2 Axes plot
            % Axes 1 : Power & Current yy axis 
            %  follow analog (course [left], effect [right])
            % Axes 2 : SOE and Voltage (yy axis)
            
            set(groot, 'defaultLineLineWidth', 1.2)
            
            hf = figure('Name', obj.cap.name);
            set(hf, 'invertHardcopy', 'off')
            set(hf, 'Units', 'normalized', 'Position', [.3 .09 .35 .75])
            
            %--- axes 1 : Power & Current (yy axis)
            ax1 = subplot(2,1,1);
            ax1.Position(1) = ax1.Position(1) * 0.85;
            plotPowerCurrent(obj, ax1)
            
            eFC = obj.cap.energyFullCharge;
            if eFC >= 1000
                eFC = eFC / 1000;
                unitsEFC = '[kWh]';
            else
                unitsEFC = '[Wh]';
            end
            ht1 = title({obj.cap.name,...
                obj.cap.simRemarks,...
                sprintf('Energy full charge %s : %.1f', unitsEFC, eFC)});

            
            % Rise legend up
            ax1.Legend.Location = 'northeast';
            ax1.Legend.Position(2) = sum(ax1.Position([2,4])) * 1.01;
            
            
            % Axes 2 : SOE and Voltage (yy axis)
            ax2 = subplot(2,1,2);
            ax2.Position = ax2.Position .* [0.85 , 0.9, 1, 1];
            
            yyaxis left
            plot(obj.xTm, obj.ySoE)
            ylabel('Percentage SoE')
            
            yyaxis right
            plot(obj.xTm, obj.yV, 'LineWidth', 0.8); box off
            ylabel(['Voltage ', obj.unitsV])
            xlabel({['Time ', obj.unitsTm], 'b)'})
            xlim(obj.limTm)
                       
            ht2 = title({sprintf('Voltage full charge [V] : %.0f',...
                obj.cap.voltageFullCharge), ...
                sprintf('Lowest SoE :  %.1f %%  |  Time %.1f  %s', ...
                min(obj.ySoE), max(obj.xTm), obj.unitsTm)});
            
            set([ht1, ht2], 'FontSize', 9.5,...
                'HorizontalAlignment', 'right','Interpreter', 'none')
            
            hlg = legend({'SoE', 'Voltage'});
            % Rise legend up
            hlg.Position(2) = sum(ax2.Position([2,4])) * 1.02;
            
            set(groot, 'defaultLineLineWidth', 'default')
        end
    end
end