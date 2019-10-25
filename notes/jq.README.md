## Number of lines, or rows in array

  jq '. | length'

## Project column from array

  jq '.[].column' data.json
