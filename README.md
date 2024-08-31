    %let pgm=utl-does-the-patient-have-deseases-that-are-different-then-baseline-deseases-using-sas-r-python;

    Does the patient have deseases that are different from baseline using sas r python

    github
    https://tinyurl.com/2xyakpxe
    https://github.com/rogerjdeangelis/utl-does-the-patient-have-deseases-that-are-different-then-baseline-deseases-using-sas-r-python

    we need to know if the patient has the same or different diseases then baseline

    Visit 1 is baseline
    The variable pattern defines the disease each patient has at each visit

      SOLUTIONS

        0 sas datastep
          Mark Keintz <mkeintz@OUTLOOK.COM>
        1 sas sql
        2 r sql
        3 python sql
        4 sas datastep
          Nat Wooding <nathani@verizon.net>

    /*               _     _
     _ __  _ __ ___ | |__ | | ___ _ __ ___
    | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
    | |_) | | | (_) | |_) | |  __/ | | | | |
    | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
    |_|
    */

    /***************************************************************************************************************************/
    /*                             |                                              |                                            */
    /*                             |                                              |                                            */
    /*           INPUT             |     PROCESS                                  |                 OUTPUT                     */
    /*                             |                                              |                                            */
    /*  WORK.HAVE total obs=13     |                                              |                                            */
    /*                             |                                              |     BASE     BASELINE OBSERVED             */
    /*  We need to match request   | Left join baseline to                        |  ID LINE VIS  PATTERN PATTERN REQUEST WANT */
    /*                             | all observations then compare disease pattern|  ----------------------------------------- */
    /*   ID VISIT PATTERN  REQUEST |                                              |  1     1   1  10000   10000   ref     ref  */
    /*                             | Compare patterns of disease                  |  1     1   5  10000   00000   diff    dif  */
    /*   1    1    10000    ref    |                                              |  1     1   3  10000   00000   diff    dif  */
    /*   1    2    00000    diff   | proc sql;                                    |  1     1   4  10000   10000   same    same */
    /*   1    3    00000    diff   |   create                                     |  1     1   2  10000   00000   diff    dif  */
    /*   1    4    10000    same   |     table want as                            |                                            */
    /*   1    5    00000    diff   |   select                                     |  2     1   2  10000   00010   diff    dif  */
    /*                             |     l.id                                     |  2     1   1  10000   10000   ref     ref  */
    /*   2    1    10000    ref    |    ,r.visit as baseline                      |  2     1   3  10000   10000   same    same */
    /*   2    2    00010    diff   |    ,l.visit as visit                         |                                            */
    /*   2    3    10000    same   |    ,l.pattern as baseline_pattern            |  3     1   5  00010   10001   diff    dif  */
    /*                             |    ,r.pattern                                |  3     1   4  00010   10000   diff    dif  */
    /*   3    1    00010    ref    |    ,l.request                                |  3     1   3  00010   00010   same    same */
    /*   3    2    00000    diff   |    ,case                                     |  3     1   2  00010   00000   diff    dif  */
    /*   3    3    00010    same   |       when (l.visit=1          ) then 'ref ' |  3     1   1  00010   00010   ref     ref  */
    /*   3    4    10000    diff   |       when (l.pattern=r.pattern) then 'same' |                                            */
    /*   3    5    10001    diff   |       else 'dif'                             |                                            */
    /*                             |     end as want                              |                                            */
    /*                             |   from                                       |                                            */
    /*                             |     have as l left join have as r            |                                            */
    /*                             |   on                                         |                                            */
    /*                             |           l.id    = r.id                     |                                            */
    /*                             |   where                                      |                                            */
    /*                             |          r.visit =  1                        |                                            */
    /*                             | ;quit;                                       |                                            */
    /*                             |                                              |                                            */
    /***************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

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

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*  HAVE total obs=13                                                                                                     */
    /*                                                                                                                        */
    /*  Obs    ID    PATTERN    REQUEST    VISIT                                                                              */
    /*                                                                                                                        */
    /*    1    1      10000      ref         1                                                                                */
    /*    2    1      00000      diff        2                                                                                */
    /*    3    1      00000      diff        3                                                                                */
    /*    4    1      10000      same        4                                                                                */
    /*    5    1      00000      diff        5                                                                                */
    /*    6    2      10000      ref         1                                                                                */
    /*    7    2      00010      diff        2                                                                                */
    /*    8    2      10000      same        3                                                                                */
    /*    9    3      00010      ref         1                                                                                */
    /*   10    3      00000      diff        2                                                                                */
    /*   11    3      00010      same        3                                                                                */
    /*   12    3      10000      diff        4                                                                                */
    /*   13    3      10001      diff        5                                                                                */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*___        _       _            _
     / _ \    __| | __ _| |_ __ _ ___| |_ ___ _ __
    | | | |  / _` |/ _` | __/ _` / __| __/ _ \ `_ \
    | |_| | | (_| | (_| | || (_| \__ \ ||  __/ |_) |
     \___/   \__,_|\__,_|\__\__,_|___/\__\___| .__/
                                             |_|
    */

    data want (drop=_:);

      merge have (where=(visit=1) rename=(pattern=_ref_pattern))
            have ;
      by id;

      if visit=1 then want="ref ";
      else want=ifc(pattern=_ref_pattern,"same","diff");

    run;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*                               SOLUTION MATCHES REQUEST                                                                 */
    /*                                                                                                                        */
    /*   ID      VISIT    PATTERN    REQUEST    WANT                                                                          */
    /*                                                                                                                        */
    /*   1         1       10000      ref       ref                                                                           */
    /*   1         2       00000      diff      diff                                                                          */
    /*   1         3       00000      diff      diff                                                                          */
    /*   1         4       10000      same      same                                                                          */
    /*   1         5       00000      diff      diff                                                                          */
    /*   2         1       10000      ref       ref                                                                           */
    /*   2         2       00010      diff      diff                                                                          */
    /*   2         3       10000      same      same                                                                          */
    /*   3         1       00010      ref       ref                                                                           */
    /*   3         2       00000      diff      diff                                                                          */
    /*   3         3       00010      same      same                                                                          */
    /*   3         4       10000      diff      diff                                                                          */
    /*   3         5       10001      diff      diff                                                                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/


    /*                             _
    / |  ___  __ _ ___   ___  __ _| |
    | | / __|/ _` / __| / __|/ _` | |
    | | \__ \ (_| \__ \ \__ \ (_| | |
    |_| |___/\__,_|___/ |___/\__, |_|
                                |_|
    */

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

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*   WORK.WANT total obs=13                                                                                               */
    /*                                                                                                                        */
    /*                                     BASELINE_                                                                          */
    /*   Obs    ID    BASELINE    VISIT     PATTERN     PATTERN    REQUEST    WANT                                            */
    /*                                                                                                                        */
    /*     1    1         1         1        10000       10000      ref       ref                                             */
    /*     2    1         1         5        00000       10000      diff      dif                                             */
    /*     3    1         1         3        00000       10000      diff      dif                                             */
    /*     4    1         1         4        10000       10000      same      same                                            */
    /*     5    1         1         2        00000       10000      diff      dif                                             */
    /*     6    2         1         2        00010       10000      diff      dif                                             */
    /*     7    2         1         1        10000       10000      ref       ref                                             */
    /*     8    2         1         3        10000       10000      same      same                                            */
    /*     9    3         1         5        10001       00010      diff      dif                                             */
    /*    10    3         1         4        10000       00010      diff      dif                                             */
    /*    11    3         1         3        00010       00010      same      same                                            */
    /*    12    3         1         2        00000       00010      diff      dif                                             */
    /*    13    3         1         1        00010       00010      ref       ref                                             */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*___                     _
    |___ \   _ __   ___  __ _| |
      __) | | `__| / __|/ _` | |
     / __/  | |    \__ \ (_| | |
    |_____| |_|    |___/\__, |_|
                           |_|
    */

    options validvarname=upcase;
    libname sd1 "d:/sd1";
    data sd1.have;
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

    %utl_rbeginx;
    parmcards4;
    library(sqldf)
    library(haven)
    source("c:/oto/fn_tosas9x.R");
    have<-read_sas("d:/sd1/have.sas7bdat")
    want<-sqldf('
       select
         l.id
        ,r.visit as baseline
        ,l.visit as visit
        ,l.pattern as baseline_pattern
        ,r.pattern
        ,l.request
        ,case
           when (l.visit=1          ) then "ref "
           when (l.pattern=r.pattern) then "same"
           else "dif"
         end as want
       from
         have as l left join have as r
       on
               l.id    = r.id
       where
              r.visit =  1
      ')
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rwant"
         );
    ;;;;
    %utl_rendx;

    libname sd1 "d:/sd1";

    proc print data=sd1.rwant;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* R                                                                                                                      */
    /* ==                                                                                                                     */
    /*  > want                                                                                                                */
    /*     ID BASELINE VISIT BASELINE_PATTERN PATTERN REQUEST WANT                                                            */
    /*  1   1        1     2            00000   10000    diff  dif                                                            */
    /*  2   1        1     3            00000   10000    diff  dif                                                            */
    /*  3   1        1     5            00000   10000    diff  dif                                                            */
    /*  4   1        1     1            10000   10000     ref ref                                                             */
    /*  5   1        1     4            10000   10000    same same                                                            */
    /*  6   2        1     2            00010   10000    diff  dif                                                            */
    /*  7   2        1     1            10000   10000     ref ref                                                             */
    /*  8   2        1     3            10000   10000    same same                                                            */
    /*  9   3        1     2            00000   00010    diff  dif                                                            */
    /*  10  3        1     1            00010   00010     ref ref                                                             */
    /*  11  3        1     3            00010   00010    same same                                                            */
    /*  12  3        1     4            10000   00010    diff  dif                                                            */
    /*  13  3        1     5            10001   00010    diff  dif                                                            */
    /*                                                                                                                        */
    /* SAS                                                                                                                    */
    /* ===                                                                                                                    */
    /*                                         BASELINE_                                                                      */
    /*  ROWNAMES    ID    BASELINE    VISIT     PATTERN     PATTERN    REQUEST    WANT                                        */
    /*                                                                                                                        */
    /*      1       1         1         2        00000       10000      diff      dif                                         */
    /*      2       1         1         3        00000       10000      diff      dif                                         */
    /*      3       1         1         5        00000       10000      diff      dif                                         */
    /*      4       1         1         1        10000       10000      ref       ref                                         */
    /*      5       1         1         4        10000       10000      same      same                                        */
    /*      6       2         1         2        00010       10000      diff      dif                                         */
    /*      7       2         1         1        10000       10000      ref       ref                                         */
    /*      8       2         1         3        10000       10000      same      same                                        */
    /*      9       3         1         2        00000       00010      diff      dif                                         */
    /*     10       3         1         1        00010       00010      ref       ref                                         */
    /*     11       3         1         3        00010       00010      same      same                                        */
    /*     12       3         1         4        10000       00010      diff      dif                                         */
    /*     13       3         1         5        10001       00010      diff      dif                                         */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*____               _   _                             _
    |___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
      |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
     ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
    |____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
            |_|    |___/                                |_|
    */

    %utl_pybeginx;
    parmcards4;
    import pyperclip
    import os
    from os import path
    import sys
    import subprocess
    import time
    import pandas as pd
    import pyreadstat as ps
    import numpy as np
    import pandas as pd
    from pandasql import sqldf
    mysql = lambda q: sqldf(q, globals())
    from pandasql import PandaSQL
    pdsql = PandaSQL(persist=True)
    sqlite3conn = next(pdsql.conn.gen).connection.connection
    sqlite3conn.enable_load_extension(True)
    sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
    mysql = lambda q: sqldf(q, globals())
    have, meta = ps.read_sas7bdat("d:/sd1/have.sas7bdat")
    exec(open('c:/temp/fn_tosas9.py').read())
    want = pdsql("""
       select
         l.id
        ,r.visit as baseline
        ,l.visit as visit
        ,l.pattern as baseline_pattern
        ,r.pattern
        ,l.request
        ,case
           when (l.visit=1          ) then "ref "
           when (l.pattern=r.pattern) then "same"
           else "dif"
         end as want
       from
         have as l left join have as r
       on
               l.id    = r.id
       where
              r.visit =  1
    """)
    print(want)
    fn_tosas9(
       want
       ,dfstr="want"
       ,timeest=3
      )
    ;;;;
    %utl_pyendx;

    libname tmp "c:/temp";
    proc print data=tmp.want;
    run;quit;

    */ /**************************************************************************************************************************/
    */ /*
    */ /* PYTHON
    */ /*
    */ /*    ID  baseline  visit baseline_pattern PATTERN REQUEST  want
    */ /* 0   1       1.0    2.0            00000   10000    diff   dif
    */ /* 1   1       1.0    3.0            00000   10000    diff   dif
    */ /* 2   1       1.0    5.0            00000   10000    diff   dif
    */ /* 3   1       1.0    1.0            10000   10000     ref  ref
    */ /* 4   1       1.0    4.0            10000   10000    same  same
    */ /* 5   2       1.0    2.0            00010   10000    diff   dif
    */ /* 6   2       1.0    1.0            10000   10000     ref  ref
    */ /* 7   2       1.0    3.0            10000   10000    same  same
    */ /* 8   3       1.0    2.0            00000   00010    diff   dif
    */ /* 9   3       1.0    1.0            00010   00010     ref  ref
    */ /* 10  3       1.0    3.0            00010   00010    same  same
    */ /* 11  3       1.0    4.0            10000   00010    diff   dif
    */ /* 12  3       1.0    5.0            10001   00010    diff   dif
    */ /*
    */ /*
    */ /* SAS
    */ /*
    */ /*                                   BASELINE_
    */ /* Obs    ID    BASELINE    VISIT     PATTERN     PATTERN    REQUEST    WANT
    */ /*
    */ /*   1    1         1         2        00000       10000      diff      dif
    */ /*   2    1         1         3        00000       10000      diff      dif
    */ /*   3    1         1         5        00000       10000      diff      dif
    */ /*   4    1         1         1        10000       10000      ref       ref
    */ /*   5    1         1         4        10000       10000      same      same
    */ /*   6    2         1         2        00010       10000      diff      dif
    */ /*   7    2         1         1        10000       10000      ref       ref
    */ /*   8    2         1         3        10000       10000      same      same
    */ /*   9    3         1         2        00000       00010      diff      dif
    */ /*  10    3         1         1        00010       00010      ref       ref
    */ /*  11    3         1         3        00010       00010      same      same
    */ /*  12    3         1         4        10000       00010      diff      dif
    */ /*  13    3         1         5        10001       00010      diff      dif
    */ /*
    */ /**************************************************************************************************************************/

    /*  _                         _       _            _
    | || |    ___  __ _ ___    __| | __ _| |_ __ _ ___| |_ ___ _ __
    | || |_  / __|/ _` / __|  / _` |/ _` | __/ _` / __| __/ _ \ `_ \
    |__   _| \__ \ (_| \__ \ | (_| | (_| | || (_| \__ \ ||  __/ |_) |
       |_|   |___/\__,_|___/  \__,_|\__,_|\__\__,_|___/\__\___| .__/
                                                              |_|
    */

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

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*                                                                                                                        */
    /*                       SYMPTOM_     WANT_       TEST_     NEW_                                                          */
    /* Obs    ID    VISIT    PATTERN     ORIGINAL    PATTERN    MATCH                                                         */
    /*                                                                                                                        */
    /*   1    1       1       10000        ref        10000     ref                                                           */
    /*   2    1       2       00000        diff       10000     diff                                                          */
    /*   3    1       3       00000        diff       10000     diff                                                          */
    /*   4    1       4       10000        same       10000     same                                                          */
    /*   5    1       5       00000        diff       10000     diff                                                          */
    /*   6    2       1       10000        ref        10000     ref                                                           */
    /*   7    2       2       00010        diff       10000     diff                                                          */
    /*   8    2       3       10000        same       10000     same                                                          */
    /*   9    3       1       00010        ref        00010     ref                                                           */
    /*  10    3       2       00000        diff       00010     diff                                                          */
    /*  11    3       3       00010        same       00010     same                                                          */
    /*  12    3       4       10000        diff       00010     diff                                                          */
    /*  13    3       5       10001        diff       00010     diff                                                          */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
