#!/bin/bash
#Pulls Meaningful Use oriented events from Audit Logs
#Directions: Place this file into the directory of the Audit Logs that you would like the results for. Make sure to rename the full log to: pratice.currentdate_full.csv. Using Terminal on OSX use the cd function to cd to the directory. Ex. /Users/yourusername/Downloads/filenameofstoredlogs/ Once you are in the directory use the bash function to execute this script. Ex. bash ./AuditLogFriend
echo NOTE: The filename is required to be formatted as: practice.currentdate_full.csv . The script will also need to be run from the directory where the Audit Log is stored.
echo What is the practice URL Prefix?
read -r practice
echo Please choose one of the options:
OPTIONS="AllowPatientsToIntramail MUSETTING drugDrug rxFormularyCheck All Exit"

function APTI() {
  echo Running script gathering entries with AllowPatientsToIntramail.
    cat ./*full.csv | pv -p ./*full.csv | parallel --block 100M --no-notice --pipe awk '/allowPatientsToIntramail/' > ./"$practice".allowPatientsToIntramail.csv
  echo  Number of total entries in "$practice".allowPatientsToIntramail.csv
    wc -l "$practice".allowPatientsToIntramail.csv
  echo allowPatientsToIntramail False entries:
    grep -c 'allowPatientsToIntramail=>false;' "$practice".allowPatientsToIntramail.csv
  echo allowPatientsToIntramail True entries:
    grep -c 'allowPatientsToIntramail=>true;' "$practice".allowPatientsToIntramail.csv
  echo Entries found for allowPatientsToIntramail that may need additional review:
    grep --color -E '""allowPatientsToIntramail""' "$practice".allowPatientsToIntramail.csv
    grep --color -E '"allowPatientsToIntramail' "$practice".allowPatientsToIntramail.csv
  echo Done.
}

function MSET() {
  echo Running script gathering entries with MU_SETTING.
    cat ./*full.csv | pv -p ./*full.csv | parallel --block 100M --no-notice --pipe awk '/MU_SETTING/' > ./"$practice".MU_SETTING.csv
  echo  Number of total entries in "$practice".MU_SETTING.csv
    wc -l "$practice".MU_SETTING.csv
  echo MU_SETTING_ENABLED entries:
    grep -c 'MU_SETTING_ENABLED' "$practice".MU_SETTING.csv
  echo MU_SETTING_DISABLED entries:
    grep -c 'MU_SETTING_DISABLED' "$practice".MU_SETTING.csv
  echo Entries found for MU_SETTING that may need additional review:
    grep --color -E 'MU_SETTING' "$practice".MU_SETTING.csv
  echo Done.
}

function DD() {
  echo Running script gathering entries with drugDrug.
    cat ./*full.csv | pv -p ./*full.csv | parallel --block 100M --no-notice --pipe awk '/drugDrug/' > ./"$practice".drugDrug.csv
  echo  Number of total entries in "$practice".drugDrug.csv
    wc -l "$practice".drugDrug.csv
  echo drugDrug OFF entries:
    grep -c 'drugDrugWarningLevel=>OFF;' "$practice".drugDrug.csv
  echo drugDrug CONTRAINDICATED entries:
    grep -c 'drugDrugWarningLevel=>CONTRAINDICATED;' "$practice".drugDrug.csv
  echo drugDrug UNDETERMINED entries:
    grep -c 'drugDrugWarningLevel=>UNDETERMINED;' "$practice".drugDrug.csv
  echo drugDrug MODERDATE entries:
    grep -c 'drugDrugWarningLevel=>MODERDATE;' "$practice".drugDrug.csv
  echo drugDrug SEVERE entries:
    grep -c 'drugDrugWarningLevel=>SEVERE;' "$practice".drugDrug.csv
  echo Entries found for drugDrugWarningLevel that may need additional review:
    grep --color -E '""drugDrugWarningLevel""' "$practice".drugDrug.csv
    grep --color -E '"drugDrugWarningLevel' "$practice".drugDrug.csv
  echo Done.
}

function RFC() {
  echo Running script gathering entries with rxFormularyCheck.
    cat ./*full.csv | pv -p ./*full.csv | parallel --block 100M --no-notice --pipe awk '/rxFormularyCheck/' > ./"$practice".rxFormularyCheck.csv
  echo  Number of total entries in "$practice".rxFormularyCheck.csv
    wc -l "$practice".rxFormularyCheck.csv
  echo rxFormularyCheckEnabled active entries:
    grep -c 'rxFormularyCheckEnabled=>true;' "$practice".rxFormularyCheck.csv
  echo rxFormularyCheckEnabled not active entries:
    grep -c 'rxFormularyCheckEnabled=>false;' "$practice".rxFormularyCheck.csv
  echo Entries found for rxFormularyCheck that may need additional review:
    grep --color -E '""rxFormularyCheckEnabled""' "$practice".rxFormularyCheck.csv
    grep --color -E '"rxFormularyCheckEnabled' "$practice".rxFormularyCheck.csv
    grep --color -E '""rxFormularyCheckDisabled""' "$practice".rxFormularyCheck.csv
    grep --color -E '"rxFormularyCheckDisabled' "$practice".rxFormularyCheck.csv
  echo Done.
}

select opt in $OPTIONS; do
if [ "$opt" = "AllowPatientsToIntramail" ]; then
  #Call function AllowPatientsToIntramail(APTI)
    APTI
elif [ "$opt" = "MUSETTING" ]; then
  #Call function MU_SETTING(MSET)
    MSET
elif [ "$opt" = "drugDrug" ]; then
  #Call function drugDrug(DD)
    DD
elif [ "$opt" = "rxFormularyCheck" ]; then
  #Call function rxFormularyCheck(RFC)
    RFC
elif [ "$opt" = "All" ]; then
	  APTI
  	MSET
  	DD
  	RFC
echo Done.

elif [ "$opt" = "Exit" ]; then
        exit
       clear
       echo Not a valid option. Please choose the following above.
      fi
   done
#Version 2 introduced the addition of user selection of single or multiple outputs.
#Version 3 introduced the addition of: rxForumlaryCheck and option to exit.
#Version 4 introduced the practice URL string passing to the files written.
#Version 5 added stability to the read function of the practice string by adding -r to reduce issues with backslash.
#Version 6 introduced word count to count the entries in the output csv.
#Version 7 was checked for errors against http://www.shellcheck.net/ per their recommendations the addtion of quotes around the varible $practice was added to increase stability.
#Version 8 added the ability to use parallel for both awk and wc -l.REQUIRES DEPENDENCIES! https://www.0xcb0.com/2011/10/19/running-parallel-bash-tasks-on-os-x/
#Version 9 added Pipe Viewer REQUIRES DEPENDCIES http://www.ivarch.com/programs/pv.shtml
#Version 10 introduced the options to view the count of events positive of negative.
#Version 11 refined additions.

#O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
#;login: The USENIX Magazine, February 2011:42-47.
