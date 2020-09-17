#!/bin/bash
# echo "Este Script necesita privilegios de administrador" (no estoy seguro del todo, lo comento y luego si eso lo pongo)
echo "Realizando comprobaciones iniciales"
echo -n "Dime tu nombre de usuario: " && read Usuari0
echo "****************************************"

####################################################################################

        #comprobando / creando el grupo minichat
grep minichat /etc/group>/dev/null #comprobando si el grupo minichat existe
if [ $? -ne 0 ]
then
        echo "El grupo no existe, creando"
        groupadd minichat
else
        echo "El grupo minichat existe" 
fi

####################################################################################

        #comprobando si el usuario está en el grupo minichat
groups $Usuari0 | grep minichat>/dev/null
if [ $? -eq 0 ]
then
        echo "Estas en el grupo minichat"
else
        echo "Debe pertenecer al grupo minichat. Busca a alguien que te incluya o mira esta guía"
        echo "https://www.maketecheasier.com/add-remove-user-to-groups-in-ubuntu/"
        exit 1
fi

####################################################################################

        #comprobando si existe /tmp/minichat
dir /tmp | grep minichat>/dev/null || mkdir /tmp/minichat; chown $Usuari0 /tmp/minichat; chgrp minichat /tmp/minichat; echo "/tmp/minichat detectado o creado con éxito" 
#|| es muy útil ya que puedes hacer un if sin escribir tanto, pero si pongo después del grep un echo me va a detectar que ha ido bien aunque haya ido mal, por eso el echo del final

echo "****************************************"
echo "Presione Enter para borrar la pantalla y continuar"
read welcome_to_matrix #lo primero que se me ha ocurrido
clear

####################################################################################

        #Si es sudo te lleva al primer menú, si no al segundo
groups $user | grep -w sudo>/dev/null
if [ $? -eq 0 ]
then
	echo "########################################"
	echo "         MENU - Aníbal Zambrana"
	echo "########################################"
	echo "1 Mirar la lista de usuarios registrados"
	echo "2 Enviar mensaje a un usuario"
	echo "3 Leer un chat"
	echo "4 Salir"
	read -p "Seleccione una opcion: " opcionMENU
else
	echo "########################################"
	echo "         MENU - Aníbal Zambrana"
	echo "########################################"
	echo "1 Mirar la lista de usuarios registrados"
	echo "2 Enviar mensaje a un usuario"
	echo "3 Leer un chat"
	echo "4 Salir"
	echo "5 Agregar un usuario a minichat"
	echo "6 Eliminar un usuario de minichat"
	read -p "Seleccione una opcion : " opcionMENU
fi

####################################################################################
#Algo raro pasa pero a esto NO le gusta que escriba function delante del nombre de la función, si lo pongo, peta así que... https://i.redd.it/ikxor71348n31.jpg

Mirar(){
        echo "****************************************"
                echo "LISTA DE USUARIOS"
                Usuari0s=$(grep minichat /etc/group | cut -d: -f4)
                IFS=","
                for user in $Usuari0s;do	
                        echo "$user"		
                done
        exit 1
}

Escribir(){
        echo "****************************************"
                echo "Lista de usuarios"
                Usuari0s=$(grep minichat /etc/group | cut -d: -f4)
                IFS=","
                for user in $Usuari0s;do	
                        echo "$user"		
                done
                #
                read -p "¿A quién escribir? : " Usuari0_Destin0
                groups $Usuari0_Destino | grep minichat>/dev/null
                if [ $? -eq 1 ]
                then
                        exit 1
                fi
                #Comprobar el usuario
                echo ""
                echo "Escribe el mensaje :" 
                read Mensaje
                #touch "/tmp/minichat/"$Usuari0"_"$Usuari0_Destino""
                UA=$(echo $Usuari0$'\n'$Usuari0_Destino | sort |head -1)
                UB=$(echo $Usuari0_Destino$'\n'$Usuari0 | sort |tail -1)
                #Lo de arriba es para ordenarlo alfabéticamente
                Nombre_Archiv0="$UA"_"$UB" #esto mete un $ al final, ni idea
                touch /tmp/minichat/$Lista; chgrp minichat /tmp/minichat/$Nombre_Archiv0; chmod ug+rw,o-rwx /tmp/minichat/$Nombre_Archiv0
                echo `date +%D/%X`_$Usuari0: $Mensaje >> /tmp/minichat/$Nombre_Archiv0
        exit 1
}

Leer(){
        echo "****************************************"
                echo "Lista de usuarios"
                Usuari0s=$(grep minichat /etc/group | cut -d: -f4)
                IFS=","
                for user in $Usuari0s;do	
                        echo "$user"		
                done
                #
                read -p "Nombre del usuario : " Usuari0_Leer
                groups $Usuari0_Leer | grep minichat>/dev/null
                if [ $? -eq 1 ]
                then
                        exit 1
                fi
                #Comprobar el usuario
                UA=$(echo $Usuari0$'\n'$Usuari0_Leer | sort |head -1)
                UB=$(echo $Usuari0_Leer$'\n'$Usuari0 | sort |tail -1)
                Nombre_Archiv0="$UA"_"$UB"
                nano /tmp/minichat/$Nombre_Archiv0
                exit 1
                }

GTFO(){
        clear
        exit 1
}

Anadir(){
        echo "****************************************"
                groups $Usuari0 | grep sudo>/dev/null
                if [ $? -eq 1 ]
                then
                     echo "Para ejecutar esta orden debes usar Sudo, aunque como esta opción solo sale al ser ejecutado con Sudo que te salga esto quiere decir que algo ha ido terriblemente mal, genial."
                fi
                read -p "El nombre del usuario : " Usuari0_Nuevo
                #
                groups $Usuari0_Nuevo
                if [ $? -eq 1 ]
                then
                read -p "Contraseña para el nuevo usuario, por favor : " Passw0rd
                useradd -G minichat -P $Passw0rd $Usuari0_Nuevo
                usermod -a -G minichat $Usuari0_Nuevo
                echo "$Usuari0_Nuevo añadido."
                exit 1
                fi
                #
                groups $Usuari0_Nuevo | grep minichat
                if [ $? -eq 0 ]
                then
                echo "No está en el grupo, añadiendo..."
                usermod -a -g minichat $Usuari0_Nuevo
                else
                echo "Ya pertenece a Minichat"
                fi
        exit 1
}

HasSidoBaneado(){
        echo "****************************************"
        read -p "Usuario a eliminar de minichat : " Usuari0_Banear
        groups $Usuari0_Banear | grep minichat>/dev/null
        #
        if [ $? -eq 0 ]
        then
        echo "Eliminando..."
        gpasswd -d $Usuari0_Banear minichat
                ##
                groups $Usuari0_Banear | grep minichat>/dev/null
                if [ $? -eq 1 ]
                then
                        echo "$Usuari0_Banear eliminado con éxito"
                else
                        echo "Ha fallado"
                        fi
                ##
        else
        echo "Este usuario no está en minichat"
        fi
        exit 1
}

####################################################################################

        #El chiste se explica solo
case $opcionMENU in
	 1) Mirar ;;
	 2) Escribir ;;
	 3) Leer ;;
	 4) GTFO ;;
	 5) Anadir ;;
	 6) HasSidoBaneado ;;
 	 *) echo "Debes introducir un número, ej 1 2 o 3...";; 
esac