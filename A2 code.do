* Practice with Census data in Stata - ECON705 A2 code

clear
use "D:\Dropbox\ECON 705 2023\Assignments\Census_2016_Individual_PUMF.dta" 


*1a) 
hist wages
summ wages, d

*1b)
drop if wages>=88888888 
hist wages
summ wages, d

*1d) 
gen lwages = ln(wages+1)
hist lwages
summ lwages, d

*1e)
drop if genstat==8
drop if genstat==3 
gen First=0
replace First=1 if genstat==1
 
gen Second=0
replace Second=1 if genstat==2 

gen Third=0
replace Third=1 if genstat==4 

regress lwages First Second Third


*1f)  
regress lwages First Second Third, noconstant



*1g) 

drop if hdgree==88
drop if hdgree==99
gen bach =0 
replace bach=1 if hdgree>=9

regress lwages First Second Third if bach==1, noconstant
regress lwages First Second Third if bach==0, noconstant




*Question 2
clear
 use "D:\Dropbox\ECON 705 2023\Assignments\Census_2016_Individual_PUMF.dta" 
*a)
drop if wages>=88888888 

gen female=0
replace female=1 if sex==1
gen lwages = ln(wages+1)
regress lwages female

*b)

preserve
graph drop _all 	

	matrix drop _all 
	matrix betas = J(11,4,0)
	estimates drop _all 
	forvalues i = 1/11 {	
	    regress lwages female if cip2011_stem_sum==`i'
		
		matrix betas[`i',1] = _b[female]
		*e(tau_cl)
		matrix betas[`i',2] =  _b[female] - invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',3] =  _b[female] + invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',4] = `i'
	}

	
	
	matrix list betas
	xsvmat betas, name(matcol) saving(wagegap.dta, replace)

restore	
	*Graph 			
	preserve 
	use wagegap, clear 	
	rename betasc1 Coef 
	rename betasc2 CoefLow95 
	rename betasc3 CoefHigh95
	rename betasc4 Order 
	g Quarter = Order 
	graph twoway (scatter Coef Quarter, color(gs10)) (rcap CoefLow95 CoefHigh95 Quarter), xtitle("Field of Study") ytitle("Estimated Gap") xsc(titlegap(2)) ysc(titlegap(2)) title("Wage Gap by Field of Study") legend(off)		xlabel(, format(%03.2f)) ylabel(, format(%03.2f))  xline(.12, lcolor(gs0))  name(byQuarter, replace)
	restore

	
		
*c) 
preserve
graph drop _all 	

	matrix drop _all 
	matrix betas = J(10,4,0)
	estimates drop _all 
	forvalues i = 1/10 {	
	    regress lwages female if nocs==`i'
		
		matrix betas[`i',1] = _b[female]
		*e(tau_cl)
		matrix betas[`i',2] =  _b[female] - invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',3] =  _b[female] + invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',4] = `i'
	}

	
	
	matrix list betas
	xsvmat betas, name(matcol) saving(wagegap.dta, replace)

restore	
	*Graph 			
	preserve 
	use wagegap, clear 	
	rename betasc1 Coef 
	rename betasc2 CoefLow95 
	rename betasc3 CoefHigh95
	rename betasc4 Order 
	g occupation = Order 
	graph twoway (scatter Coef occupation, color(gs10)) (rcap CoefLow95 CoefHigh95 occupation), xtitle("Occupation") ytitle("Estimated Gap") xsc(titlegap(2)) ysc(titlegap(2)) title("Wage Gap by Occupation") legend(off)		xlabel(, format(%03.2f)) ylabel(, format(%03.2f))  xline(.12, lcolor(gs0))  name(byoccupation, replace)
	restore
	
			
*d) 
preserve
graph drop _all 	

	matrix drop _all 
	matrix betas = J(16-7+1,4,0)
	estimates drop _all 
	forvalues i = 7/16 {	
	    regress lwages female if agegrp==`i'
		
		matrix betas[`i'-7+1,1] = _b[female]
		*e(tau_cl)
		matrix betas[`i'-7+1,2] =  _b[female] - invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i'-7+1,3] =  _b[female] + invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i'-7+1,4] = `i'
	}

	
	
	matrix list betas
	xsvmat betas, name(matcol) saving(wagegap.dta, replace)

restore	
	*Graph 			
	preserve 
	use wagegap, clear 	
	rename betasc1 Coef 
	rename betasc2 CoefLow95 
	rename betasc3 CoefHigh95
	rename betasc4 Order 
	g agegroup = Order 
	graph twoway (scatter Coef agegroup, color(gs10)) (rcap CoefLow95 CoefHigh95 agegroup), xtitle("Age Group") ytitle("Estimated Gap") xsc(titlegap(2)) ysc(titlegap(2)) title("Wage Gap by Age Group") legend(off)		xlabel(, format(%03.2f)) ylabel(, format(%03.2f))  xline(.12, lcolor(gs0))  name(byagegroup, replace)
	restore

*e) 
preserve
graph drop _all 	

	matrix drop _all 
	matrix betas = J(7,4,0)
	estimates drop _all 
	forvalues i = 1/7 {	
	    regress lwages female if cfsize==`i'
		
		matrix betas[`i',1] = _b[female]
		*e(tau_cl)
		matrix betas[`i',2] =  _b[female] - invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',3] =  _b[female] + invttail(e(df_r),0.025)*_se[female]
		matrix betas[`i',4] = `i'
	}

	
	
	matrix list betas
	xsvmat betas, name(matcol) saving(wagegap.dta, replace)

restore	
	*Graph 			
	preserve 
	use wagegap, clear 	
	rename betasc1 Coef 
	rename betasc2 CoefLow95 
	rename betasc3 CoefHigh95
	rename betasc4 Order 
	g famsize = Order 
	graph twoway (scatter Coef famsize, color(gs10)) (rcap CoefLow95 CoefHigh95 famsize), xtitle("Family Size") ytitle("Estimated Gap") xsc(titlegap(2)) ysc(titlegap(2)) title("Wage Gap by Family Size") legend(off)		xlabel(, format(%03.2f)) ylabel(, format(%03.2f))  xline(.12, lcolor(gs0))  name(byfamsize, replace)
	restore
		