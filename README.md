# About

The purpose of this script is to take screenshots on La Poste website, given a number of Registered letter with recorded delivery (Lettre recommandée avec accusé de réception).

# Install

Ensure you have Ruby and Mozilla Firefox on your system.

Just run `bundle install` to install requirements.

# Run the script

Run the script by entering `bundle exec ruby LRAR.rb`

## Options

### Run the scrip with a csv file

`bundle exec ruby LRAR.rb -f lrar.csv`

### Run the scrip with the reference of a Registered letter with recorded delivery

`bundle exec ruby LRAR.rb -l 1A09676926720`

# Run the script automatically (Cron)

This line shows you how to run this script everyday, at 3:02 PM, considering the script is in /home/lrar/ directory

`15 2 * * * DISPLAY=:0 /home/lrar/LRAR.rb -d -f /home/lrar/LRAR/lrar.csv >> /home/lrar/LRAR/lrar.log`
