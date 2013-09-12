#!/bin/bash

#Input (CRN)
CRN=$1

SLICESIZE=100

SLICE=$(cat 20130906.html | grep -A $SLICESIZE "=$CRN&")
CRNLINES=$(echo "$SLICE" | grep -n "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | cut -d: -f1)
NEXTCRNLINE=$(echo $CRNLINES | cut -d' ' -f2)
TRIMMEDSLICE=$(echo "$SLICE" | sed ''${NEXTCRNLINE}',$d')

SUBJECTOUT=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")

TITLETOUT=$(echo "$TRIMMEDSLICE" | sed -n '7p' | sed 's/<[^>]\+>//g')

COURSESLOTS=$(echo "$TRIMMEDSLICE" | egrep -B1 -A7 " AM-| PM-" | sed 's/<[^>]\+>//g' | grep -v "\-\-")

COUNTER=1
while read p; do
	MODULO=$(( $COUNTER % 9 ))
	case $MODULO in
		1)	#Day of week
			DAYOFWEEK="$p"
			echo "Processed day of week"
			;;
		2)	#Time slot
			TIMESLOT="$p"
			echo "Processed time slot"
			;;
		8)	#Date range
			DATERANGE="$p"
			echo "Processed date range"
			;;
		0)	#Room number
			ROOMNUMBER="$p"
			echo "Processed room number"
			;;
#		*)	echo "normal"
#			;;
	esac
	COUNTER=$(( $COUNTER + 1 ))
done <<< "$COURSESLOTS"



#===== Some debug prints =====
#Course code
#echo "$SUBJECTOUT"

#Course title
#echo "$TITLETOUT"

