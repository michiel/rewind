function git_history {
  git log $filename | grep "Date: "
}

function first_commit {
  git_history | tail -1
}

function last_commit {
  git_history | head -1
}

function number_of_commits {
  git_history | wc -l
}
 
function number_of_authors {
  git log $filename | grep "^Author:" | sort | uniq | wc -l
}

function legible_output {
  # $2:   filename
  # $1:   lines of code
  # $3:   number of commits
  # $4:   number of authors
  # $5:   filetype
  # $8:   month (first)
  # $9:   date (first)
  # $11:  year (first)
  # $15:  month (last)
  # $16:  date (last)
  # $18:  year (last)
  awk '{print $2 "," $1 "," $3 "," $4 "," $5 "," $8 " " $9 " " $11 "," $15 " " $16 " " $18 }'
}

function csv_lines_for {
  for filename in $(find . -iname "*.$1"); do
    echo "`wc -l $filename` `number_of_commits` `number_of_authors` $1 `first_commit` `last_commit`" |
    legible_output |
    xargs echo
  done
}

function create_csv {
  echo "filename,lines of code,number of commits,number of authors,filetype,date of first commit,date of last commit"

  for argument in "$@"
  do
    csv_lines_for $argument
  done
}

cd $1
create_csv $@
cd -

