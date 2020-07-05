# XFLR5-Utilities
MATLAB utilities for viewing and using Xfoil results generated in XFLR5.


PLOTAIRFOILS plots one or more airfoil shapes ((X,Y) .DAT files)
   Input the file names in full. Airfoil files can be obtained from the
   UIUC library:
   https://m-selig.ae.illinois.edu/ads/coord_database.html
   The first lines are skipped; the file names are used for the legend.


PLOTAIRFOILCURVES Compares the Cl-alpha, Cl-Cd, Cm-alpha, and Cm-cl curves
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
      default name for the file (which should equalt the analysis
      name.TXT) and putting it in the directory "Airfoil-Data" under the
      directory where this script is run.

Last modified on July 5, 2020, by Matt Overholt
