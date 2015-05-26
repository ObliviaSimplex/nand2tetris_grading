Here are the marking scripts for 2121.  Students' submissions have been removed -- get your students submissions from Moodle for testing!

Before using for the first lab of the term:
 - replace list.csv with the current class-list from Moodle:
   - Click on 'View gradebook' in the menubar at the left of the main Moodle page
   - In the drop-down at top left, choose 'Plain text file' under 'Export'
   - Click 'Select all/none' near the bottom of the next page so that NONE of the check-boxes are selected
   - Click the 'Download' button
   - Overwrite the existing list.csv with the downloaded class list

Example usage, for marking nand2tetris project 1:
 - Remove any existing files in the download/ directory
 - Get the students' submissions from moodle
   - Click on the title on the main moodle page
   - Click on View/grade all submissions
   - From the drop-down at the top left, choose 'Download all submissions'
 - Unzip the submissions into the download directory:
   unzip -d download <name of downloaded zipfile>
   This will fill the download/ directory with the (likely still zipped) student submissions
 - Run the 'do-everything' script: ./all.sh <lab_number>
   - lab_number can be any of: 1, 2a, 2b, 3, 4, 5
   - see 'Detailed marking script usage', below, for the steps this script runs.
 - Manually review the file marks/<lab_number>.moodle.csv
   - give part-marks as appropriate for people whose submissions failed test cases
   - Make sure to update the 'total' and 'feedback' fields -- these will be used by moodle
 - Import marks/<lab_number>.moodle.csv into moodle
   - Click on 'View gradebook' in the menubar at the left of the main Moodle page
   - In the drop-down at top left, choose 'CSV file' under 'Import'
   - Select the marks/<lab_number>.moodle.csv file to upload
   - Click 'Upload grades', and check that the detected columns make sense
   - Drop-downs:
     - Map from: Email address
     - Map to: Email address
     - total: Assignment Lab <lab_number>
     - feedback: Feedback for Assignment Lab <lab_number>
   - Click 'Upload grades', then continue

Detailed marking script usage (project 1 used as an example):
 - Ensure you have an up-to-date list.csv, and have unzipped the submissions into download/
 - Extract the downloaded files from Moodle into student-directories under working/, and
   remove unexpected files (e.g. don't let them supply their own .tst files ;)), flatten directories, add
   the correct .tst files from the '1' directory for Project 1
   ./prep.sh 1
 - Run TECS (i.e., the nand2tetris simulator) using the test files in the '1' directory, and
   saves the results to marks/1.marks.csv
   ./grade.sh 1
 - Do any hand-edits necessary in marks/1.marks.csv (part marks, weighting of different tests, etc.)
 - Add student e-mails to the output csv for upload to Moodle. This will output the file marks/1.moodle.csv
   ./moodlerize.sh 1

Original scripts by Aaron Atwater (atwater@cs.dal.ca)
Updated by Owen Davison (odavison@cs.dal.ca)
