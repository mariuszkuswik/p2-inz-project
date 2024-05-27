#!/bin/bash

# List of MongoDB hosts
hosts=("mongo1:27017" "mongo2:27018" "mongo3:27019")

# Iterate over hosts to find a working one
for host in "${hosts[@]}"; do
  data=$(mongosh --quiet --eval 'db.mydatabase.find().toArray()' --host $host)
  if [[ $? -eq 0 ]]; then
    break
  fi
done

# Parse JSON to HTML
html_content=$(echo "$data" | jq -r '
  "<!DOCTYPE html>
  <html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>MongoDB Data Display</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        background-color: #f4f4f4;
      }
      h1 {
        color: #333;
      }
      ul {
        list-style-type: none;
      }
    </style>
  </head>
  <body>
    <h1>MongoDB Data</h1>
    <ul>" +
    (map("<li>\(.name)</li>") | join("")) +
  "</ul>
  </body>
  </html>"
')

# Save HTML to file
echo "$html_content" > /usr/share/nginx/html/index.html

