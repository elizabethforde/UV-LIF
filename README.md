# UV-LIF
These are the accompanying analysis scripts to the paper 'Intercomparison of multiple UV-LIF spectrometers using the Aerosol Challenge Simulator' by Forde et al. which enables analysis of multiple UV-LIF spectrometer laboratory data. 
These scripts use the data pre-processing protocol as shown in the paper supplement (section 2) and allow for the production a simple boxplot showing the fluorescence detection response for both the WIBS and MBS.
These scripts have been produced using MATLAB R2015a.

## OUTLINE OF SCRIPTS
There are two scripts per instrument -

(1) An import data script (e.g. importWIBS4M.m)
This is the function used to import data for analysis,there is one import data script per UV-LIF instrument.

(2) An analysis script (e.g. WIBS4analysis.m)
This is the script used to analyse the UV-LIF data, there are three analysis scripts in total.

## STEPS FOR USAGE:

(1) Within the analysis script import data and set the path for wherever the FT and acquisition data is stored (using e.g. importStuffWIBS4M.m file) 

(2) Assign number of standard deviations required within the analysis scripts (e.g. WIBS4analysis.m file)
