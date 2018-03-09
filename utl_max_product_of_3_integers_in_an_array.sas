Max product of 3 integers in an array

  Same result in WPS and SAS

github
https://github.com/rogerjdeangelis/utl_max_product_of_3_integers_in_an_array

see
https://stackoverflow.com/questions/49084955/max-product-of-3-integers-in-an-array


INPUT
=====

 Layout all possible cases

  1, At  least four numbers
  2. 2**3 or 8 possible sign permutations

                                                    RULES
        CASE     X1    X2    X3    X4   |   MAXMUL
                                        |
       posall     1     2     3     4   |      24     2*3*4   = 24
       negone    -1     2     3     4   |      24     2*3*4   = 24
       negtwo    -2    -1     3     4   |       8    -1*-2*4  = 8
       negtre    -3    -2    -1     4   |      24    -3*-2*4  = 24
       negall    -4    -3    -2    -1   |      -6   -1*-2*-3  = -6
       posone    -4    -2    -1     3   |      24    -4*-2*3  = 24
       postwo    -2    -1     3     4   |       8    -2*-1*4  =  8
       postre    -1     2     3     4   |      24      2*3*4  = 24


PROCESS  (all the code)
=====================

  The key is to sort the array and test the cominations of first and last three elements.
  Array can be much larger

  data want;
    retain maxMul;
    set have;
    maxMul=max(x1*x2*x3,x2*x3*x4,x1*x2*x4);
  run;quit;


OUTPUT
======

 WORK.WANT total obs=8

     CASE     X1    X2    X3    X4   MAXMUL

    posall     1     2     3     4      24
    negone    -1     2     3     4      24
    negtwo    -2    -1     3     4       8
    negtre    -3    -2    -1     4      24
    negall    -4    -3    -2    -1      -6
    posone    -4    -2    -1     3      24
    postwo    -2    -1     3     4       8
    postre    -1     2     3     4      24

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
  input case$ x1-x4;
  array xs[*] x1-x4;
  call sortn(of xs[*]);
cards4;
posall 1 2 3 4
negone -1 2 3 4
negtwo -1 -2 3 4
negtre -1 -2 -3  4
negall -1 -2 -3 -4
posone -1 -2 3 -4
postwo -1 -2 3  4
postre -1  2 3  4
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


data want;
  retain maxMul;
  set have;
  maxMul=max(x1*x2*x3,x2*x3*x4,x1*x2*x4);
run;quit;


%utl_submit_wps64('
libname wrk "%sysfunc(pathname(work))";
data wrk.want;
  retain maxMul;
  set wrk.have;
  maxMul=max(x1*x2*x3,x2*x3*x4,x1*x2*x4);
run;submit;
');


