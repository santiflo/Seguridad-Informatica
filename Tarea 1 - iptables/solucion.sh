	#!/bin/bash
	############################################
	#	Pontificia Universidad Javeriana Cali 	#
	#	Inguieneria de Sistemas y Computacion 	#
	#	Seguridad Informatica				  	#
	#	Estudiantes:						  	#
	#		Santiago Florian Bustamante			#
	#		Dicson Ferney Quimbayo				#
	#											#
	#	13 de Septiembre del 2020				#
	#	Tarea 1									#
	 ###########################################

	# El siguiente archivo sh contiene la solucion a la primera tarea de 
	# seguridad informatica, de IPtables

	######################################################################
	# ¿Que es IPtables?
	# IPtables es un sistema de firewall vinculado al kernel de linux el
	# cual permite añadir, editar o modificar reglas para permitir o
	# o denegar las conexiones que se realizan al servidor.
	#
	# IPtables permite la implementacion de 3 tipos de reglas:
	#	MANGLE: Destinadas a modificar los paquetes.
	#	NAT: reglas  PREROUTING, POSTROUTING.
	#	FILTER: reglas INPUT, OUTPUT, FORWARD.
	#
	# IPtables permite aplicar las reglas de filtrado para 
	# ingresar(INPUT)*, enviar(OUTPUT)* o transmitir(FORWARD)** paquetes.
	# 	* Para los paquetes que van para la propia maquitna se usa INPUT Y
	#	OUTPUT
	#	** Para los paquetes que van para otras redes o maquinas se usa
	#	FORWARD
	######################################################################	

	######################################################################
	# Estructura de IPtable
	# iptables −t[X] -[Y][Z] -[W] -[V] 
	# X: Tabla a usar
	# Y: Parametro de la tabla
	# Z: Cadena a usaer en la tabla
	# W: Caracteristicas que se desean comparar con el paquete
	# V: Accion a ejecutar
	######################################################################

	######################################################################
	# Instalar y configurar un firewall IPTABLES: El siguiente trabajo 
	# consiste en la instalación y configuración del Firewall IPTable y
	# aplicar las siguientes reglas:
	#
	# Instalar IPtables:
	#sudo apt-get install IPtables
	#
	# Limpiar las reglas creadas
		iptables -F 	#Borra todas las reglas
		iptables -X		#Borra las reglas creadas por el ususario
		iptables -Z		#Reinicia el contador de las reglas
		iptables -t nat -F #Borra las reglas de la tabla nat
	#
	# Asignando las reglas basicas
		iptables -P INPUT ACCEPT	#Recibe todo el trafico del exterior
		iptables -P OUTPUT ACCEPT	#Envia todos el trafico al exterior
		iptables -P FORWARD ACCEPT	#Trasmite todos el trafico en la red
		iptables -t nat -P PREROUTING ACCEPT
		iptables -t nat -P POSTROUTING ACCEPT
	#
		echo IPtables limpia__________________________________________________
		iptables -L -n -v
		echo _________________________________________________________________
	#
	#	1) 	Se requiere crear una regla que restrinja las conexiones por 
	#		medio del cliente SSH al servidor.
	#
	# Las conecciones SSH se hacen por medio del protocolo TCP por el 
	# puerto 22. Por lo tanto se requiere aplicar una reglar que bloquee
	# las conexiones TCP al puerto 22 del servidor.
	#
		iptables -A INPUT -p tcp --dport 22 -j DROP
	#
		echo Bloqueo de las conexiones SSH____________________________________
		iptables -L -n -v
		echo _________________________________________________________________
	#
	#	2)	Se requiere crear una regla que restrinja los pings que se 
	#		realicen al servidor web.
	#
	# Los pings se realizan por el protocolo ICMP, por lo tanto se debe
	# implementar una regla que renstrinja todas las peticiones por medio 
	# del protocolo ICMP.
		iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
	#
		echo Bloqueo de PINGs realizados al servidor__________________________
		iptables -L -n -v
		echo _________________________________________________________________
	#
	#	3)	Se requiere crear una regla donde el PC-A se le permita los
	#		pings al servidor y desde el PC-B sean restringidos.
	#
	# Supongamos que las direcciones IP de los PCs A y B son las
	# siguientes:
	#
	#	PC_A = 192.168.0.200
	#	PC_B = 192.168.0.201
	#
		iptables -A INPUT -p icmp --icmp-type echo-request -s 192.168.0.200 -j ACCEPT
		iptables -A INPUT -p icmp --icmp-type echo-request -s 192.168.0.201 -j DROP
	#
		echo Permitir PINGs de 192.168.0.200 y Rechazar PINGs de 192.168.0.201
		iptables -L -n -v
		echo _________________________________________________________________
	#
	# *Queremos que el PC_A pueda realizar PINGs al servidor y el PC_B se
	# le restrinjan los PINGs
	#
	#	4)	Realiza un escaneo al servidor web y determina que puertos
	#		están abiertos, crea una regla que bloque los puertos que
	#		estén abiertos del 1 al 60.
	#
	# Se pueden usar los comandos "netstat -an" o "lsof -i" para ver que
	# servicios se estan ejecuntando en el sistema, pero es un metodo no
	# tan confiable, debido a que estos servicios pueden ser ocultados. Es
	# mejor el uso de "nmap" para el escaneo de puertos
	#
		echo Puertos abiertos_________________________________________________
		nmap -sT -O localhost
		echo _________________________________________________________________
	#
	# Al ejecutar el comando, se puede identificar que el unico puerto
	# abierto es el 22, el cual se encuentra en este momento bloqueado
	# por la primera politica
	#
	# Bloqueo de los puertos del 1:60 de los protocolos TCP y UDP
	#
		iptables -A INPUT -p tcp --dport 1:60 -j DROP
		iptables -A INPUT -p udp --dport 1:60 -j DROP
	#	
		echo Bloqueo de los puertos del 1:60 de los protocolos TCP y UDP______
		iptables -L -n -v
		echo _________________________________________________________________
	#
	#	5)	Se requiere hacer una regla que restrinja las conexiones de
	# 		una determinada dirección MAC.
	#
	# Suponga que la direccion MAC de un host es:
	#	PC_MAC = 00:0F:EA:91:04:08
	#
		iptables -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j DROP
	#
		echo Bloqueo de las peticiones de la MAC 00:0F:EA:91:04:08____________
		iptables -L -n -v
		echo _________________________________________________________________
	#
	#	6)	Se requiere crear una regla que restrinja todas las conexiones
	#		a nuestro servidor web.
	#
	# La mejor seguridad que se puede lograr, es bloquear todas las que
	# se quieran realizar, y solo aplicar un cojunto de reglas para los
	# servicios que realmente se establecen para el funcionamiento del
	# sistema.
		iptables -A INPUT -j DROP
	#
		echo Bloqueo de todas las conexiones al servidor______________________
		iptables -L -n -v
		echo _________________________________________________________________
	#
	######################################################################

	######################################################################
	# Despues de realizado el ejercicio se deja ala maquina en su estado
	# original
	# Limpiar las reglas creadas
		iptables -F 	#Borra todas las reglas
		iptables -X		#Borra las reglas creadas por el ususario
		iptables -Z		#Reinicia el contador de las reglas
		iptables -t nat -F #Borra las reglas de la tabla nat
	#
	# Asignando las reglas basicas
		iptables -P INPUT ACCEPT	#Recibe todo el trafico del exterior
		iptables -P OUTPUT ACCEPT	#Envia todos el trafico al exterior
		iptables -P FORWARD ACCEPT	#Trasmite todos el trafico en la red
		iptables -t nat -P PREROUTING ACCEPT
		iptables -t nat -P POSTROUTING ACCEPT