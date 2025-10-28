/* Set up the home folder based on the environment */

%let MYHOST='SVC-SAS-SINGLESTORE-CLUSTER-DML';
%let myport=3306;
%let dbmax_text=32767;  

%let home_folder = /srv/nfs/kubedata/compute-landingzone/home/norlsk;
%put &home_folder.;

libname EXPECTED "&home_folder./EXPECTED";


libname FINDATA s2
  host=&myhost
  port=&myport
  database=MyDB
  user=admin
  password=Orion123
  dbmax_text=&dbmax_text
  RESULTS=server
  bulkload=yes
  dbclient_max_bytes=1
  dbsliceparm=all
  SQL_FUNCTIONS=ALL;

libname ACTUAL s2
  host=&myhost
  port=&myport
  database=MyDB
  user=admin
  password=Orion123
  dbmax_text=&dbmax_text
  RESULTS=server
  bulkload=yes
  dbclient_max_bytes=1
  dbsliceparm=all
  SQL_FUNCTIONS=ALL;


cas;
caslib _all_ assign;
