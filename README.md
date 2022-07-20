# StreptavidinLatticeSubtraction
Matlab scripts as described in Dominguez-Martin, Sauer et al., Nature, 2022.

Computational subtraction of streptavidin lattice from motion corrected micrographs
Guide by Paul Sauer, UC Berkeley, psauer@berkeley.edu

The original author of the scripts and associated files is Bong-Gyoon Han at LBNL, together with Robert Glaeser, LBNL & UC Berkeley

Citation:
Han BG, Watson Z, Kang H, et al. Long shelf-life streptavidin support-films suitable for electron microscopy of biological macromolecules. J Struct Biol. 2016;195(2):238-244. doi:10.1016/j.jsb.2016.06.009

Intro:
The principle is the following: The script replaces Bragg diffraction spots in the Fourier transform of a micrograph with random pixels from a circular area around the peak.

The script requires matlab to run and consists of the script itself an associated dependencies. Depending on which detector has been used (and therefore if the image is square or rectangular) different scripts need to be used. Different versions have been tested for K2, K3, FalconIII and FalconIV cameras. 

List of scripts & compatible cameras

LAsub.m			original script (for square detectors)

M_by_rot_K3_4.m		K3

M_by_rot_2_1023.m	K2

M_falcon_1.m		FalconIII and FalconIV

The script requires a micrograph file in .mrc format that is named ‘input.mrc’ and produces a subtracted micrograph that is named ‘output.mrc’. The script does not loop through available micrographs by itself and the user will have to write their own bash or python script to accomplish that. An example of such a bash script is provided but should be adapted and double checked by the user.

This is how the directories should be set up with the supplied files:

Your_project_directory/

Your_project_directory/Process

Your_project_directory/Process/LAsub.m (the subtraction script; can be replaced by the appropriate script variants for the detector)

Your_project_directory/Process/PARAMETER (parameter file)

Your_project_directory/Process/input.mrc (supplied by the user)

Your_project_directory/Process/(output.mrc, will be produced by the script)

Your_project_directory/Process/(bash script that loops through available micrographs and keeps track of input and output. To be provided by the user)

Your_project_directory/Matlab

Your_project_directory/Matlab/bg_drill_hole.m

Your_project_directory/Matlab/bg_FastSubtract_standard.m

Your_project_directory/Matlab/bg_Pick_Amp_masked_standard.m

Your_project_directory/Matlab/bg_push_by_rot.m

Your_project_directory/Matlab/ReadMRC.m

Your_project_directory/Matlab/WriteMRC.m

Your_project_directory/Matlab/WriteMRCHeader.m

Once the structure is set up, a few files need to be modified so it runs right. 
1.	LAsub.m (or variants): In line 6, the path needs to point to the ‘Matlab’ directory created above
2.	Only in K2/K3 scripts: In lines 10 an 11 the values need to reflect the shape of the detector. If the detector is used in landscape mode, line 10 (‘X’) should be 200 and line 10 (‘Y’) should be 1000. If the detector is used in portrait mode, the values need to be swapped
3.	LAsub.m (or variants): In line 14 the pixelsize needs to be specified
4.	LAsub.m (or variants): In line 15 the threshold value for subtraction needs to be specified. This value has to be identical to the value specified in the PARAMETER file (see below). Standard values are between 1.4-1.6. We have used 1.42 for most of our datasets. 
5.	PARAMETER: In line 3 pixelsize needs to be specified
6.	PARAMETER: In line 5 threshold needs to be specified. Needs to be identical to the subtraction script (see above in point #4)

Once this is all set up, the script can be started. Copy an unsubtracted micrograph into the Process directory and rename it to ‘input.mrc’. Run the script

Matlab -nodisplay < LAsub.m

The file ‘output.mrc’ should contain the subtracted micrograph. 

If the provided bash script is used to loop through all micrographs (Lattice_sub_loop_short_Jan2020.sh; double check syntax), input and output directories will have to be specified, as well as the name of the actual subtraction script.
