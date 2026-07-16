****************************************************************************************;
**                                                                                    **;
**  Adapted from viya-target/flowsFromEG/testing/testLookup_Refresh.sas               **;
**  (auto-eg2viya) -- the CICD validation step run after a lookup refresh, unmodified **;
**  in logic: three PROC COMPARE checks (productline, LOOKUP_FACILITY_NAME,           **;
**  FACILITY_STATE) between an EXPECTED libref and an ACTUAL libref, then an abort     **;
**  if any comparison's SYSINFO indicates a mismatch (>= 65).                          **;
**                                                                                    **;
**  Bundle note: upstream EXPECTED/ACTUAL point at /gelcontent paths populated by the **;
**  eg2viya.yml workflow from exported/data/*.sas7bdat. Since the runner ships script **;
**  text only, both librefs are pointed at WORK here and populated with small mock    **;
**  datasets matching the real column layout (Product/ProductLine and FacilityID-     **;
**  keyed) -- matching rows on both sides, the same "clean refresh" case the pipeline **;
**  itself is checking for.                                                          **;
**                                                                                    **;
****************************************************************************************;

libname expected (work);
libname actual   (work);

data expected.productline;
	length Product $12 ProductLine $20;
	input Product $ ProductLine $;
	datalines;
P001 Consumer_Lending
P002 Commercial_Lending
P003 Mortgage
P004 Auto_Loan
P005 Credit_Card
;
run;

data actual.productline;
	length Product $12 ProductLine $20;
	input Product $ ProductLine $;
	datalines;
P001 Consumer_Lending
P002 Commercial_Lending
P003 Mortgage
P004 Auto_Loan
P005 Credit_Card
;
run;

data expected.lookup_facility_name;
	length FacilityID $8 FacilityName $30;
	input FacilityID $ FacilityName $;
	datalines;
F1001 Denver_Branch
F1002 Austin_Branch
F1003 Chicago_Branch
F1004 Boston_Branch
;
run;

data actual.lookup_facility_name;
	length FacilityID $8 FacilityName $30;
	input FacilityID $ FacilityName $;
	datalines;
F1001 Denver_Branch
F1002 Austin_Branch
F1003 Chicago_Branch
F1004 Boston_Branch
;
run;

data expected.facility_state;
	length FacilityID $8 State $2;
	input FacilityID $ State $;
	datalines;
F1001 CO
F1002 TX
F1003 IL
F1004 MA
;
run;

data actual.facility_state;
	length FacilityID $8 State $2;
	input FacilityID $ State $;
	datalines;
F1001 CO
F1002 TX
F1003 IL
F1004 MA
;
run;

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
