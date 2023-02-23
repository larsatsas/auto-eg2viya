libname EXPECTED '/gelcontent/gelcorp/expected';
libname FINDATA '/gelcontent/gelcorp/finance/data';

proc compare 
	base=expected.productline 
	compare=findata.productline    
	briefsummary;
run;
%let rcpl=&sysinfo;

proc compare 
	base=expected.LOOKUP_FACILITY_NAME 
	compare=findata.LOOKUP_FACILITY_NAME    
	briefsummary;
run;
%let rclfn=&sysinfo;

proc compare 
	base=expected.FACILITY_STATE 
	compare=findata.FACILITY_STATE    
	briefsummary;
run;
%let rcfs=&sysinfo;

data _null_;
	if &rcpl >=  65 then 
		error 'Actual productline did not match expected';
	if &rclfn >= 65 then
		error 'Actual LOOKUP_FACILITY_NAME did not match expected';
	if &rcfs >= 65 then
		error 'Actual FACILITY_STATE did not match expected';
	if (&rcpl >=65) or (&rclfn >= 65) or (&rcfs >= 65) then
		abort cancel;
run;
