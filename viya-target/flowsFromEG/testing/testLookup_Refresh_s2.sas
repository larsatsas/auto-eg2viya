/* Doing a symbolic change to this one again */
/* After checking out my previous fix we got this to work */

proc sort data=FINDATA.PRODUCTLINE out=act_productline;
by ProductID;
run;

proc sort data=EXPECTED.productline out=exp_productline;
	by ProductID;
	run;

proc compare 
	base=exp_productline 
	compare=act_productline    
	briefsummary;
    id ProductID;
run;
%let rcpl=&sysinfo;

proc sort data=FINDATA.LOOKUP_FACILITY_NAME out=act_LOOKUP_FACILITY_NAME;
by FacilityID;
run;

proc sort data=EXPECTED.LOOKUP_FACILITY_NAME out=exp_LOOKUP_FACILITY_NAME;
	by FacilityID;
	run;

proc compare 
	base=exp_LOOKUP_FACILITY_NAME 
	compare=act_LOOKUP_FACILITY_NAME    
	briefsummary;
    id FacilityID;
run;
%let rclfn=&sysinfo;


proc sort data=FINDATA.FACILITY_STATE out=act_FACILITY_STATE;
by FacilityID;
run;

proc sort data=EXPECTED.FACILITY_STATE out=exp_FACILITY_STATE;
	by FacilityID;
	run;

proc compare 
	base=exp_FACILITY_STATE 
	compare=act_FACILITY_STATE    
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
