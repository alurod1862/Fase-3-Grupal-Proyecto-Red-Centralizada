function mostrar_submenu1
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Crear Unidades Organizativas."
     Write-Host "2: Crear Grupos."
     Write-Host "3: Crear administradores parciales"
     Write-Host "4: Añadir usuarios a grupos"
     Write-Host "s: Ir a menu."
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                Clear-Host
                $dominio= "upv"
                $suf= "es"
                $domainComponent="dc="+$dominio+",dc="+$suf
                Write-Host $domainComponent
                $ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
                $fichero = import-csv -Path $ficheroCsvUO -delimiter :
                foreach($line in $fichero)
        {
             New-ADOrganizationalUnit -Description:$line.Description -Name:$line.Name -Path:$domainComponent -ProtectedFromAccidentalDeletion:$true
        }
                return
           } '2' {
                Clear-Host
                $dominio= "upv"
                $sufijoDominio= "es"
                $domainComponent="dc="+$dominio+",dc="+$sufijoDominio
                Write-Host $domainComponent
                $gruposCsv=Read-Host "Introduce el fichero csv de Grupos"
                $fichero = import-csv -Path $gruposCsv -delimiter :
                foreach($linea in $fichero)
            {
                $pathObject=$linea.Path+","+$domainComponent
                New-ADGroup -Name:$linea.Name -Description:$linea.Description `
                -GroupCategory:$linea.Category `
                -GroupScope:$linea.Scope  `
                -Path:$pathObject

            }
                $dominio= "upv"
                $sufijo= "es"
                $dc="dc="+$dominio+",dc="+$sufijo
{
  Import-Module ActiveDirectory 
}

$fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
$fichero = import-csv -Path $fileUsersCsv -Delimiter :

foreach($linea in $fichero)
{
	Add-ADGroupMember -Identity $linea.Name -Members $linea.Group
}
                return
           } '3' {
               
$dominio= "upv"
$sufijo= "es"
#En la variable dc componemos el nombre dominio y sufijo. Ejemplo: dc=smr,dc=local.
$dc="dc="+$dominio+",dc="+$sufijo

#
#Primero hay que comprobar si se tiene cargado el módulo Active Directory
#
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

#
#Creación de los usuarios
#
#
#Preguntamos al usuario que nos indique el fichero csv
#
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"

#El fichero csv tiene esta estructura (9 campos)
#Name:Surname:Surname2:NIF:Group:ContainerPath:Computer:Hability:DaysAccountExpire

#
#Importamos el fichero csv (comando import-csv) y lo cargamos en la variable fichero_csv. 
#El delimitador usado en el csv es el : (separador de campos)
#
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{

	#
  	#Guardamos de manera segura la contraseña con el comando ConvertTo-SecureString. En este caso, la contraseña corresponde al NIF (9 números + letra)
	#
  	$passAccount=ConvertTo-SecureString $linea_leida.AccountPassword -AsPlainText -force
	
	#Asignamos a las variables lo capturado de los campos del csv
	$name=$linea_leida.Name
	$nameShort=$linea.Name+'.'+$linea_leida.Surname
	$Surnames=$linea.Surname+' '+$linea_leida.Surname2
	$nameLarge=$linea.Name+' '+$linea_leida.Surname+' '+$linea_leida.Surname2
	$computerAccount=$linea_leida.Computer
	$email=$nameShort+"@"+$a+"."+$b
	
	#
	#El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor true/false para habilitar o no habilitar el usuario y convertirlo en boolean.
	#
	[boolean]$Habilitado=$true
  	If($linea_leida.Hability -Match 'false') { $Habilitado=$false}
  
	New-ADUser `
    		-SamAccountName $name `
    		-UserPrincipalName $name `
		    -Surname $Surnames `
    		-DisplayName $name `
    		-GivenName $name `
		    -Description "Cuenta de $nameLarge" `
		    -AccountPassword $passAccount `
    		-Enabled $Habilitado `
		    -CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
		    -PasswordNotRequired $false `
            -Name $name

}           return
           } '4' {

                Clear-Host
                $dominio= "upv"
                $suf= "es"
                $domainComponent="dc="+$dominio+",dc="+$suf
{
  Import-Module ActiveDirectory
}
                $fileUsersCsv=Read-Host "Introduce el fichero csv de los usuarios:"
                $fichero = import-csv -Path $fileUsersCsv -Delimiter :
                foreach($linea in $fichero)
{
	Add-ADGroupMember -Identity $linea.Group -Members $linea.Name
}
                return
           } 's' {
                'Saliendo del submenu...'
                return
           } 
     }
}
until ($input -eq 'q')
}
function mostrar_submenu2
{
     param (
           [string]$Titulo = 'Submenu.....'
     )
     Clear-Host 
     Write-Host "================ $Titulo ================"
    
     Write-Host "1: Crear plantillas"
     Write-Host "2: Listar plantillas."
     Write-Host "3: Eliminar plantillas."
     Write-Host "s: Ir a menu."
do
{
     $input = Read-Host "Por favor, pulse una opcion"
     switch ($input)
     {
           '1' {
                Clear-Host
$dominio= "upv"
$sufijo= "es"
#En la variable dc componemos el nombre dominio y sufijo. Ejemplo: dc=smr,dc=local.
$dc="dc="+$dominio+",dc="+$sufijo

#
#Primero hay que comprobar si se tiene cargado el módulo Active Directory
#
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

#
#Creación de los usuarios
#
#
#Preguntamos al usuario que nos indique el fichero csv
#
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios:"

#El fichero csv tiene esta estructura (9 campos)
#Name:Surname:Surname2:NIF:Group:ContainerPath:Computer:Hability:DaysAccountExpire

#
#Importamos el fichero csv (comando import-csv) y lo cargamos en la variable fichero_csv. 
#El delimitador usado en el csv es el : (separador de campos)
#
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea_leida in $fichero_csv_importado)
{

	#
  	#Guardamos de manera segura la contraseña con el comando ConvertTo-SecureString. En este caso, la contraseña corresponde al NIF (9 números + letra)
	#
  	$passAccount=ConvertTo-SecureString $linea_leida.AccountPassword -AsPlainText -force
	
	#Asignamos a las variables lo capturado de los campos del csv
	$name=Read-Host "Escriba aqui el nombre del ususario a crear"
	$nameShort=$linea.Name+'.'+$linea_leida.Surname
	$Surnames=Read-Host "Escriba aqui el apellido del ususario a crear"
	$nameLarge=Read-Host "Escriba la descripcion del usuario"
	$computerAccount=$linea_leida.Computer
	$email=$nameShort+"@"+$a+"."+$b
	
	#
	#El parámetro -Enabled es del tipo booleano por lo que hay que leer la columna del csv
	#que contiene el valor true/false para habilitar o no habilitar el usuario y convertirlo en boolean.
	#
	[boolean]$Habilitado=$true
  	If($linea_leida.Hability -Match 'false') { $Habilitado=$false}
  
	New-ADUser `
    		-SamAccountName $name `
    		-UserPrincipalName $name `
		    -Surname $Surnames `
    		-DisplayName $name `
    		-GivenName $name `
		    -Description $namelarge `
		    -AccountPassword $passAccount `
    		-Enabled $Habilitado `
		    -CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
		    -PasswordNotRequired $false `
            -Name $name

}          
                return
           } '2' {
                Clear-Host
                dsquery user -name *
                return
           } '3' {
                Clear-Host
                $user=Read-Host "Escribe el nombre del usuario a borrar"
                Remove-ADUser -Identity "CN=$user, CN=Users,DC=UPV,DC=ES"
                return
           } 's' {
                'Saliendo del submenu...'
                return
           } 
     }
}
until ($input -eq 'q')
}


#Función que nos muestra un menú por pantalla con 3 opciones, donde una de ellas es para acceder
# a un submenú) y una última para salir del mismo.

function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1. Gestión de administradores parciales" 
     Write-Host "2. Gestión de plantillas de Admin.Parciales" 
     Write-Host "3. Habilitar cuentas"
     Write-Host "4. Deshabilitar cuentas"  
     Write-Host "s. Presiona 's' para salir" 
}

do 
{ 
     mostrarMenu 
     $input = Read-Host "Elegir una Opción" 
     switch ($input) 
     { 
           '1' { 
                Clear-Host
                mostrar_submenu1  
                pause
           } '2' { 
                Clear-Host  
                mostrar_submenu2
                pause      
           } '3' {
                Clear-Host
                $user=Read-Host "Escribe el nombre de la cuenta a habilitar"
                Enable-ADAccount -Identity "CN=$user, CN=Users,DC=UPV,DC=ES"
                return
                pause
           } '4' {
                Clear-Host
                $user=Read-Host "Escribe el nombre de la cuenta a deshabilitar"
                Disable-ADAccount -Identity "CN=$user, CN=Users,DC=UPV,DC=ES"
                return
                pause
           } 's' {
                'Saliendo del script...'
                return 
           }  
     } 
     pause 
} 
until ($input -eq 's')
