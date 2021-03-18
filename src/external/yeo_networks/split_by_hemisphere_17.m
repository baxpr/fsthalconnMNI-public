% Separate Yeo17 networks by hemisphere

V = spm_vol('Yeo2011_17Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz');
[Y,XYZ] = spm_read_vols(V);
Y(XYZ(1,:)==0) = 0;
labeled = (Y(:)>0)';
left = XYZ(1,:)<0;
right = XYZ(1,:)>0;
Y(labeled&left) = Y(labeled&left) + 100;
Y(labeled&right) = Y(labeled&right) + 200;

Vout = V;
Vout.pinfo(1:2) = [1 0]';
Vout.fname = 'Yeo17_split.nii';
spm_write_vol(Vout,Y);
