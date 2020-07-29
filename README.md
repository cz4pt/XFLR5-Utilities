# XFLR5-Utilities
MATLAB utilities for viewing and using Xfoil results generated in XFLR5.


InterfaceToXFLR5.mlapp is an app created in MATLAB R2019a which duplicates
   the functions of the routines described below.


CLPOINT Calculates the lift coefficient, Mach number and Reynolds number
for a certain design point.
   H = std altitude, Hunits = 'ft' or 'm'
   V = airspeed, Vunits = 'mph' or 'kts' or 'm/s'
   M = mass, Munits = 'lbm' or 'kg' (1 g is assumed)
   A = reference (wing) area, Aunits = 'ft^2' or 'm^2'
   B = wing span, Bunits = 'ft' or 'm'


READXFLR5 Read a polar from XLFR5, formatted as below.
 xflr5 v6.12
 
  Calculated polar for: AS5045 (15%)
 
  1 1 Reynolds number fixed          Mach number fixed         
 
  xtrf =   1.000 (top)        1.000 (bottom)
  Mach =   0.000     Re =     2.500 e 6     Ncrit =   9.000
 
   alpha     CL        CD       CDp       Cm    Top Xtr Bot Xtr   Cpmin    Chinge    XCp    
  ------- -------- --------- --------- -------- ------- ------- -------- --------- ---------
   -4.000  -0.2313   0.00861   0.00307  -0.0438  0.6596  0.0081  -1.7721   0.0000   0.0512
   ...


PLOTAIRFOILS plots one or more airfoil shapes ((X,Y) .DAT files)
   Input the file names in full. Airfoil files can be obtained from the
   UIUC library:
   https://m-selig.ae.illinois.edu/ads/coord_database.html
   The first lines are skipped; the file names are used for the legend.


PLOTAIRFOILCURVES compares the Cl-alpha, Cl-Cd, Cm-alpha, and Cm-cl curves
 for one or more airfoils, however many share the input Reynolds and Mach
 numbers.
   Re = Reynolds number
   M  = Mach number (M0.123, expects 3 decimals)

 This software makes use of airfoil data calculated by Xfoil within XFLR5
 (version 6.11 used for developing this function).
 http://www.xflr5.tech/xflr5.htm

 Use XFLR5 to create the airfoil polar data files as follows.
   1. In XFLR5 open an airfoil DAT file (File > Open)
   2. Define the analysis to run (Analysis > Define an Analysis: choose
      Type 1, then set Reynolds, Mach, and NCrit). Before closing the 
      window edit the Analysis Name as follows:
      <AirfoilName>_Re1.234_M0.123_N11.0, for example:
      N23012_Re2.000_M0.075_N11.0 (change name and add a decimal to Mach).
   3. Define a sequence of angles of attack (a) and click Analyze in 
      the Direct Foil Analysis window.
   4. Save the results (Polar > Current Polar > Export), accepting the 
      default name for the file (which should equal the analysis
      name.TXT) and putting it in the directory "Airfoil-Data" under the
      directory where this script is run.


INTERPALPHA1D Interpolates for Cl, Cd and Cm in the XFLR5 polar text file.
  alpha = Angle of attack (degrees)
  filename = XFLR5 Type 1 polar export text file


INTERPCL1D Interpolates for Cd and Cm given Cl in the XFLR5 polar text file.
 If returned values are -100 then the results are invalid.
  Cl = Coefficient of lift to interpolate at
  filename = XFLR5 Type 1 polar export text file


INTERPALPHARE Interpolates for Cl, Cd and Cm at the given alpha and Re
 using the given XFLR5 polar text files.
   varargin{1} = alpha (degrees)
   varargin{2} = Re (millions)
   varargin{3} = XFLR5 polar text file 1
   varargin{4} = XFLR5 polar text file 2
   ... (additional files optional)

 Text files should use the standard Type 1 naming scheme, and be listed in
 order of increasing Re. Every file should use the same alpha values.

 Example usage:
 [Cl,Cd,Cm] = InterpAlphaRe(8,1.75,"N23012_Re1.500_M0.075_N11.0.txt", ...
                 "N23012_Re2.000_M0.075_N11.0.txt")


INTERPCLRE Interpolates for Cd and Cm at the given Cl and Re
 using the given XFLR5 polar text files.
   varargin{1} = Cl
   varargin{2} = Re (millions)
   varargin{3} = XFLR5 polar text file 1
   varargin{4} = XFLR5 polar text file 2
   ... (additional files optional)

 Text files should use the standard Type 1 naming scheme, and be listed in
 order of increasing Re. Every file should use the same alpha values.

 Example usage:
 [Cd,Cm] = InterpClRe(0.5,1.75,"N23012_Re1.500_M0.075_N11.0.txt", ...
                 "N23012_Re2.000_M0.075_N11.0.txt")


Last modified on July 29, 2020, by Matt Overholt.
