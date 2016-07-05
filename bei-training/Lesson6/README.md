README.txt
BEI ASCII File Format  
Specs & Documentation

Version 1.6.11
Production Release for Rel-1.9
last modified: Jun, 13th, 2016
Matt Peters
support@beiservices.com



For machine related performance reporting, the following information is required by B.E.I. Services Inc.  Data fields in ITALICS are not required. The data files need to be in PIPE [ | ] delimited ASCII format.  Each line must contain one and only one unix new line character “\n” or a LF (linefeed) character at the end of each line.

For basic implementation, BEI requires at least 3 files (FIXSERL, FIXSERV, FIXPARLA).  
For multiple meters reporting, BEI requires multiple meters data sent via the (FIXMETER, FIXMDESC) files. 
For Sales Comp, improved meters accuracy, BEI also requires the (FIXBILLING) file.
For EWD (Territory Mapping) solution, BEI also requires the (FIXADDR) file.
For AIM solution, BEI also requires the (FIXPLOC) file.
For Supplies solution, BEI requires the (FIXSHIP) file.
For Technician Training solution, BEI also requires the (FIXTECH, FIXLABOR) files.
The following is a list of data fields we use.  Although they may be called different names, many of these fields are common among most computer automation systems.

notes:
Every field must be represented, even if it’s NULL.
All dates should be ASCII Gregorian dates, in the following format: VARCHAR(8) [MM/DD/YY] fields and will be referred to as : BEI Date
Times need to be ASCII 24 hr. clock format [1200] unless otherwise noted, with no semi-colon and should be in the following format: VARCHAR(4) and will be referred to as : BEI Time
All numeric fields should be right justified and filled with preceding zero’s [0].
s
Field positions are offset.

For simplification, SQL field type standards will be used to describe field formats:

ALPHANUMERIC  VARCHAR(x) where x represents MAX length.
NUMERIC  INT(x) where x represents MAX length.
ALPHANUMERIC  CHAR(x) where x represents FIXED length.
