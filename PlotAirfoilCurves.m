function PlotAirfoilCurves(Re,M)
%PLOTAIRFOILCURVES Compares the Cl-alpha, Cl-Cd, Cm-alpha, and Cm-cl curves
% for one or more airfoils, however many share the input Reynolds and Mach
% numbers.
%   Re = Reynolds number
%   M  = Mach number (M0.123, expects 3 decimals)
%
% This software makes use of airfoil data calculated by Xfoil within XFLR5
% (version 6.11 used for developing this function).
% http://www.xflr5.tech/xflr5.htm
%
% Use XFLR5 to create the airfoil polar data files as follows.
%   1. In XFLR5 open an airfoil DAT file (File > Open)
%   2. Define the analysis to run (Analysis > Define an Analysis: choose
%      Type 1, then set Reynolds, Mach, and NCrit). Before closing the 
%      window edit the Analysis Name as follows:
%      <AirfoilName>_Re1.234_M0.123_N11.0, for example:
%      N23012_Re2.000_M0.075_N11.0 (change name and add a decimal to Mach).
%   3. Define a sequence of angles of attack (a) and click Analyze in 
%      the Direct Foil Analysis window.
%   4. Save the results (Polar > Current Polar > Export), accepting the 
%      default name for the file (which should equalt the analysis
%      name.TXT) and putting it in the directory "Airfoil-Data" under the
%      directory where this script is run.
%
% Last modified on July 5,2020, by Matt Overholt.

% Load the MAT files present for the given Reynolds number
cd 'Airfoil-Data';
restr = sprintf('*Re%.3f_M%.3f_N*.txt',Re,M);
files = dir(restr);  % These are the raw text files from XFLR5
nfiles = length(files);

for i = 1:nfiles
   readXFLR5(files(i).name,'tmp.mat');
   A(i) = load('tmp.mat');
end

% Create a 2 x 2 matrix of subplots
figstr = sprintf('Reynolds Number = %.1f, Mach Number = %.3f',Re,M);
figure('Name',figstr);

% Cl-alpha
subplot(2,2,1);
for i = 1:nfiles
    plot(A(i).alpha,A(i).CL,'LineWidth',1)
    hold on;
end
hold off;
title('Cl versus Alpha');
xlabel('alpha (deg)')
ylabel('Cl')
grid on

% Cl-Cd
subplot(2,2,2);
for i = 1:nfiles
    plot(A(i).CD,A(i).CL,'LineWidth',1)
    hold on;
end
hold off;
title('Cl versus Cd');
xlabel('Cd')
ylabel('Cl')
axis([0 0.02 -0.5 1.5]);
grid on
grid minor

% Cm-alpha
subplot(2,2,3);
for i = 1:nfiles
    plot(A(i).alpha,A(i).Cm,'LineWidth',1)
    hold on;
end
hold off;
title('Cm versus Alpha');
xlabel('alpha (deg)')
ylabel('Cm')
grid on

% Cm-Cl
subplot(2,2,4);
for i = 1:nfiles
    plot(A(i).CL,A(i).Cm,'LineWidth',1)
    hold on;
end
hold off;
title('Cm versus Cl');
xlabel('Cl')
ylabel('Cm')
grid on

% Add the legend
ledcell = cell(1,nfiles);
for i = 1:nfiles
    ledcell(1,i) = { files(i).name };
end
legend( ledcell );

% Change back to the originating directory
cd ..


% ------------------------------------------------------------------------
    function matObj = readXFLR5(xflr5file,mfile)
        % Read a polar from XLFR5, formatted as below.
        % xflr5 v6.12
        %
        %  Calculated polar for: NACA 23012
        %
        %  1 1 Reynolds number fixed          Mach number fixed
        %
        %  xtrf =   1.000 (top)        1.000 (bottom)
        %  Mach =   0.000     Re =     2.500 e 6     Ncrit =   9.000
        %
        %   alpha     CL        CD       CDp       Cm    Top Xtr Bot Xtr   Cpmin    Chinge    XCp
        %  ------- -------- --------- --------- -------- ------- ------- -------- --------- ---------
        %   -4.000  -0.2313   0.00861   0.00307  -0.0438  0.6596  0.0081  -1.7721   0.0000   0.0512
        
        % Open file
        fid = fopen(xflr5file);
        
        % Read it
        data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f','HeaderLines',11);
        
        % Open a matfile to store the data in
        matObj = matfile(mfile,'Writable',true);
        
        matObj.alpha = data{1};
        matObj.CL = data{2};
        matObj.CD = data{3};
        matObj.CDp = data{4};
        matObj.Cm = data{5};
        matObj.XCp = data{10};
        
        fclose(fid);
        
    end

end
