sch
===

First public project! A small script used to generate an iCalendar .ICS file from McGill course CRNs.

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
./sch.cgi CRN1 CRN2 ... CRNn
```

Known Issues 
------------

- There needs to be a date before the first day of term with an entire week worth of courses scheduled
- Misuse of sed somewhere
