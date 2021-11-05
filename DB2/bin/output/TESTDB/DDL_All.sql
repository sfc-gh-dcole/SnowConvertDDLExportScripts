-- This CLP file was created using DB2LOOK Version "11.5" 
-- Timestamp: Fri Nov  5 15:24:56 2021
-- Database Name: TESTDB         
-- Database Manager Version: DB2/LINUXX8664 Version 11.5.6.0
-- Database Codepage: 1208
-- Database Collating Sequence is: IDENTITY
-- Alternate collating sequence(alt_collate): null
-- varchar2 compatibility(varchar2_compat): OFF


CONNECT TO TESTDB;

--------------------------
-- Mimic Storage groups --
--------------------------
 
ALTER STOGROUP "IBMSTOGROUP"
	 OVERHEAD 6.725000
	 DEVICE READ RATE 100.000000
	 DATA TAG NONE 
	 SET AS DEFAULT;

----------------------
-- Mimic tablespace --
----------------------

ALTER TABLESPACE "SYSCATSPACE"
      PREFETCHSIZE AUTOMATIC
      OVERHEAD INHERIT
      AUTORESIZE YES 
      MAXSIZE NONE
      TRANSFERRATE INHERIT;


ALTER TABLESPACE "SYSCATSPACE"
      USING STOGROUP "IBMSTOGROUP"; 


ALTER TABLESPACE "TEMPSPACE1"
      PREFETCHSIZE AUTOMATIC
      OVERHEAD INHERIT
      FILE SYSTEM CACHING 
      TRANSFERRATE INHERIT;


ALTER TABLESPACE "USERSPACE1"
      PREFETCHSIZE AUTOMATIC
      OVERHEAD INHERIT
      AUTORESIZE YES 
      MAXSIZE NONE
      TRANSFERRATE INHERIT
      DATA TAG INHERIT;


ALTER TABLESPACE "USERSPACE1"
      USING STOGROUP "IBMSTOGROUP"; 












COMMIT WORK;

CONNECT RESET;

TERMINATE;

