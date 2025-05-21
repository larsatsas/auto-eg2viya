/* How about doing a change from a VSCode over web as my private github user - now in a new branch */
/* Doing a symbolic change to this one */

proc compare 
	base=expected.productline 
	compare=actual.PRODUCTLINE    
	briefsummary;
    id Product ProductLine;
run;
%let rcpl=&sysinfo;

proc compare 
	base=expected.LOOKUP_FACILITY_NAME 
	compare=actual.LOOKUP_FACILITY_NAME    
	briefsummary;
    id FacilityID;
run;
%let rclfn=&sysinfo;

proc compare 
	base=expected.FACILITY_STATE 
	compare=actual.FACILITY_STATE    
	briefsummary;
    id FacilityID;
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
