/* Set up the home folder based on the environment */
%let home_folder = /srv/nfs/kubedata/compute-landingzone/home/norlsk;
%put &home_folder.;

libname EXPECTED "&home_folder./EXPECTED";
libname ACTUAL "&home_folder./FINDATA";
libname FINDATA "&home_folder./FINDATA";
