****************************************************************************************;
**                                                                                    **;
**  Adapted from viya-target/LendingClubLoan.sas (auto-eg2viya)                       **;
**  STEP 1 (load) and STEP 2 (explore) of the original workshop script, unmodified    **;
**  in logic. The Viya-only CAS steps (STEP 3 partition, STEP 4 train forest/gboost,  **;
**  STEP 5 evaluate, STEP 6 score) are not part of this bundle -- everything below    **;
**  is standard SAS exactly as the author wrote it.                                   **;
**                                                                                    **;
****************************************************************************************;

*****************************************************;
**  system options                                 **;
*****************************************************;
ods graphics on;

*****************************************************;
**  assign librefs and identify the format library **;
*****************************************************;
libname LendFMT (work);
options FMTSEARCH=(LendFMT);

*************************************************;
**                                             **;
**   STEP 1: LOAD THE INPUT DATA               **;
**                                             **;
*************************************************;
********************************************************************************;
** Assign Macro Variables for the libref, input csv file, and SAS data set    **;
********************************************************************************;
%let WBDataLib  = Lend;                * libref for workbench data             *;
%let inputData  = LCLoanData;          * input table                           *;

libname &WBDataLib. (work);

********************************************************************************;
** Pull the .csv file into a SAS data set                                     **;
** (bundle note: the original INFILE pointed at exported/data/LENDINGCLUBLOAN **;
** DATA.csv on disk -- the runner ships script text only, so a 25-row sample  **;
** of that same file -- header dropped, same column order -- is inlined      **;
** below via DATALINES/DSD instead of INFILE.)                               **;
********************************************************************************;
data &WBDataLib..&inputData.;
  %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
  infile datalines delimiter = ',' MISSOVER DSD ;
      format CreditPolicy Default PublicRecord $1.;
      format Gender $6.;
      format Race $10.;
      format Purpose $20. ;
      format Age
             InterestRate
             Installment
             LogAnnualInc
             DebtIncRatio
             FICOScore
             CreditLineAge
             RevBalance
             RevUtilization
             Inquiries6Mnths
             Delinquencies2Yrs best32.
             ;
      input
            CreditPolicy $
            Purpose $
            InterestRate
            Installment
            LogAnnualInc
            DebtIncRatio
            FICOScore
            CreditLineAge
            RevBalance
            RevUtilization
            Inquiries6Mnths
            Delinquencies2Yrs
            PublicRecord $
            Default $
            Age
            Race $
            Gender $
      ;
     Label
            Age               = "Age"
            CreditPolicy      = "Meets Lending Club Credit Underwriting Policy (0/1)"
            CreditLineAge     = "Length of Credit Line in Days"
            DebtIncRatio      = "Debt to Income Ratio"
            Default           = "Loan has not been Repaid"
            Delinquencies2Yrs = "Credit Delinquencies in the last 2 Years"
            FICOScore         = "FICO Credit Score"
            Gender            = "Gender"
            Inquiries6Mnths   = "Credit Inquiries in the last 6 Months"
            InterestRate      = "Interest Rate"
            Installment       = "Monthly Installment"
            LogAnnualInc      = "Natural Log of Self Reported Annual Income"
            PublicRecord      = "Public Record"
            Purpose           = "Purpose of the Loan"
            Race              = "Race"
            RevBalance        = "Revolving Balance"
            RevUtilization    = "Revolving Utilitization"
      ;
  if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
datalines;
           1,all_other,      0.1008,       80.77, 11.08220409,        1.55,         697,        4380,        9743,        62.9,           1,           0,           0,           0,          20,Hispanic,Female
           1,educational,      0.1158,       79.24, 10.16585182,       15.05,         692, 3450.958333,         731,         5.8,           3,           1,           0,           1,          42,White,Male
           1,all_other,      0.1095,      130.86, 10.51867319,        6.36,         722,        3690,       15830,        52.8,           2,           0,           0,           0,          54,Hispanic,Female
           1,debt_consolidation,      0.1183,      497.01,  11.0744205,          11,         732, 2879.958333,        8318,        50.7,           1,           0,           0,           0,          91,White,Female
           1,credit_card,      0.1158,      115.55, 10.46310334,       14.47,         702,        2160,        8716,          51,           0,           0,           0,           0,          25,Black,Male
           1,all_other,      0.1287,      168.17, 10.67359577,       14.89,         682, 2429.958333,       17123,        75.8,           3,           0,           0,           0,           3,Hispanic,Female
           1,all_other,      0.1158,      660.27, 12.61153775,        6.93,         762, 10679.95833,           0,           0,           1,           0,           0,           0,          11,Black,Female
           1,small_business,      0.1884,      438.93, 10.81977828,        12.6,         712,        3690,       11957,        43.5,           2,           0,           0,           0,          42,White,Female
           1,small_business,      0.1189,      505.76, 11.40756495,        9.44,         737, 3029.958333,        5137,        24.2,           0,           0,           0,           1,          61,White,Female
           1,educational,      0.1218,       64.11, 10.30895266,        8.36,         712, 1349.958333,         277,        46.2,           2,           0,           0,           0,          81,White,Male
           1,all_other,      0.0932,      127.79, 10.91508846,          12,         752,        2856,        1112,         2.7,           1,           0,           0,           0,           2,Hispanic,Female
           1,all_other,       0.157,      112.04, 10.76880073,        2.32,         672,        1444,        2340,        38.4,           0,           0,           0,           0,           2,Black,Female
           1,major_purchase,      0.1008,      161.53,  10.6454249,       21.77,         762, 4470.958333,          13,         1.9,           1,           0,           0,           0,          54,Hispanic,Male
           1,debt_consolidation,      0.1461,      344.76, 10.46310334,       10.22,         672, 4530.041667,       10274,        76.1,           1,           0,           0,           0,          13,Hispanic,Female
           1,credit_card,      0.0976,      128.62, 9.392661929,         9.6,         707,        1320,        3987,        31.9,           1,           0,           0,           0,          48,White,Female
           1,credit_card,      0.1261,      837.67, 11.60739893,       24.04,         757,        7260,        8220,        63.2,           0,           0,           0,           1,          42,White,Female
           1,all_other,      0.1095,      327.14, 11.10495723,       19.87,         732, 3419.958333,       20545,        43.2,           2,           0,           0,           0,          60,White,Female
           1,educational,      0.0932,      191.69, 10.62132735,        17.5,         732, 7049.958333,       19391,          68,           0,           0,           0,           0,          49,Asian,Female
           1,debt_consolidation,      0.0859,      316.11, 11.00209984,        3.78,         767,        3390,        3252,        13.7,           0,           0,           0,           0,          10,White,Male
           1,debt_consolidation,      0.1221,      299.84, 11.28978191,        11.4,         692, 2399.958333,       22014,        51.9,           0,           0,           0,           0,          37,Hispanic,Male
           1,debt_consolidation,      0.1136,      279.75, 11.22524339,        4.46,         697,        3330,        1954,        26.9,           0,           1,           0,           0,          49,White,Female
           1,all_other,      0.0963,      320.95, 10.97678203,       24.57,         762, 8849.958333,       23607,        37.5,           4,           0,           0,           1,          43,White,Male
           1,all_other,      0.0964,      128.41, 11.51292546,          15,         722,        3026,        8155,        14.9,           1,           0,           0,           0,          55,Black,Female
           1,all_other,      0.0932,      127.79, 11.49272276,        2.77,         737, 3479.958333,       12535,          20,           0,           0,           0,           0,          16,Hispanic,Female
           1,debt_consolidation,      0.1136,      164.56, 10.71441777,        6.51,         687, 4620.041667,        5971,        67.9,           1,           0,           1,           0,          49,Asian,Male
;
run;

*************************************************;
**                                             **;
**   STEP 2: EXPLORE THE DATA                  **;
**                                             **;
*************************************************;

************************************************************************;
** Review the proc CONTENTS, proc MEAN, and print 10 observations     **;
************************************************************************;
ods proctitle;
proc contents data = &WBDataLib..&inputData.;
  ods exclude enginehost;
run;

title "Summary Statistics of Lending Club Loan Data";
proc means data = &WBDataLib..&inputData. n nmiss mean min max std;
  ods exclude sortinfo;
run;

title "First 10 Rows of Lending Club Loan Data";
proc print data=&WBDataLib..&inputData.(obs=10);
run;
title;

************************************************************************;
** Create user defined formats to improve the readability of output   **;
************************************************************************;
proc format library=LendFMT;
  value posneg
			 low - -.000000001 = 'Negative Number'
				   	           0 = '0'
      0.000000001 - high = 'Positive Number'
  		;
  value agegroup
      low-14  = 'Children'
        14-24 = 'Youth'
        25-44 = 'Young Adult'
        45-64 = 'Middle Aged Adults'
      65-high = 'Seniors'
      ;
  value fico
      350-579 = 'Poor (350-579)'
      580-669 = 'Fair (580-669)'
      670-739 = 'Good (670-739)'
      740-799 = 'Very Good (740-799)'
      800-850 = 'Exceptional (800-850)'
      other = 'other'
      ;
run;

************************************************************************;
** Review the distribution of each field in tabular format            **;
************************************************************************;
proc freq data = &WBDataLib..&inputData.;
  tables CreditPolicy Default FICOscore Purpose Race Gender
         / nocum
          ;
  format Age               ageGroup.
         FICOscore         fico.
        ;
  run;

************************************************************************;
** Investigate the relationship between FICOScore and Default         **;
************************************************************************;
proc sort data=&WBDataLib..&inputData.;
    by default;
run;

ods noproctitle;
title "What is the relationship between FICO Score and Default?";
footnote italic 'NOTE: The distribution of borrowers who default is to the left of those who repay their loans.';
proc univariate data=&WBDataLib..&inputData.;
    class default;
    var FICOscore;
    ods exclude Moments BasicMeasures ExtremeObs Quantiles TestsForLocation Histogram;
run;
title;
footnote;
