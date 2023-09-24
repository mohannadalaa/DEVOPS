#!/bin/bash

echo "generating env-config.js ..."

mkdir -p $scripts_path

# Recreate config file
rm -rf $scripts_path/env-config.js
touch $scripts_path/env-config.js

# Add assignment 
echo "window._env_ = {" >> $scripts_path/env-config.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}
  
  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >> $scripts_path/env-config.js
done < .env

echo "}" >> $scripts_path/env-config.js