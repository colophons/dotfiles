#! /bin/sh
infile="$HOME/activerepo.txt"
pushd "$HOME"
while IFS= read -r line
do
  printf "################################\n"
  printf "checking $line\n"
  printf "################################\n"
  pushd $line
  git status
  popd
done <"$infile"
popd
