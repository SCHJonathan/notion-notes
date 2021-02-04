#!/bin/bash

CURRENT_DIR=$(pwd)
UPDATE_NOTE_PREFIX=$1
NOTES_DIR="${CURRENT_DIR}/notes"
CLEAN_HOOK="${CURRENT_DIR}/script/clean_hook.py"

pushd "$NOTES_DIR" || exit
# loop through current directory list all the notes subject
# store the matched notes directories

MATCHED=()
echo "-------- Notes Dir --------"
for d in *; do
	echo "$d"
	# shellcheck disable=SC2053
	if [[ $d == $UPDATE_NOTE_PREFIX* ]] ;
	then
		MATCHED+=("$d")
	fi
done
echo "---------------------------"

# print all the matched notes to user
printf "\nMatched:\n"
for matched in "${MATCHED[@]}"
do
   echo "$matched"
done

# do the reformat and refactor by calling a python script
reformat_markdown () {
	MATCHED_ZIP=()
	for matched in "${MATCHED[@]}"
	do
		if [[ $matched == *.zip ]] ;
		then
			MATCHED_ZIP+=("$matched")
		else
			rm -r "$matched"
		fi
	done

	for matched in "${MATCHED_ZIP[@]}"
	do
		UNZIP_FOLDER_NAME="${matched%.*}"
		unzip "$matched" -d "$UNZIP_FOLDER_NAME"
		python3 "$CLEAN_HOOK" "$UNZIP_FOLDER_NAME"
		rm "$matched"
	done
}


# interactive prompt for security
while true; do
    read -rp "Is matched notes within your expectation?" yn
    case $yn in
        [Yy]* ) reformat_markdown; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
