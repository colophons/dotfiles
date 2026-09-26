#! /bin/sh

# Shell script template

print_error_and_die() {
  errmessage="$@"
  echo -"\e[31m##[error]$errmessage\e[0m" >&2
  exit 1
}

info() {
  # print blue
  msg="$@"
  echo "\e[34m$msg\e[0m"
}

yellow() {
  msg="$@"
  echo "\e[33m$msg\e[0m"
}

usage() {
  info "$0 : watch some files, and run a command when any change."
  info "-h : print usage information"
  info "-c : command to run"
  info "-f : files to watch"
}

# parameters expecting an argument are followed by :
# flags have no :
FILES=
CMD=
OPSTRING=":hc:f:"
while getopts "$OPSTRING" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    c)
      CMD="$OPTARG"
      ;;
    f)
      FILES="$OPTARG"
      ;;
    \?)
      usage
      print_error_and_die "Unknown option: -$OPTARG"
      ;;
    :)
      usage
      print_error_and_die "Option -$OPTARG requires an argument."
      ;;
  esac
done

echo "
inotifywait -q -m -e modify $FILES | while read DIRECTORY EVENT FILE; do
  sh -c '$CMD'
done
"
inotifywait -q -m -e modify $FILES | while read DIRECTORY EVENT FILE; do
  sh -c "$CMD"
done
