# while IFS= read -r file; do echo $file; mv "$file" paradise ; done < "paradise.txt"

# modify this for how many files you're doing
ls -tr1 *.zip > file-list.txt

echo "making directory 'zipfiles'"
mkdir zipfiles

# move zip files into temp dir
while IFS= read -r file; do
  mv -vi "$file" zipfiles 
done < "file-list.txt"

cd zipfiles

for zipfile in *.zip; do
  filedir="$HOME/Printing/stl/${zipfile%.zip}"
  mkdir -p "$filedir"
  echo unzip "$zipfile" -d "$filedir"
  unzip "$zipfile" -d "$filedir"
done

cd ../

rm -rf zipfiles
rm file-list.txt
