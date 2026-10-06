ImageJ/Fiji macro for automated bacterial burden quantification in fluorescence microscopy images. The macro processes all TIFF images in a user specified directory. For each image, the user manually defines the region of interest to exclude areas with autofluorescence, such as the eye or yolk sac. A user defined intensity threshold is then applied to identify bacterial fluorescence signal. Detected particles are analyzed for intensity and morphological parameters, including area, mean intensity, integrated intensity and shape descriptors. Individual particle measurements and image level summaries are automatically exported as CSV files.
Things to do before applying: 
1) Imply path to repository (X)
2) Create and display path to folder for results (Y) and summary (Z)
3) Find suitable threshold for your analysis (a-> lower threshold; b upper threshold)
4) Let's go
