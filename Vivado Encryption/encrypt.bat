@echo off

if exist tmp rd tmp /q /s

setlocal EnableDelayedExpansion

echo.

set file=%1
set file_name=%file:~0,-4%
set file_ext=%file:~-3%

rem ***********************************************
rem Verify ZIP
if  "%file%"=="" (
	echo.
	echo ****************************************************************
	echo You should specify a .zip file containing the IP to be encrypted
	echo Open a command shell, then type encrypt ^<namefile.zip^>
	echo ****************************************************************
	echo.
	pause
	exit /B
	)

if not "%file:~-4%"==".zip" (
	echo.
	echo ****************************************************************
	echo ERROR: input file MUST be a .zip file
	echo You should specify a .zip file containing the IP to be encrypted
	echo ****************************************************************
	exit /B
	)


rem ***********************************************	
rem Verify if _encrypted exixts
if not exist %file_name%_encrypted.zip goto expand_archive
:ask_overwrite
echo.
echo ***************************************************************************************************************
echo|set /p="WARNING: %file_name%_encrypted.zip already exists. Overwrite? " 
set /P overwrite=" (Y/N) "
if /I %overwrite%==Y (
	del %file_name%_encrypted.zip
	goto expand_archive
	)
if /I %overwrite%==N (
	echo.
	echo Ok, your %file_name%_encrypted.zip is preserved.
	echo.
	goto :eof
)

echo. 
echo WARNING: echo You wrote %overwrite%, but you should type Y or N 
echo.
goto ask_overwrite

: expand_archive
echo. 
echo I'm extracting compressed file %file% in tmp\expanded_archive
call powershell expand-archive %file% tmp\expanded_archive\


rem ***********************************************
: verify_vhd_exist
set all_vhd_encypted=SKIP
where /q /r "tmp\expanded_archive" "*.vhd" && goto verify_vhd_keyfile || goto verify_ver_exist

rem ***********************************************
: verify_vhd_keyfile
set all_vhd_encypted=TBV
echo. 
echo I've found VHDL files to encrypt...
if exist keyfile_vhd.txt (
	echo ...and also "keyfile_vhd.txt", that is the mandatory KeyFile used to encrypt.
	goto write_keyfile_vhd_end
	)
: ask_default_kf_vhd
echo ...but I cannot find "keyfile_ver.txt", that is the mandatory KeyFile used to encrypt.
echo|set /p="Would you like me to create a default keyfile_vhd.txt file? "
set /P default_kf_vhd=" (Y/N) "
if /I %default_kf_vhd%==Y ( 
	goto write_keyfile_vhd
	)
if /I %default_kf_vhd%==N (
	echo Remember: KeyFile keyfile_vhd.txt is mandatory. Please provide.
	echo.
	goto write_keyfile_vhd_end 
	)
echo. 
echo WARNING: echo You wrote %default_kf_vhd%, but you should type Y or N 
echo.
goto ask_default_kf_vhd

: write_keyfile_vhd
echo `protect version = 2 >  keyfile_vhd.txt
echo `protect encrypt_agent = "XILINX">> keyfile_vhd.txt
echo `protect encrypt_agent_info = "Xilinx Encryption Tool 2019">> keyfile_vhd.txt
echo `protect begin_commonblock>> keyfile_vhd.txt
echo `protect control error_handling = "delegated">> keyfile_vhd.txt
echo `protect control runtime_visibility = "delegated">> keyfile_vhd.txt
echo `protect control child_visibility = "delegated">> keyfile_vhd.txt
echo `protect control decryption=(activity==simulation) ? "false" : "true">> keyfile_vhd.txt
echo `protect end_commonblock>> keyfile_vhd.txt
echo `protect begin_toolblock>> keyfile_vhd.txt
echo `protect rights_digest_method="sha256">> keyfile_vhd.txt
echo `protect key_keyowner = "Xilinx", key_keyname= "xilinxt_2019_02", key_method = "rsa", key_public_key>> keyfile_vhd.txt
echo MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomd6zWDwBd1KlGuxqETx>> keyfile_vhd.txt
echo OJgcOsq+X0CKG9FLIvBVNZjAyELSE09G5PP+XtPLLuutaUxbt6S6rPhPrX3UGymz>> keyfile_vhd.txt
echo DVKVrfbK4LtMV8ie2nC6bPOMn8UnWe3N6KKkkR5BB9Ri2+uu1xzWPf570i8/5zaN>> keyfile_vhd.txt
echo Am4Bd+sYQ1v8z/rLd2dTyDo/BS+uDNvmXWdKT4h/tj5K2wNP5kt2oPzgevh6RHPI>> keyfile_vhd.txt
echo 5CWAREf1AOJodEkKG3D0XGjhjUGOl2P+QH5MJE3uKTa7gwCJuXMozPY2Oz4sSQ8D>> keyfile_vhd.txt
echo PPi6+A6pa2eMOEIJBXaghpZgAU9FhLUIav4Ob8Bwk/ZzAT442n6ttOJVxq+mfY7E>> keyfile_vhd.txt
echo pQIDAQAB>> keyfile_vhd.txt
echo `protect control xilinx_configuration_visible = "false">> keyfile_vhd.txt
echo `protect control xilinx_enable_modification = "false">> keyfile_vhd.txt
echo `protect control xilinx_enable_probing = "false">> keyfile_vhd.txt
echo `protect control xilinx_enable_netlist_export = "false">> keyfile_vhd.txt
echo `protect control xilinx_enable_bitstream = "false">> keyfile_vhd.txt
echo `protect control xilinx_schematic_visibility = "false">> keyfile_vhd.txt
echo `protect control decryption=(xilinx_activity==simulation) ? "false" : "true">> keyfile_vhd.txt
echo `protect end_toolblock = "">> keyfile_vhd.txt

echo keyfile_vhd.txt wrote.
echo.
: write_keyfile_vhd_end



rem ***********************************************
: verify_ver_exist
set all_ver_encypted=SKIP
where /q /r "tmp\expanded_archive" "*.v" && goto verify_ver_keyfile || goto encrypt

rem ***********************************************
: verify_ver_keyfile
set all_ver_encypted=TBV
echo. 
echo I've found Verilog files to encrypt...
if exist keyfile_ver.txt (
	echo ...and also "keyfile_ver.txt", that is the mandatory KeyFile used to encrypt.
	goto write_keyfile_ver_end
	)
: ask_default_kf_ver
echo ...but I cannot find "keyfile_ver.txt", that is the mandatory KeyFile used to encrypt.
echo|set /p="Would you like me to create a default keyfile_ver.txt file? "
set /P default_kf_ver=" (Y/N) "
if /I %default_kf_ver%==Y ( 
	goto write_keyfile_ver
	)
if /I %default_kf_ver%==N (
	echo Remember: KeyFile keyfile_ver.txt is mandatory. Please provide.
	echo.
	goto write_keyfile_ver_end 
	)
echo. 
echo WARNING: echo You wrote %default_kf_ver%, but you should type Y or N 
echo.
goto ask_default_kf_ver

: write_keyfile_ver
echo `pragma protect version = 2 >  keyfile_ver.txt
echo `pragma protect encrypt_agent = "XILINX">> keyfile_ver.txt
echo `pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019">> keyfile_ver.txt
echo `pragma protect begin_commonblock>> keyfile_ver.txt
echo `pragma protect control error_handling = "delegated">> keyfile_ver.txt
echo `pragma protect control runtime_visibility = "delegated">> keyfile_ver.txt
echo `pragma protect control child_visibility = "delegated">> keyfile_ver.txt
echo `pragma protect control decryption=(activity==simulation) ? "false" : "true">> keyfile_ver.txt
echo `pragma protect end_commonblock>> keyfile_ver.txt
echo `pragma protect begin_toolblock>> keyfile_ver.txt
echo `pragma protect rights_digest_method="sha256">> keyfile_ver.txt
echo `pragma protect key_keyowner = "Xilinx", key_keyname= "xilinxt_2019_02", key_method = "rsa", key_public_key>> keyfile_ver.txt
echo MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomd6zWDwBd1KlGuxqETx>> keyfile_ver.txt
echo OJgcOsq+X0CKG9FLIvBVNZjAyELSE09G5PP+XtPLLuutaUxbt6S6rPhPrX3UGymz>> keyfile_ver.txt
echo DVKVrfbK4LtMV8ie2nC6bPOMn8UnWe3N6KKkkR5BB9Ri2+uu1xzWPf570i8/5zaN>> keyfile_ver.txt
echo Am4Bd+sYQ1v8z/rLd2dTyDo/BS+uDNvmXWdKT4h/tj5K2wNP5kt2oPzgevh6RHPI>> keyfile_ver.txt
echo 5CWAREf1AOJodEkKG3D0XGjhjUGOl2P+QH5MJE3uKTa7gwCJuXMozPY2Oz4sSQ8D>> keyfile_ver.txt
echo PPi6+A6pa2eMOEIJBXaghpZgAU9FhLUIav4Ob8Bwk/ZzAT442n6ttOJVxq+mfY7E>> keyfile_ver.txt
echo pQIDAQAB>> keyfile_ver.txt
echo `pragma protect control xilinx_configuration_visible = "false">> keyfile_ver.txt
echo `pragma protect control xilinx_enable_modification = "false">> keyfile_ver.txt
echo `pragma protect control xilinx_enable_probing = "false">> keyfile_ver.txt
echo `pragma protect control xilinx_enable_netlist_export = "false">> keyfile_ver.txt
echo `pragma protect control xilinx_enable_bitstream = "false">> keyfile_ver.txt
echo `pragma protect control xilinx_schematic_visibility="false">> keyfile_ver.txt
echo `pragma protect control decryption=(xilinx_activity==simulation) ? "false" : "true">> keyfile_ver.txt
echo `pragma protect end_toolblock = "">> keyfile_ver.txt

echo keyfile_ver.txt wrote.
echo.
: write_keyfile_ver_end
	

	

rem ***********************************************	
: encrypt

echo encrypt -lang vhdl    -key keyfile_vhd.txt [lindex $argv] > tmp\temp_encrypt_vhd.tcl
echo encrypt -lang verilog -key keyfile_ver.txt [lindex $argv] > tmp\temp_encrypt_ver.tcl

for /R tmp\expanded_archive %%g in (*.vhd) do echo|set /p=%%g >> tmp\tcl_vhd_arg.txt 
for /R tmp\expanded_archive %%h in (*.v  ) do echo|set /p=%%h >> tmp\tcl_ver_arg.txt 


if exist tmp\tcl_vhd_arg.txt (
	for /F "tokens=*" %%n in (tmp\tcl_vhd_arg.txt) do (
	call vivado -nolog -nojournal -mode batch -source tmp\temp_encrypt_vhd.tcl -tclargs %%n
	)
)

if exist tmp\tcl_ver_arg.txt (
	for /F "tokens=*" %%o in (tmp\tcl_ver_arg.txt) do (
	call vivado -nolog -nojournal -mode batch -source tmp\temp_encrypt_ver.tcl -tclargs %%o
	)
)


: verify_if_encrypted
echo.
echo Verifing that .vhd and .v files inside %file_name%_encrypted.zip file are really encrypted
echo.

for /R tmp\expanded_archive %%g in (*.vhd) do (
echo Verifing %%g
set /a counter=0
for /f ^"usebackq^ eol^=^ delims^=^" %%a in (%%g) do (
        if "!counter!"=="0" (
			if "%%a"=="`protect begin_protected" (
				echo --- OK
				echo.
				) else (
				echo ************************************************************************
				echo --- ERROR in %%g !!! ---
				echo ************************************************************************
				echo.
				echo.
				set all_vhd_encypted=ERROR
				)
			)
        set /a counter+=1
)
)
echo.

for /R tmp\expanded_archive %%g in (*.v) do (
echo Verifing %%g
set /a counter=0
for /f ^"usebackq^ eol^=^ delims^=^" %%a in (%%g) do (
        if "!counter!"=="0" (
			if "%%a"=="`pragma protect begin_protected" (
				echo --- OK
				echo.
				) else (
				echo ************************************************************************
				echo --- ERROR in %%g !!! ---
				echo ************************************************************************
				echo.
				echo.
				set all_ver_encypted=ERROR
				)
			)
        set /a counter+=1
)
)
echo.



echo.
echo Results:
	echo.
set encrypt_errors==NO
: verify_vhd_result
if "%all_vhd_encypted%"=="SKIP" goto verify_ver_result
	)

if "%all_vhd_encypted%"=="ERROR" (
	echo Error in encrypting VHDL file ^(s^)
	set encrypt_errors=YES
	) 

if "%all_vhd_encypted%"=="TBV" echo All VHDL files have been encrypted.


: verify_ver_result
if "%all_ver_encypted%"=="SKIP" goto create_zip
	)

if "%all_ver_encypted%"=="ERROR" (
	echo Error in encrypting Verilog file ^(s^)
	set encrypt_errors=YES
	) 

if "%all_ver_encypted%"=="TBV" echo All Verilog files have been encrypted.


: create_zip

if "%encrypt_errors%"=="YES" (
	echo.
	echo please verify in tmp\expanded_archive folder the above indicated files with errors.
	echo.
	pause
	goto :eof
	)
	
echo.
echo.
call powershell compress-archive tmp\expanded_archive\* %file_name%_encrypted.zip
echo Compressed file %file_name%_encrypted.zip from %file% has been created
echo.


echo All temp files have been deleted.
rem pause
rd tmp /q /s

echo.
echo.
echo Your IP is now encrypted in %file_name%_encrypted.zip
echo.





rem : ask_if_encrypted
rem echo Please verify that .vhd and .v files inside %file_name%_encrypted.zip file are really encrypted
rem echo.
rem echo.
rem %SystemRoot%\explorer.exe "%file_name%_encrypted.zip"

