#!/bin/sh

ping=$(ping -c 1 google.com | sed -n 's/.*time=\([0-9]*\)\..*/\1/p')
echo "$ping"
