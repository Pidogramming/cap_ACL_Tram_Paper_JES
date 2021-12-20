clc; close all
% Basic Test Route 
name = 'hypo_Pido_Japan';
profileData = load('Profile.txt');
horizontalDistanceData = profileData( :, 1); % First Column
altitudeData = profileData( :, 2); % Second Column

stationPositions = load('Station_positions_hoz.txt');
stationNames = ["S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9"];

description = sprintf(" %s\n %s\n %s", 'Testing Testing Testing',...
    'Modification 1 : Altitudes altered (reduced)',...
    'Modification 2 : Mirrored, so that no need for round trip');

routeData = struct('name', name,...
    'hozDistance', horizontalDistanceData,...
    'altitude', altitudeData,...
    'stnNames', stationNames,...
    'stnPositions', stationPositions,...
    'description', description);

route = Route(routeData);
route.plotRoute()
route.tableSectionDistances
route.getGradient(1400)