function [Cl,Cd,Cm] = InterpAlphaRe(varargin)
%INTERPALPHARE Interpolates for Cl, Cd and Cm at the given alpha and Re
% using the given XFLR5 polar text files.
%   varargin{1} = alpha (degrees)
%   varargin{2} = Re (millions)
%   varargin{3} = XFLR5 polar text file 1
%   varargin{4} = XFLR5 polar text file 2
%   ... (additional files optional)
%
% Text files should use the standard Type 1 naming scheme, and be listed in
% order of increasing Re. Every file should use the same alpha values.
%
% Example usage:
% [Cl,Cd,Cm] = InterpAlphaRe(8,1.75,"N23012_Re1.500_M0.075_N11.0.txt", ...
%                 "N23012_Re2.000_M0.075_N11.0.txt")

% Check that the number of arguments is sufficient
if nargin < 4
    fprintf(1,"Not enough input arguments. At least 4 are required.\n");
    Cl = 0;
    Cd = 0;
    Cm = 0;
    return
end

alpha = varargin{1};
Re = varargin{2};
nfiles = nargin - 2;

% Read the file data
yre = zeros(1,nfiles);  % Re values for the y-grid vector
for i = 1:nfiles
    readXFLR5(varargin{i+2},'tmp.mat');
    mat(i) = load('tmp.mat');
    ch = convertStringsToChars(varargin{i+2});
    j = strfind(varargin{i+2},'Re');
    yre(i) = sscanf(ch(j+2:j+10),'%f');
end

% ASSUME that the alpha values are the same in every file!
% Form the x-grid vector for the interpolation
xalpha = mat(1).alpha;
nalpha = length(xalpha);

% Create data matrices for interpolation
CLmatrix = zeros(nalpha,nfiles);
CDmatrix = zeros(nalpha,nfiles);
Cmmatrix = zeros(nalpha,nfiles);

for j = 1:nfiles
    for i = 1:nalpha
        CLmatrix(i,j) = mat(j).CL(i);
        CDmatrix(i,j) = mat(j).CD(i);
        Cmmatrix(i,j) = mat(j).Cm(i);
    end
end

Fcl = griddedInterpolant({xalpha,yre},CLmatrix);
Cl = Fcl(alpha,Re);

Fcd = griddedInterpolant({xalpha,yre},CDmatrix);
Cd = Fcd(alpha,Re);

Fcm = griddedInterpolant({xalpha,yre},Cmmatrix);
Cm = Fcm(alpha,Re);

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
