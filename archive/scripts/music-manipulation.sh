# while IFS= read -r file; do echo $file; mv "$file" paradise ; done < "paradise.txt"

# modify this for how many files you're doing
ls -tr1 *.zip > file-list.txt

echo "making directory 'zipfiles'"
mkdir zipfiles

# move zip files into temp dir
while IFS= read -r file; do
  mv -vi "$file" zipfiles 
done < "file-list.txt"

pushd zipfiles

for zipfile in *.zip; do
  filedir="${zipfile%.zip}"
  echo unzip "$zipfile" -d "$filedir"
  unzip "$zipfile" -d "$filedir"
done


for album in */; do
  artist="${album% - *}"
  mkdir -p "$artist"
  mv -vi "$album" "$artist"
done

rsync -a --progress --ignore-existing --exclude="*.zip" * ~/Music/flac

popd

rm -rv zipfiles
