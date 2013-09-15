#!/bin/bash

#Through CGI
if [[ $QUERY_STRING != "" ]]
then
	echo "Content-Type: text/plain"
	echo 'Content-Disposition: attachment; filename="cal.ics"'
	INPUT=$QUERY_STRING
	INPUT=$(echo $INPUT | sed 's/crns=//g')
	INPUT=$(echo $INPUT | sed 's/\(+\|%20\|%2C\|%2B\)/ /g')
else
#Through Shell
	INPUT=$*
fi

#Configure these
HARDDATE=20130830
COURSEHTML="20130906.html"
SLICESIZE=100

YEAR=$(date +"%Y")

for i in $INPUT
do
	CRN=$i

	SLICE=$(cat $COURSEHTML | grep -A $SLICESIZE "crn_in=$CRN&")
	CRNLINES=$(echo "$SLICE" | grep -n "bwckschd.p_disp_listcrse?term_in=" | cut -d: -f1)
	NEXTCRNLINE=$(echo $CRNLINES | cut -d' ' -f2)
	TRIMMEDSLICE=$(echo "$SLICE" | sed ''${NEXTCRNLINE}',$d')

	SUMMARY=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")

	DESCRIPTION=$(echo "$TRIMMEDSLICE" | sed -n '7p' | sed 's/<[^>]\+>//g')

	COURSESLOTS=$(echo "$TRIMMEDSLICE" | egrep -B1 -A7 " AM-| PM-" | sed 's/<[^>]\+>//g' | grep -v "\-\-")

	COUNTER=1
	while read p; do
		MODULO=$(( $COUNTER % 9 ))
		case $MODULO in
			1)	#Day of week
				if [[ "$p" == *M* ]]
				then
					BYDAY="$BYDAY,MO"
				fi
				if [[ "$p" == *T* ]]
				then
					BYDAY="$BYDAY,TU"
				fi
				if [[ "$p" == *W* ]]
				then
					BYDAY="$BYDAY,WE"
				fi
				if [[ "$p" == *R* ]]
				then
					BYDAY="$BYDAY,TH"
				fi
				if [[ "$p" == *F* ]]
				then
					BYDAY="$BYDAY,FR"
				fi
				BYDAY=`echo $BYDAY | sed 's/^.//'` 
				;;
			2)	#Time slot
				STARTTIME=`echo $p | cut -d'-' -f1`
				ENDTIME=`echo $p | cut -d'-' -f2`

				STARTTIME=`date --date="$STARTTIME" +%T | sed -e 's/:/''/g'`
				ENDTIME=`date --date="$ENDTIME" +%T | sed -e 's/:/''/g'`
				#->echo $p
				#->echo "$STARTTIME, $ENDTIME"

				;;
			8)	#Date range
				STARTDATE=`echo $p | cut -d'-' -f1 | sed -e 's/\//''/g'`
				STARTDATE=$YEAR$STARTDATE

				ENDDATE=`echo $p | cut -d'-' -f2 | sed -e 's/\//''/g'`
				ENDDATE=$YEAR$ENDDATE
				UNTIL=$ENDDATE
				#->echo "$STARTDATE, $ENDDATE"
				if [[ $STARTDATE != $ENDDATE ]]
				then
					STARTDATE=$HARDDATE
					ENDDATE=$HARDDATE
				fi
				;;
			0)	#Room number + Generate the output
				LOCATION=$p
OUT=\
"$OUT
BEGIN:VEVENT
DTSTART:${STARTDATE}T$STARTTIME
DTEND:${ENDDATE}T$ENDTIME
RRULE:FREQ=WEEKLY;UNTIL=$UNTIL;BYDAY=$BYDAY
SUMMARY:$SUMMARY
LOCATION:$LOCATION
DESCRIPTION:$DESCRIPTION
END:VEVENT
"
				BYDAY=""
				;;
		esac
		COUNTER=$(( $COUNTER + 1 ))
	done <<< "$COURSESLOTS"

done

echo \
"
BEGIN:VCALENDAR
VERSION:2.0
$OUT
END:VCALENDAR"
