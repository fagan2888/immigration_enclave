*imm1 follows allnp2.sas ;

options ls=120 nocenter;
libname c90 '/home/groups/sorkin/quadros/data/1990';
libname here '.'; 


  /*

keep rmsa imm female logwage2 wt p1-p10 dev devsq c age 
              educ exp exp2 exp3 inschool dropout somecoll collplus advanced 
              asian black hispanic black_ed black_coll asian_ed asian_coll
              hisp_ed hisp_coll imm_ed imm_coll yrsinus yrsinus2
              euro_ed hi_asian_ed mid_asian_ed mex_ed 
              euro_coll hi_asian_coll mid_asian_coll mex_coll
              euro_yrs hi_asian_yrs mid_asian_yrs mex_yrs
              euro_yrs2 hi_asian_yrs2 mid_asian_yrs2 mex_yrs2 
              pre_exp pre_exp1 english pob state msa nonmover 
              ic euro hi_asian mid_asian mex owage annhrs xclass 
              eclass wagesal weeks selfinc wage wage2 emp;

  */


data one;
set c90.supp90;
if imm=1;

rmsa0=(rmsa=0);
rmsa1=(rmsa=1);
male=1-female;
native=1-imm;

lw2sq=logwage2**2;

if exp<=10 then xclass2=1;
else if exp<=20 then xclass2=2;
else if exp<=30 then xclass2=3;
else xclass2=4;
c=1;

havewage2=(logwage2 ne .);
if wagesal<=0 then cwagesal=.;
else cwagesal=wagesal;

if annhrs>0 then cannhrs=annhrs;
else cannhrs=.;

hs=1-dropout-somecoll-collplus;
if collplus=1 and advanced=0 then college=1;
else college=0;
x1=(xclass2=1);
x2=(xclass2=2);
x3=(xclass2=3);
x4=(xclass2=4);

if annhrs>0 then hrswkly=annhrs/weeks;
else hrswkly=.;
ft=(hrswkly>=35);

q1=p1+p2;
q2=p3+p4;
q3=p5+p6;
q4=p7+p8;
q5=p9+p10;

if logwage2 ne . then do;
 q1c=q1;
 q2c=q2;
 q3c=q3;
 q4c=q4;
 q5c=q5;
end;
else do;
 q1c=.;
 q2c=.;
 q3c=.;
 q4c=.;
 q5c=.;
end;


ex11=(eclass=1)*(xclass2=1);
ex12=(eclass=1)*(xclass2=2);
ex13=(eclass=1)*(xclass2=3);
ex14=(eclass=1)*(xclass2=4);
ex21=(eclass=2)*(xclass2=1);
ex22=(eclass=2)*(xclass2=2);
ex23=(eclass=2)*(xclass2=3);
ex24=(eclass=2)*(xclass2=4);
ex31=(eclass=3)*(xclass2=1);
ex32=(eclass=3)*(xclass2=2);
ex33=(eclass=3)*(xclass2=3);
ex34=(eclass=3)*(xclass2=4);
ex41=(eclass=4)*(xclass2=1);
ex42=(eclass=4)*(xclass2=2);
ex43=(eclass=4)*(xclass2=3);
ex44=(eclass=4)*(xclass2=4);

length ic1-ic38 3;
array icc (*) ic1-ic38;
do j=1 to 38;
icc(j)=(ic=j);
end;




proc freq;
tables eclass*xclass2;
weight wt;
proc means;
var ex11 ex12 ex13 ex14 ex21 ex22 ex23 ex24 ex31 ex32 ex33 ex34 ex41 ex42 ex43 ex44
    ic1-ic38;
weight wt;





proc summary data=one;
class ic male;
var dropout hs somecoll college advanced collplus educ exp age x1-x4
    ex11 ex12 ex13 ex14 ex21 ex22 ex23 ex24 ex31 ex32 ex33 ex34 ex41 ex42 ex43 ex44
    rmsa0 rmsa1 female wage2 logwage2 annhrs c;
output out=here.byic
mean=
sum(c)=count;
weight wt;

proc print data=here.byic;
where (male=.);
var ic count female dropout hs somecoll collplus x1-x4;
format female dropout hs somecoll collplus x1-x4 5.3;

proc summary data=one;
class rmsa;
var ic1-ic38;
weight wt;
output out=citydist
sum=;

data c1;
set citydist;
if rmsa=.;

array sumic (*) sumic1-sumic38;
array icc (*) ic1-ic38;
do j=1 to 38;
sumic(j)=icc(j);
end;
d=1;

keep d sumic1-sumic38;

data c2;
set citydist;
if rmsa ne .;
d=1;

proc sort data=c1; by d;
proc sort data=c2; by d;

data here.ic_city;
merge c2 c1; by d;

array sumic (*) sumic1-sumic38;
array icc (*) ic1-ic38;
array shric (*) shric1-shric38;

do j=1 to 38;
shric(j)=icc(j)/sumic(j);
end;

drop d sumic1-sumic38 ic1-ic38;


proc print data=here.ic_city;
var rmsa shric1-shric7 shric37 shric38;
format shric1-shric7 shric37 shric38 6.4;

proc means n mean sum min max data=here.ic_city;
var shric1-shric38;




