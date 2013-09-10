#!/bin/sh
CRN=$1
SLICESIZE=100
SLICE=$(cat 20130906.html | grep -A $SLICESIZE "=$CRN&")
CRNLINES=$(echo "$SLICE" | grep -n "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | cut -d: -f1)
NEXTCRNLINE=$(echo $CRNLINES | cut -d' ' -f2)
TRIMMEDSLICE=$(echo "$SLICE" | sed ''${NEXTCRNLINE}',$d')
#echo "$TRIMMEDSLICE"
NAMEOUT=$(echo "$TRIMMEDSLICE" | grep -A 4 "https://horizon.mcgill.ca/pban1/bwckschd.p_disp_listcrse?term_in=" | sed -n '1!p' | sed 's/<[^>]\+>//g' | paste -sd " ")
SLOTOUT=$(echo "$TRIMMEDSLICE" | egrep -B 1 " AM-| PM-" | sed 's/<[^>]\+>//g' | paste -sd " ")

echo "$NAMEOUT"
echo "$SLOTOUT" 
