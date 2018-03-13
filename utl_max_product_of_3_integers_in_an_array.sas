Max product of 3 integers in an array

  Same result in WPS and SAS
  
  Added an IML solution by Rick on the end

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




Rick Wicklin via listserv.uga.edu 


Mar 9 (4 days ago)
to SAS-L 
We can solve this problem more generally and more compactly. Suppose there are p variables and you want the maximum product of k.  
(Roger has hard-coded the case p=4 and k=3.)  You can use the ALLCOMB function in SAS to generate all the combinations of p 
objects taken k at a time. Use these as indices into the array of variables. Now take the maximum product of the possible 
combinations for each observation. In SAS/IML, this can be done as follows:

proc iml;
use have; read all var _num_ into X; close;
p = ncol(X);
k = 3;
c = allcomb(p, k);  /* combinations of p items taken k at a time */

maxMul = j(nrow(X), 1);
do i = 1 to nrow(X);
   Y = X[i,];                   /* get i_th row */
   M = shape(Y[c], nrow(c), k); /* all combinations of elements */
   maxMul[i] = max( M[,#] );    /* max of product of rows */
end;

print maxMul;

Notice that by changing k=3 to k=2, you can compute the maximum pairwise product.  If the data set contains 
6 variables instead of 4, the program works without modification.

For details of the ALLCOMB function, see
https://blogs.sas.com/content/iml/2013/09/30/generate-combinations-in-sas.html
The syntax M[,#] is called a "subscript reduction operator." See
https://blogs.sas.com/content/iml/2012/05/23/compute-statistics-for-each-row-by-using-subscript-operators.html


