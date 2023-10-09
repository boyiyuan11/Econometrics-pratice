import excel "C:\Users\User\Desktop\cps09mar.xlsx", sheet("Sheet1") firstrow
gen lwage = log( earnings )
gen experience = age - education - 6
gen experience2 = experience^2
keep if female == 0 & race == 1 & hisp == 1 & experience < 45
*Create dummy variables
gen region_1 = (region == 1)
gen region_3 = (region == 3)
gen region_4 = (region == 4)
gen marital_1 = (marital == 1)
gen marital_2 = (marital == 2)
gen marital_3 = (marital == 3)
gen marital_4 = (marital == 4)
gen marital_5 = (marital == 5)
gen marital_6 = (marital == 6)
reg lwage region_1 region_3 region_4 marital_1 marital_2 marital_3 marital_4 marital_5 marital_6 education experience experience2