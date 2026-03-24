@echo off
setlocal enableextensions EnableDelayedExpansion
for /f %%a in ('copy /Z "%~dpf0" nul') do set "CR=%%a"

:::: INTRODUCCION ::::
echo.
echo ###################################################### 
echo ######	Este es una secuencia de comandos para	######
echo ######	pooder realizar una descarga masiva de	######
echo ######	fichas tecnicas de forma automatizada.	######
echo ######################################################
echo.

:::: Condición de VPN
set /p "res=La VPN esta conectada? (s/n): "
echo.
if not %res%==s (
	echo Porfavor conecta la VPN de tu equipo para poder 
	echo habilitar las descargas y ejecuta de nuevo el programa
	echo. & echo Presiona cualquier tecla para aceptar & pause >nul
	exit
)

:::: Variables y condiciones iniciales ::::
set link=https://dagrs.berkeley.edu/sites/default/files/2020-01/
set ifile=STOCKS.txt

:::: Reinicia archivos temporales ::::
echo ...Reset de archivos temporales completado
if exist %cd%\FICHAS (
	rmdir /s /q %cd%\FICHAS
)
mkdir FICHAS

::::::	Se declara la lista TIPO 1 de stocks desde el archivo de texto	::::::
echo ...Leyendo stocks
set L_stocks=
set ns=0
for /f %%a in (%ifile%) do (
	set L_stocks=!L_stocks! %%a
	set /A ns+=1
)
echo. & echo Se detectaron %ns% stocks...

::::::	Descarga los archivos con los enlaces generados, ademas	::::::
::::::	los guarda en la carpeta "FICHAS" y captura el listado	::::::
set marco=__________________________________________...descargando
echo %marco%
set cont=1

for %%a in (%L_stocks%) do (

	for /f "tokens=1-4 delims=:.," %%a in ("!time!") do (
		set /a "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100")
		
	curl -s -o FICHAS/%%a.pdf %link%%%a
	set /A cont+=1

	for /f "tokens=1-4 delims=:.," %%a in ("!time!") do (
		set /a "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100")
		
	set /A durt=!end!-!start!						&:: centisegundos totales
	set /A "dur=!durt!*(!ns!-(!cont!-1))"
	set /A hrs=!dur!/360000							&::horas
	set /A "min=(!dur!-!hrs!*360000)/6000"			&::min
	set /A "seg=(!dur!-(!dur!/6000)*6000)/100"		&::segundos
	set /A "cns=!dur!-(!dur!/100)*100"				&::Centisegundos	
	<nul set /p "=Restan !hrs!hrs : !min!min : !seg! seg !CR!" <NUL
)
echo [########################################] 100%% COMPLETADO
echo. & echo !ns! Fichas tecnicas guardadas en la carpeta FICHAS