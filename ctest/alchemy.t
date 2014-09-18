Set up directories
  $ CURDIR=$TESTDIR
  $ REMOTEDIR=/mnt/secondary-siv/testdata/BlasrTestData/ctest
  $ DATDIR=$REMOTEDIR/data
  $ OUTDIR=$CURDIR/out
  $ STDDIR=$REMOTEDIR/stdout

Set up the executable: alchemy.
  $ EXEC=$TESTDIR/../alchemy

test_alchemy.cmp.h5 was generated by 
pbalign.py $DATDIR/test_alchemy_read.fa $DATDIR/test_alchemy_ref.fa test_alchemy.cmp.h5

$ ./cmpH5StoreQualityByContext $DATDIR/test_alchemy.cmp.h5 $OUTDIR/test_alchemy.qbc -contextLength 3

  $ $EXEC $DATDIR/ecoli_out.qbc -genome $DATDIR/ecoli_reference.fasta  -numBasesPerFile 100000 -baseFileName 'this_bas_file' -movieName $OUTDIR/alchemy_
  $ echo $?
  0

pls2fasta can be successfully applied to the simulated bas.h5 file.
$ pls2fasta *.bas.h5 $OUTDIR/test_alchemy_pls2fasta.fa
[INFO] * [pls2fasta] started. (glob)
[INFO] * [pls2fasta] ended. (glob)

