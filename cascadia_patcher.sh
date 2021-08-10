#!/bin/bash
CASCADIAVERS=`curl -L 'https://github.com/microsoft/cascadia-code/releases/latest' | grep CascadiaCode | sed 's!\(.*/microsoft/cascadia-code/releases/download/\([^"]*\).*\|.*span.*\)!\2!'`
echo Downloading ${CASCADIAVERS}
curl -L https://github.com/microsoft/cascadia-code/releases/download/${CASCADIAVERS}  -O
unzip CascadiaCode*.zip
rm -rf otf
rm -rf woff2
rm CascadiaCode*.zip
mkdir ttf/variable
mv ttf/*PL*.ttf ttf/variable
cd ttf/static
mkdir -p {mono,dynamic}/patched
mv CascadiaMonoPL* mono/
mv CascadiaCodePL* dynamic/
rm Cascadia*
docker run --rm -v ${PWD}/dynamic:/in -v ${PWD}/dynamic/patched:/out nerdfonts/patcher -c --careful
docker run --rm -v ${PWD}/mono:/in -v ${PWD}/mono/patched:/out nerdfonts/patcher -c -s --careful
# /usr/bin/env ruby <<-EORUBY
#     Dir.glob("dynamic/patched/*.ttf") do |f|
#         File.rename(f, f.gsub(' ', '').sub('CaskaydiaCovePL', 'CascadiaCodePL-').sub('NerdFontComplete', ''))
#     end
#     Dir.glob("mono/patched/*.ttf") do |f|
#         File.rename(f, f.gsub(' ', '').sub('PL', 'PL-').sub('NerdFontCompleteMono', ''))
#     end
# EORUBY
for f in dynamic/patched/*.ttf
do
    new_file=${f// }
    new_file=${new_file/CaskaydiaCovePL/Kascadia-}
    new_file=${new_file/NerdFontComplete/}
    mv "$f" "$new_file"
done 
for f in mono/patched/*.ttf
do
    new_file=${f// }
    new_file=${new_file/CascadiaMonoPL/KascadiaMono-}
    new_file=${new_file/NerdFontCompleteMono/}
    mv "$f" "$new_file"
done 
cd ../..
for f in ttf/variable/*.ttf
do
    new_file=${f/CascadiaCodePL/Kascadia}
    new_file=${new_file/CascadiaMonoPL/KascadiaMono}
    mv "$f" "$new_file"
done 
mkdir fonts
mv ttf/variable/* fonts/
mv ttf/static/*/patched/* fonts/
filename=(${CASCADIAVERS#v*/})
zip Kascadia-$1.zip fonts/*
