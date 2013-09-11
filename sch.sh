#!/bin/bash
CRN=$1
SLICESIZE=100
SLICE=$(cat 20130906.html | grep -A $SLICESIZE "=$CRN&")
CRNLINES=$(echo "$SLICE" | grep -n "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | cut -d: -f1)
NEXTCRNLINE=$(echo $CRNLINES | cut -d' ' -f2)
TRIMMEDSLICE=$(echo "$SLICE" | sed ''${NEXTCRNLINE}',$d')
#echo "$TRIMMEDSLICE"

SUBJECTOUT=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")

TITLETOUT=$(echo "$TRIMMEDSLICE" | sed -n '7p' | sed 's/<[^>]\+>//g')

echo "$SUBJECTOUT"

echo "$TITLETOUT"

COURSESLOTS=$(echo "$TRIMMEDSLICE" | egrep -B1 -A7 " AM-| PM-" | sed 's/<[^>]\+>//g' | grep -v "\-\-")

#echo "$COURSESLOTS"

#SLOTS=$(echo "$TRIMMEDSLICE" | egrep -B 1 -A 7 " AM-| PM-" | sed 's/<[^>]\+>//g' | paste -sd " ")

COUNTER=1
while read p; do
	MODULO=$(( $COUNTER % 9 ))
	case $MODULO in
		1)	echo $p
			;;
		2)	echo $p
			;;
		8)	echo $p
			;;
		9)	echo $p
			;;

#		*)	echo "normal"
#			;;
	esac
	COUNTER=$(( $COUNTER + 1 ))
	#echo $p
done <<< "$COURSESLOTS"

#SLOTS=$(echo "$TRIMMEDSLICE" | egrep -B 1 -A 7 " AM-| PM-" | sed 's/<[^>]\+>//g' | paste -sd " ")

#NAMEOUT=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")

#DATEOUT=$(echo "$TRIMMEDSLICE" | egrep -B 2 ">Active<" | sed 's/<[^>]\+>//g' | paste -sd " ")


#echo "$NAMEOUT"
#echo "$SLOTOUT" 
#echo "$DATEOUT"