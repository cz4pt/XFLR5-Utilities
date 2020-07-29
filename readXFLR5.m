function matObj = readXFLR5(xflr5file,mfile)
%READXFLR5 Read a polar from XLFR5, formatted as below.
% xflr5 v6.12
% 
%  Calculated polar for: AS5045 (15%)
% 
%  1 1 Reynolds number fixed          Mach number fixed         
% 
%  xtrf =   1.000 (top)        1.000 (bottom)
%  Mach =   0.000     Re =     2.500 e 6     Ncrit =   9.000
% 
%   alpha     CL        CD       CDp       Cm    Top Xtr Bot Xtr   Cpmin    Chinge    XCp    
%  ------- -------- --------- --------- -------- ------- ------- -------- --------- ---------
%   -4.000  -0.2313   0.00861   0.00307  -0.0438  0.6596  0.0081  -1.7721   0.0000   0.0512
%   ...

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
