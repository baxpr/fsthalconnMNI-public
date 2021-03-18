# fsthalconnMNI-public

**NOTE: For this public version of the repository, the ROI images are not included due to the restrictions on the Morel set, meaning the code will not actually run.**

Inputs:

- Preprocessed fMRI data from https://github.com/baxpr/connprep
- Thalamus regions of interest from https://github.com/baxpr/freesurfer-singularity

Included ROIs:

- "Morel" thalamic sub-regions from Krauth A, Blanc R, Poveda A, Jeanmonod D, Morel A, Székely G. A mean three-dimensional atlas of the human thalamus: generation from multiple histological data. Neuroimage. 2010;49(3):2053–2062. doi:10.1016/j.neuroimage.2009.10.042. These images are copyright University of Zurich and ETH Zurich, Axel Krauth, Rémi Blanc, Alejandra Poveda, Daniel Jeanmonod, Anne Morel, Gábor Székely. They may not be redistributed, or used for other than research purposes in academic institutions (see src/rois/ACDMY/Agreement.pdf).

- "ABIDE" regions from Woodward ND, Giraldo-Chica M, Rogers B, Cascio CJ. Thalamocortical dysconnectivity in autism spectrum disorder: An analysis of the Autism Brain Imaging Data Exchange. Biol Psychiatry Cogn Neurosci Neuroimaging. 2017;2(1):76–84. doi:10.1016/j.bpsc.2016.09.002

- Network maps from Yeo et al 2011 (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3174820/)

Outputs:

- Seed connectivity maps and matrices for all ROIs/networks specified in the roiinfo_csv file


Process:

1. ROI resampling. Freesurfer ROIs (all .mgz in the roiinfo_csv file) are already in native space aligned with the subject T1 and fMRI, so are only converted to nifti format. MNI space ROIs (all .nii.gz in roiinfo_csv are assumed to be MNI space) are warped back to native space in the T1 geometry using the supplied warp invdef_niigz.
2. For each native space ROI image, the native space fMRIs (removegm_niigz and keepgm_niigz) are resampled to the ROI image geometry, and mean ROI signals are extracted.
3. Connectivity matrices are computed for the mean ROI signals for both the removegm and keepgm data.
4. The mean ROI signals are used with the four filtered fMRI image sets (removegm_niigz, keepgm_niigz, wremovegm_niigz, wkeepgm_niigz) to compute connectivity maps for each of the four.
5. The connectivity maps are smoothed by the provided fwhm.
