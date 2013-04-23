# 2013 - Kyriakos Terzopoulos
# This script automates a moodle cloning process
# It takes 2 parameters:
# a - source moodle
# b - target moodle
# Warning: This script assumes that the database name is the same as the moodle directory name
# Please make a server backup to be sure

# Variables
moodledir="/var/www/platform/"
moodledatadir="/var/"
dbpass="scr#@<26wO3e"

echo "**************"
echo "Cloning Moodle"
echo "**************"
echo
echo "SOURCE moodle (directory name only)?"
read sourcemoodle
echo "NEW moodle name (directory name only)?"
read targetmoodle

# Generate the moodledata name - and other variables

sourcemoodledata=$sourcemoodle"-data"
targetmoodledata=$targetmoodle"-data"
sourcedb=$sourcemoodle
targetdb=$targetmoodle


# Clone moodle folder
echo "Copying $moodledir$sourcemoodle to $moodledir$targetmoodle (this may take some time)"
cp -r -a $moodledir$sourcemoodle $moodledir$targetmoodle

# Clone moodledata folder
echo "Copying $moodledatadir$sourcemoodledata to $moodledatadir$targetmoodledata (this may take some time)"
cp -r -a $moodledatadir$sourcemoodledata $moodledatadir$targetmoodledata

# Clone database
echo "Cloning database $sourcedb to $targetdb"
mysql -h localhost -u root -p$dbpass -e "create database \`$targetdb\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci"
mysqldump -h localhost --add-drop-table -u root -p$dbpass $sourcedb | mysql -h localhost -u root -p$dbpass $targetdb

#Change config files - This will replace all occurences of the source moodle name
sed -i 's/'$sourcemoodle'/'$targetmoodle'/g' $moodledir$targetmoodle/config.php
echo "Done!"
