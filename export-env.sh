#!/bin/bash
# Check if .env file exists
if [ -f .env ]; then
  # Read .env line by line
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comment
    [[ $line =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue

    # Split line into key and value
    if [[ $line =~ ^([^=]+)=(.*)$ ]]; then
      key=${BASH_REMATCH[1]}
      value=${BASH_REMATCH[2]}

      # Remove whitespace and any newlines
      key=$(echo -n "$key" | tr -d ' \n\r')
      value=$(echo -n "$value" | tr -d '\n\r')

      # Export if key and value are not empty
      if [ -n "$key" ] && [ -n "$value" ]; then
        export "$key=$value"
      fi
    fi
  done < .env
else
  echo ".env file not found!"
  exit 1
fi