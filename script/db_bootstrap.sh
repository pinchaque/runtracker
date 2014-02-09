#!/bin/bash
# Script to set up postgres database

su -l postgres -c "psql -c \"create role furlong with login createdb password 'Unrl58@89xw'\""

su -l csmith cd ~/git/runtracker && rake db:create
