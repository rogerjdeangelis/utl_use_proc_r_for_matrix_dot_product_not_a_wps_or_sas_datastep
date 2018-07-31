Use proc r for matrix dot product not a wps or sas datastep

WPS/Proc R solution

Use Microsoft R with very fast mathpack?

I made minor changes in the inpurt(very easy to program), but I have the essence of the problem.
I do get the ops result.

INPUT
=====

* I changed the values > 0 to 1;
SD1.HAV1ST total obs=2

   A1    A2    A3    A4

    0     1     0     1
    0     1     1     1

* I changed the main diagonal to 0;

SD1.HAV2ND total obs=4

  A1      A2      A3      A4

 0.00    0.00    0.41    0.33
 0.00    0.00    0.50    0.82
 0.41    0.50    0.00    0.41
 0.33    0.82    0.41    0.00


EXAMPLE OUTPUT
--------------

WANTWPS total obs=2

   V1      V2      V3      V4

  0.33**  0.82    0.91    0.82
  0.74##  1.32    0.91    1.23

RULES
----

Smm of row in hav1st to column in hav2nd

        HAV1ST          HAV2ND
A1    A2    A3    A4     A1

 0     1     0     1     0.00
                         0.00
                         0.41
                         0.33   = 0*0 + 1*0 +0*.41 + 1*.33 = .33**

       HAV1ST_         HAV2ND
A1    A2    A3    A4    A1

 0     1     1     1    0.00
                        0.00
                        0.41
                        0.33   = 0*0 + 1*0 +1*.41 + 1*.33 = .74##

PROCESS  (working code)
=======

    want<-hav1st %*% hav2nd


OUTPUT
======

  WORK.WANTWPS total obs=2

     V1      V2      V3      V4

    0.33    0.82    0.91    0.82
    0.74    1.32    0.91    1.23

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.hav1st;
 input a1 a2 a3 a4;
cards4;
0 1 0 1
0 1 1 1
;;;;
run;quit;

* I changed the main diagonal to 0;
data sd1.hav2nd;
 input a1 a2 a3 a4;
cards4;
0     0      0.41 0.33
0     0      0.5  0.82
0.41  0.5      0  0.41
0.33  0.82  0.41    0
;;;;
run;quit;

Data Want;
 input a1 a2 a3 a4;
cards4;
0.33 0.82 0.91 0.82
0.74 1.32 0.91 1.23
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
library(dplyr);
hav1st<-as.matrix(read_sas("d:/sd1/hav1st.sas7bdat"));
hav2nd<-as.matrix(read_sas("d:/sd1/hav2nd.sas7bdat"));
want<-hav1st %nrstr(%%)*% hav2nd;
endsubmit;
import r=want data=wrk.wantwps;
run;quit;
');

