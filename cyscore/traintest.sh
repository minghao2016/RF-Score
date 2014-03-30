#!/usr/bin/env bash
ntsts=$(echo 195 201 382)
ntrns=$(echo 247 1105 2280)
echo x,model,ntrn,ntst,rmse,sdev,pcor,scor,kcor
for x in 2 4; do
	cd x$x
	cd mlr
	for ntrn in $ntrns; do
		./mlrtrain.R $ntrn
		for ntst in $ntsts; do
			./mlrtest.R $ntrn $ntst
			echo $x,MLR,$ntrn,$(tail -1 trn-$ntrn-tst-$ntst-stat.csv)
		done
	done
	cd ..
	cd rf
	for ntrn in $ntrns; do
		rf-train ../trn-$ntrn-yxi.csv trn-$ntrn.rf > trn-$ntrn.txt
		for ntst in $ntsts; do
			rf-test trn-$ntrn.rf ../tst-$ntst-yxi.csv > trn-$ntrn-tst-$ntst-iyp.csv
			tail -n +2 trn-$ntrn-tst-$ntst-iyp.csv | cut -d, -f2,3 | rf-stat > trn-$ntrn-tst-$ntst-stat.csv
			echo $x,RF,$ntrn,$(tail -1 trn-$ntrn-tst-$ntst-stat.csv)
		done
	done
	cd ..
	cd ..
done