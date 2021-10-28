
pushd "%~dp0"
md output

Set COUNTER=0

for %%F in (*.fw) do (		
	set /A COUNTER=COUNTER+1
)

if exist files (
	cd files
	"..\7-Zip\7z" a ../files.tar .
	cd ..
	gzip -9 files.tar
)

for %%F in (*.pipe) do (
    rmdir /S /Q .\source	
	mkdir .\source
    mkdir .\source\opt\other\pipe    	   
    move %%F .\source\opt\other\pipe    
    cd source
	"..\7-Zip\7z" a ../%%F.tar .    
    cd ..
	gzip -9 %%F.tar
    rmdir /S /Q .\source
)

for %%F in (*.axf) do (
    rmdir /S /Q .\source	
	mkdir .\source
    mkdir .\source\root    	   
    move %%F .\source\root   
    cd source
	"..\7-Zip\7z" a ../%%F.tar .    
    cd ..
	gzip -9 %%F.tar
    rmdir /S /Q .\source
)

for %%F in (NVRAM.*) do (
    rmdir /S /Q .\source	
	mkdir .\source
    mkdir .\source\opt
    mkdir .\source\opt\setting	    
    move %%F .\source\opt\setting    
    cd source
    "..\7-Zip\7z" a ../%%F.tar .
    cd ..
	gzip -9 %%F.tar
    rmdir /S /Q .\source
)

for %%F in (*.sh) do (	
	.\fw\FwMaker4230.exe %%F %%F.fw 0000 37 X1
    del %%F
    copy %%F.fw .\output\	
	set /A COUNTER=COUNTER+1  
)

for %%F in (*.tar.gz) do (	
	.\fw\FwMaker4230.exe %%F %%F.fw 0000 38 X1
    del %%F	
    copy %%F.fw .\output\
	set /A COUNTER=COUNTER+1
)

IF %COUNTER% == 0 goto BUILD_EXIT
IF %COUNTER% == 1 goto BUILD_EXE
del all.bin oldAll.bin
touch all.bin
for %%F in (*.fw) do (	
	ren all.bin oldAll.bin
	copy /b oldAll.bin + %%F all.bin	
	del %%F oldAll.bin	
)
.\fw\FwMaker4230.exe all.bin all.fw 10000 13 X1
del all.bin

:BUILD_EXE
for %%F in (*.ld, *.fw) do (		
	ResetSetting.exe %%F ./fw/setting.ini
	.\7-Zip\7z a .\fw\fw.7z .\%%F .\fw\Download7800.exe .\fw\setting.ini
	copy /b SfxSetup.exe + config.txt + .\fw\fw.7z .\output\%%F.exe	
	del .\fw\fw.7z %%F
)
:BUILD_EXIT
popd