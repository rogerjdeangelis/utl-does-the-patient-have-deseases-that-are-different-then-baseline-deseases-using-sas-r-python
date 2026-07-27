/* Solution 0 from utl-does-the-patient-have-deseases...sas               */
/* DATA step self-merge: rename visit=1 pattern to _ref_pattern,          */
/* then flag each visit ref/same/diff against baseline with ifc().        */

data have;
  informat id $1. pattern request $5.;
  input ID VISIT pattern request;
cards4;
1 1 10000 ref
1 2 00000 diff
1 3 00000 diff
1 4 10000 same
1 5 00000 diff
2 1 10000 ref
2 2 00010 diff
2 3 10000 same
3 1 00010 ref
3 2 00000 diff
3 3 00010 same
3 4 10000 diff
3 5 10001 diff
;;;;
run;quit;

data want (drop=_:);

  merge have (where=(visit=1) rename=(pattern=_ref_pattern))
        have ;
  by id;

  if visit=1 then want="ref ";
  else want=ifc(pattern=_ref_pattern,"same","diff");

run;

proc print data=want;
run;quit;
