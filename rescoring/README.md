Rescoring models
================

Several models for rescoring protein-ligand binding affinity are evaluated and compared in terms of prediction performance on the PDBbind v2007 core set (N = 195).


Model 1
-------

Model 1 is the Vina score, whose parameters are tuned by nonlinear optimization on PDBbind v2007 refined set (N = 1300). Its functional form is e = (w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding) / (1 + w6*Nrot), with w = [-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846] and cutoff = 8A. Vina identifies inactive torsions (i.e. -OH, -NH2, -CH3) and active torsions (i.e. other than the 3 types), and implements Nrot = N(ActTors) + 0.5*N(InactTors), i.e. active torsions are counted as 1 while inactive torsions are counted as 0.5.


Model 2
-------

Model 2 is a multiple linear regression model with the same functional form and cutoff as the Vina score. The denominator (1 + w6*Nrot) is moved to the left hand side, transforming the equation into z = e * (1 + w6*Nrot) = w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding. To find the optimal value of w6, 11 values are sampled from 0.01 to 0.03 with a step size of 0.002. The range [0.01, 0.03] is chosen because the optimal value of w6 always falls in it.

This model is separately trained on four training sets:

### PDBbind v2004 refined set (N = 1091) minus PDBbind v2007 core set (N = 195)

There are 138 complexes in common in both sets. The 1oko protein fails PDB-to-PDBQT conversion because of a ZeroDivisionError raised by prepare_receptor4.py. Therefore this training set has N = 1091 - 138 - 1 = 952 complexes. When w6 = 0.018, the model yields the best prediction performance with rmsd = 1.937, sdev = 1.942, pcor = 0.605, scor = 0.662 and kcor = 0.475.

### PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195)

This training set is the one used in the RF-Score paper. Therefore it has N = 1105. When w6 = 0.018, the model yields the best prediction performance with rmsd = 1.920, sdev = 1.925, pcor = 0.603, scor = 0.661 and kcor = 0.469.

### PDBbind v2010 refined set (N = 2061) minus PDBbind v2007 core set (N = 195)

There are 181 complexes in common in both sets. The 2bo4 protein fails PDB-to-PDBQT conversion because of a ZeroDivisionError raised by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 181 - 2 = 1878 complexes. When w6 = 0.012, the model yields the best prediction performance with rmsd = 1.983, sdev = 1.988, pcor = 0.577, scor = 0.649 and kcor = 0.461.

### PDBbind v2013 refined set (N = 2959) minus PDBbind v2007 core set (N = 195)

There are 165 complexes in common in both sets. Therefore this training set has N = 2959 - 165 = 2794 complexes. When w6 = 0.014, the model yields the best prediction performance with rmsd = 1.960, sdev = 1.965, pcor = 0.586, scor = 0.653 and kcor = 0.465.


Model 3
-------

Model 3 is a random forest of 500 trees using 6 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic, hydrogenbonding and Nrot. It is separately trained on the same four training sets as in model 2 and each with 10 different seeds, i.e. 89757,35577,51105,72551,10642,69834,47945,52857,26894,99789. For a given seed, 6 random forests are trained with mtry = 1 to 6, and the one with the minimum RMSE(OOB) is chosen.

The prediction performance on the PDBbind v2007 core set (N = 195) are in four files: pdbbind2004-core-statistics.csv, pdbbind2007-core-statistics.csv, pdbbind2010-core-statistics.csv and pdbbind2013-core-statistics.csv.


Model 4
-------

Model 4 is the same as model 3, except that it uses 36 RF-Score features and 6 Vina features. For a given seed, 15 random forests are trained with mtry = 1 to 15, and the one with the minimum RMSE(OOB) is chosen.


Model 5
-------

Model 5 is the same as model 3, except that it uses 5 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic and hydrogenbonding. For a given seed, 5 random forests are trained with mtry = 1 to 5, and the one with the minimum RMSE(OOB) is chosen.