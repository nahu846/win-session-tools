@ECHO OFF
setlocal enabledelayedexpansion
ECHO [1mAdministrador de sesiones[0m 

set "file=%~dp0%tabla.csv"
call :main

pause

exit /b %errorlevel%

:main

	echo *************************************************************
	echo *[107m[4m[30m OPCIONES:[0m[107m[30m                                                 [0m*
	echo *[107m[30m   (1) Ver listado de usuarios por equipo.                 [0m*
	echo *[107m[30m   (2) Cerrar sesiones de usuario desconectadas.           [0m*
	echo *[107m[30m   (3) Eliminar perfiles de usuario locales.               [0m*
	echo *[107m[30m   (4) Apagar maquinas.                                    [0m*
	echo *[107m[30m   (5) Salir.                                              [0m*
	echo *************************************************************
	
	set /p opciones= Ingrese un valor numerico ( 1, 2, 3, 4, 5 ):

	if %opciones% leq 4 (
		if %opciones% geq 1 (
			call :readfile
			call :saveRead
			call :getAllWS

			pause
			cls
			call :main
		)

	)
	if %opciones% == 5 (
		echo Terminando programa...
		pause
		exit /b 0
	) else (
		cls
		echo Por favor ingrese un valor numerico de los indicados en las opciones.
		goto main
	)
	

:readFile
	set /a m=0
	for /f "tokens=1-4 delims=;" %%a in (%file%) do (
		rem echo nombre= %%a
		rem echo cerrar sesiones= %%b
		rem echo eliminar perfiles= %%c
		rem echo apagar= %%d
		rem echo:
		set /a m+=1
		call set files[%%m%%]=%%a
	)

	exit /b 0
:saveRead
	set /a j=0
	for /f "usebackq delims=" %%w in (%file%) do (
		set /a j+=1
		call set nombre[%%j%%]=%%w
		call set cerrar[%%j%%]=%%x
		call set eliminar[%%j%%]=%%y
		call set apagar[%%j%%]=%%z
		call set n=%%j%%
	)
	exit /b 0

:getAllWS
	(for /l %%i in (2,1,%n%) do (
		echo ============================================================================
		call :getUsers %%nombre[%%i]%% %%cerrar[%%i]%% %%eliminar[%%i]%% %%apagar[%%i]%%
	))
	exit /b 0

:getUsers
	echo [1m%~1[0m
	if %opciones% == 1 (
		qwinsta /server:%~1
		rem echo nombre= %~1
		rem echo cerrar sesiones= %~2
		rem echo eliminar perfiles= %~3
		rem echo apagar= %~4
		rem echo:
	)
	if %opciones% == 2 (
		if %~2 equ SI (
			call :clsSessions %~1
		) else (
			echo En el equipo %~1 no se cerro ninguna sesion.
		)
	)
	if %opciones% == 3 (
		if %~3 equ SI (
			call :delUser %~1
		) else (
			echo En el equipo %~1 no se elimino ningun perfil.
		)
	)
	if %opciones% == 4 (
		if %~4 equ SI (
			call :shutdown %~1
		) else (
			echo En el equipo %~1 no se elimino ningun perfil.
		)
	)

	exit /b 0

:clsSessions
	
	set /a count=0
	for /f "skip=1 tokens=1,2,3,4" %%a in ('qwinsta /server:%~1') do (
		if not "%%b"=="0" (
			if "%%c"=="Desc" (
				rwinsta/server:%~1 %%b
				set /a count=count+1
			)
		)
	)
	if %count% == 0 (
		echo En el equipo %~1 no se cerro ninguna sesionn.
	)
	if %count% == 1 (
		echo En el equipo %~1 fue cerrada [101m 1 [0m sesion.
	)
	if %count% geq 2 (
		echo En el equipo %~1 fueron cerradas [101m !count! [0m sesiones.
	)

	exit /b 0

:delUser
	rem IMPLEMENTAR!
	echo Eliminar los usuarios de %~1
	exit /b 0

:shutdown
	echo Reiniciando el equipo %~1 en 10 segundos "Debido a un cambio en Sicam."
	shutdown /r /m \\%~1 /t 10 /c "Debido a un cambio en Sicam."
	exit /b 0
