#!/bin/bash

#Input (CRN)
CRN=$1
YEAR=2013

SLICESIZE=100

SLICE=$(cat 20130906.html | grep -A $SLICESIZE "=$CRN&")
CRNLINES=$(echo "$SLICE" | grep -n "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | cut -d: -f1)
NEXTCRNLINE=$(echo $CRNLINES | cut -d' ' -f2)
TRIMMEDSLICE=$(echo "$SLICE" | sed ''${NEXTCRNLINE}',$d')

SUBJECTOUT=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")

TITLETOUT=$(echo "$TRIMMEDSLICE" | sed -n '7p' | sed 's/<[^>]\+>//g')

COURSESLOTS=$(echo "$TRIMMEDSLICE" | egrep -B1 -A7 " AM-| PM-" | sed 's/<[^>]\+>//g' | grep -v "\-\-")

#Build the output
OUT=\
"BEGIN:VCALENDAR
VERSION:1.0
"

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
			echo $p
			;;
		8)	#Date range
			STARTDATE=`echo $p | cut -d'-' -f1 | sed -e 's/\//''/g'`
			STARTDATE=$YEAR$STARTDATE

			ENDDATE=`echo $p | cut -d'-' -f2 | sed -e 's/\//''/g'`
			ENDDATE=$YEAR$ENDDATE
			echo "$STARTDATE, $ENDDATE"
			;;
		0)	#Room number + Generate the output
OUT=\
"$OUT
BEGIN:VEVENT"

#

OUT=\
"$OUT
END:VEVENT"
			;;
	esac
	COUNTER=$(( $COUNTER + 1 ))
done <<< "$COURSESLOTS"

OUT=\
"$OUT

END:VCALENDAR"

echo -e "$OUT"

#===== Some debug prints =====
#Course code
#echo "$SUBJECTOUT"

#Course title
#echo "$TITLETOUT"

