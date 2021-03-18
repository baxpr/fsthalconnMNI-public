% Separate Yeo7 networks by hemisphere:
%
%                        Left     Right
%              Visual     101       201
%         Somatomotor     102       202
%    Dorsal Attention     103       203
%   Ventral Attention     104       204
%              Limbic     105       205
%     Fronto-parietal     106       206
%        Default mode     107       207

V = spm_vol('Yeo2011_7Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii.gz');
[Y,XYZ] = spm_read_vols(V);
Y(XYZ(1,:)==0) = 0;
labeled = (Y(:)>0)';
left = XYZ(1,:)<0;
right = XYZ(1,:)>0;
Y(labeled&left) = Y(labeled&left) + 100;
Y(labeled&right) = Y(labeled&right) + 200;

Vout = V;
Vout.pinfo(1:2) = [1 0]';
Vout.fname = 'Yeo7_split.nii';
spm_write_vol(Vout,Y);
