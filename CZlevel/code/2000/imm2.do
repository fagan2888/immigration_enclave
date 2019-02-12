clear
clear matrix
capture log close
set mem 2g
set more off
cd "/Users/victoriadequadros/projects/immigration_enclave/"

use data/2000/supp2000.dta 

keep if imm == 1

gen new = (yrsinus < 20)

gen rczone0 = (rczone==0)
gen rczone1 = (rczone==1)
gen male = 1 - female
gen native = 1 - imm

gen xclass2 = 1 if exp <= 10
replace xclass2 = 2 if 10 <= exp & exp <= 20
replace xclass2 = 3 if 20 <= exp & exp <= 30
replace xclass2 = 4 if 30 < exp

replace c = 1

gen havewage2 = 1 if logwage2 != .
gen cwagesal = incwage
replace cwagesal = . if incwage <= 0

gen cannhrs = . 
replace cannhrs = annhrs if annhrs > 0

gen hs = 1 - dropout - somecoll - collplus
gen college = 0
replace college = 1 if collplus == 1 & advanced == 0
gen x1 = (xclass2 == 1)
gen x2 = (xclass2 == 2)
gen x3 = (xclass2 == 3)
gen x4 = (xclass2 == 4)

gen hrswkly = .
replace hrswkly = annhrs / wkswork1 if annhrs > 0

gen ft = (hrswkly >= 35)

gen ex11 = (eclass==1)*(xclass2==1)
gen ex12 = (eclass==1)*(xclass2==2)
gen ex13 = (eclass==1)*(xclass2==3)
gen ex14 = (eclass==1)*(xclass2==4)
gen ex21 = (eclass==2)*(xclass2==1)
gen ex22 = (eclass==2)*(xclass2==2)
gen ex23 = (eclass==2)*(xclass2==3)
gen ex24 = (eclass==2)*(xclass2==4)
gen ex31 = (eclass==3)*(xclass2==1)
gen ex32 = (eclass==3)*(xclass2==2)
gen ex33 = (eclass==3)*(xclass2==3)
gen ex34 = (eclass==3)*(xclass2==4)
gen ex41 = (eclass==4)*(xclass2==1)
gen ex42 = (eclass==4)*(xclass2==2)
gen ex43 = (eclass==4)*(xclass2==3)
gen ex44 = (eclass==4)*(xclass2==4)

forvalues i=1/38{
	gen ic`i' = 1 if ic == `i'
}

preserve
# delim ;
collapse (mean) dropout hs somecoll college advanced collplus educ_yrs exp age 
				x1-x4 ex11 ex12 ex13 ex14 ex21 ex22 ex23 ex24 ex31 ex32 ex33 ex34 
				ex41 ex42 ex43 ex44 rczone0 rczone1 female wage2 logwage2 annhrs 
		 (sum) count=c [fweight = wt], by(ic male);
save data/2000/byicnew.dta, replace;
#delimit cr
restore 

