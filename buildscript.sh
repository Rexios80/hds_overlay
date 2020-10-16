pkg package.json --out-path output
platypus macos-platypus-script output/HDS-Overlay-macos.app -y -R -f output/HDS-Overlay-macos -i macos-icon.icns -a "HDS-Overlay-macos"
rm output/HDS-Overlay-macos
./macossignscript.sh