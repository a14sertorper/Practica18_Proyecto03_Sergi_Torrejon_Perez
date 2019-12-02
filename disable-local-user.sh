#!/bin/bash
#https://github.com/a14sertorper/Practica18_Proyecto03_Sergi_Torrejon_Perez/blob/master/disable-local-user.sh

function usage() {
cat <<EOF
Usage: ${opcionesdeprograma} [-drac] USUARIO [USERN]
	Deshabilitar una cuenta local de Linux.
	-d Eliminar cuentas en lugar de deshabilitarlas.
	-r Eliminar el directorio del usuario que ha iniciado sesión.
	-a Crear una copia de seguridad del usuario que ha iniciado sesión.
	-c Deshabilitar al usuario, pero no eliminarlo.
EOF
exit 1
}

# Comprovación de que se han pasado parametros para poder ejecutar bien el programa.
if [ $# -eq 0 ]; then
  usage
fi

# Comprovación para ejecutar el programa solo si el usuario es root.
if [[ "${UID}" -ne 0 ]]
then
   echo 'El programa se tiene que ejecutar como usuario root'
   exit 1
fi

#comprovación para ver que función quiere utilizar.
while getopts ":d:r:a:c:" opcionesdeprograma
do
  case ${opcionesdeprograma} in
#Función <<Eliminar cuentas en lugar de deshabilitarlas.>>
    d)
	USUARIO="${OPTARG}"
	userdel ${USUARIO}
	if [ $? -eq 0 ];
	then
		echo "El usuario ${USUARIO} se ha eliminado"
	else
		echo "Ha ocurrido un error, no se ha podido eliminar el usaurio"
	fi
	;;
#Función <<Eliminar el directorio del usuario que ha iniciado sesión.>>
    r)
	USUARIO="${OPTARG}"
	rm -r /home/${USUARIO}
	if [ $? -eq 0 ];
	then
		echo "El directorio 'Home' del usuario ${USUARIO} se ha eliminado"
	else
		echo "El directorio no se ha podido eliminar"
	fi
	;;
#Función <<Hacer una copia de seguridad del usuario que ha iniciado sesión>>
    a)
	USUARIO="${OPTARG}"
	if [ -d /copiasdeseguridad ];
	then
		cp -r /home/${USUARIO} /copiasdeseguridad/${USUARIO}.bak
	else
		mkdir /copiasdeseguridad/
		cp -r /home/${USUARIO} /copiasdeseguridad/${USUARIO}.bak
	fi
	if [ $? -eq 0 ];
	then
		echo "Copia de seguridad realizada al usuario ${USUARIO}"
	else
		echo "La copia de seguridad no se ha podido realizar de manera correcta, intentelo otra vez"
	fi
	;;
#Función <<Deshabilitar al usuario, pero no eliminarlo.>>
    c)
	USUARIO="${OPTARG}"
	usermod -L ${USUARIO}
	if [ $? -eq 0 ];
	then
		echo "El usuario ${USUARIO} ha sido deshabilitado"
	else
		echo "El usuario ${USUARIO} no se ha podido deshabilitar"
	fi
	;;
    *)
	usage
	;;
  esac
done

shift "$(( OPTIND - 1 ))"

# comprovación para que cualquier función no este vacia
if [ -z "${USUARIO}" ];
then
	usage
fi
