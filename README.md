sch
===

A small script used to generate an iCalendar .ICS file from McGill course CRNs.

Usage
-----

1. HTML Form  
Go to http://froyomuffin.com/sch
2. wget  
```
wget -O cal.ics "http://froyomuffin.com/cgi-bin/sch.cgi?CRN1+CRN2+...+CRNn"
```  
3. Shell  
```
./sch CRN1 CRN2 ... CRN2
```
4. Host it yourself!  
```
./install.sh
```  

Known Issues 
------------

- Users will have a very busy day on August 30th 2013.
