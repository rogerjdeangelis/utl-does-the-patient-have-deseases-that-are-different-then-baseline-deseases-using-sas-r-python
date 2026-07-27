/* Solution 1 from utl-does-the-patient-have-deseases...sas               */
/* PROC SQL reflexive left join: join each row to its own visit=1         */
/* baseline row, classify pattern via a CASE expression.                  */

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

proc sql;
  create
    table want as
  select
    l.id
   ,r.visit as baseline
   ,l.visit as visit
   ,l.pattern as baseline_pattern
   ,r.pattern
   ,l.request
   ,case
      when (l.visit=1          ) then 'ref '
      when (l.pattern=r.pattern) then 'same'
      else 'dif'
    end as want
  from
    have as l left join have as r
  on
          l.id    = r.id
  where
         r.visit =  1
;quit;

proc print data=want;
run;quit;
