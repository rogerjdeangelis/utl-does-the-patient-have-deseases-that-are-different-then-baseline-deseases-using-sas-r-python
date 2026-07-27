/* Solution 4 from utl-does-the-patient-have-deseases...sas               */
/* DATA step BY-group processing: retain the first.id (baseline) pattern, */
/* then flag every later visit ref/same/diff against it.                  */

Data start;
informat ID $1. VISIT 8. symptom_pattern $5. want_original $4.;
Input ID VISIT symptom_pattern want_original;
cards;

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
run;


Data Want;
set start;
by id;
retain test_pattern;
if first.id then do;
     test_pattern = symptom_pattern;
     New_match = 'ref  ';
return;
end;
if test_pattern = symptom_pattern then New_Match = 'same';
else new_match = 'diff';;
run;
proc print;
run;
