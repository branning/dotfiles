
# ye olde toole shoppe
library='
  info
  '
for tool in $library
do
  here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")
  source "${here}/../library/${tool}.sh"
done

# once more, with feeling
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

info 'why hello buddy'
