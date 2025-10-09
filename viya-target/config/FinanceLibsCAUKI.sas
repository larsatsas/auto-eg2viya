/* Set up the home folder based on the environment - testing a change */
%let home_folder = %sysget(HOME);

libname EXPECTED "&home_folder./EXPECTED";
libname ACTUAL "&home_folder./FINDATA";
libname FINDATA "&home_folder./FINDATA";
