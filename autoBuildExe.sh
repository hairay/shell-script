#!/bin/sh

mkdir -p output

export COUNTER=0

for filename in ./*.fw; do
	if test -e $filename ; then
		COUNTER=$((COUNTER+1))
	fi	
done

if test -d ./files ; then
	cd files
	tar -czvf ../files.tar.gz .
	cd ..
fi

for filename in ./*.axf; do
	if test -e $filename ; then
		rm ./source -rf
		mkdir -p ./source/root
		mv $filename ./source/root
		cd source
		tar -czvf ../$filename.tar.gz .
		cd ..
		rm ./source -rf
	fi	
done

for filename in ./*.sh; do
	if test -e $filename ; then
		./fw/fwmaker $filename $filename.fw 0000 37 X1
		rm $filename
		cp $filename.fw ./output/
		COUNTER=$((COUNTER+1))
	fi
done

for filename in ./*.tar.gz; do
	if test -e $filename ; then
		./fw/fwmaker $filename $filename.fw 0000 38 X1
		rm $filename
		cp $filename.fw ./output/
		COUNTER=$((COUNTER+1))
	fi
done

if [ $COUNTER -eq 0 ]; then
	echo "without any input"
	return 0
fi

if [ $COUNTER -gt 1 ]; then
	echo merge $COUNTER
	rm -f all.bin oldAll.bin
	touch all.bin
	for filename in ./*.fw; do
		if test -e $filename ; then
			mv all.bin oldAll.bin
			cat oldAll.bin $filename > all.bin	
			rm $filename oldAll.bin	
		fi
	done
	./fw/fwmaker all.bin all.fw 10000 13 X1
	rm all.bin
fi

for filename in ./*.fw; do
	if test -e $filename ; then
		./resetsetting $filename ./fw/setting.ini 
		./7-Zip/7zz a ./fw.7z $filename ./fw/Download7800.exe ./fw/setting.ini
		cat SfxSetup.exe config.txt fw.7z > ./output/$filename.exe			
		rm fw.7z $filename
	fi
done