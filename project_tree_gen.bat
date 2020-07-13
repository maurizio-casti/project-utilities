@echo off

rem setlocal EnableDelayedExpansion

echo.

set proj_name=%1


rem ***********************************************
rem Verify syntax
if  "%proj_name%"=="" (
	echo.
	echo ******************************************************
	echo You should specify a Project Name
	echo Open a command shell, then type project_tree_gen ^<ProjectName^>
	echo ******************************************************
	echo.
	pause
	exit /B
	)

rem -- Main Folder
md %proj_name%

rem -- Developement documents
md %proj_name%\dev

rem -- Project related documents
md %proj_name%\doc

rem -- Flash Reopsitory
md %proj_name%\flash

rem -- SD Reopsitory
md %proj_name%\sd

rem -- Local Folder (ignored by GIT)
md %proj_name%\local

rem -- Simulation folder
md %proj_name%\sim
md %proj_name%\sim\hdl
md %proj_name%\sim\Vivado_wcfg

rem -- Sources folder
md %proj_name%\src
md %proj_name%\src\hdl
md %proj_name%\src\constrs
md %proj_name%\src\Vivado_bd
md %proj_name%\src\Vivado_ip
md %proj_name%\src\Vivado_if
md %proj_name%\src\Vivado_repo

rem -- Vivado project folder
md %proj_name%\Vivado



rem -- GIT .ignore file

echo # ignore all logs                                 >  %proj_name%\.gitignore
echo *.git                                             >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo #ignore latex auxillary files                     >> %proj_name%\.gitignore
echo *.aux                                             >> %proj_name%\.gitignore
echo *.log                                             >> %proj_name%\.gitignore
echo *.synctex.gz                                      >> %proj_name%\.gitignore
echo *.toc                                             >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # ignore stuff folders                            >> %proj_name%\.gitignore
echo mug                                               >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # ignore ZIP files                                >> %proj_name%\.gitignore
echo *.zip                                             >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # ignore Vivado subfolders                        >> %proj_name%\.gitignore
echo Vivado/*                                          >> %proj_name%\.gitignore
echo # but:                                            >> %proj_name%\.gitignore
echo # NOT xpr file                                    >> %proj_name%\.gitignore
echo !Vivado/*.xpr                                     >> %proj_name%\.gitignore
echo # NOT synthesis/simulation sources                >> %proj_name%\.gitignore
echo !Vivado/*.srcs                                    >> %proj_name%\.gitignore
echo # NOT simulation vaweforms conf.                  >> %proj_name%\.gitignore
echo !Vivado/*.wcfg                                    >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # Ignore Office temporary documents               >> %proj_name%\.gitignore
echo *~$*.*                                            >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # Ignore any files with BETA/TEMP/LOCAL/DRAFT tag >> %proj_name%\.gitignore
echo *BETA*                                            >> %proj_name%\.gitignore
echo *beta*                                            >> %proj_name%\.gitignore
echo *TEMP*                                            >> %proj_name%\.gitignore
echo *temp*                                            >> %proj_name%\.gitignore
echo *TMP*                                             >> %proj_name%\.gitignore
echo *tmp*                                             >> %proj_name%\.gitignore
echo *LOCAL*                                           >> %proj_name%\.gitignore
echo *local*                                           >> %proj_name%\.gitignore
echo *DRAFT*                                           >> %proj_name%\.gitignore
echo *draft*                                           >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # Vivado IP source subfolder:                     >> %proj_name%\.gitignore
echo src/Vivado_ip/**/*                                >> %proj_name%\.gitignore
echo !src/Vivado_ip/**/*.xci                           >> %proj_name%\.gitignore
echo.                                                  >> %proj_name%\.gitignore
echo # Vivado Block Diagram source subfolder:          >> %proj_name%\.gitignore
echo src/Vivado_bd/**/*.*                              >> %proj_name%\.gitignore
echo !src/Vivado_bd/**/*.bd                            >> %proj_name%\.gitignore
echo !src/Vivado_bd/*/synth/*.vhd                      >> %proj_name%\.gitignore
echo !src/Vivado_bd/*/hdl/*.vhd                        >> %proj_name%\.gitignore



rem -- MarkDown README.md file
echo # %proj_name%                                 >  %proj_name%\README.md