﻿#Fuente: https://gallery.technet.microsoft.com/scriptcenter/Menu-simple-en-PowerShell-95e1f923

#Paso de parámetros al ejecutar el script en la consola
#Este script recoje 2 parámetros en la llamada del mismo en la consola. 
#La ejecución del script será puede ser de dos formas:
#./menu.ps1 param1 param2
#o 
#./menu.ps1 -Param1 parametro1 -Param2 parametro2
#Los parámetros son opcionales, si la llamada es:./menu.ps1 --> los valores de $Param1 y $Param2, será la cadena de texto vacía.
Param(
  [string]$Param1,
  [string]$Param2
)
Write-Host "Los parámetros son:"$Param1 " " $Param2
pause

#Función 1. Promocionar a CD
function PromocionarCD
{
Write-Host "Ejecuto el comando para promocionar a CD"
$dominioFQDN = "upv.es"
$dominioNETBIOS = "upv"
$adminPass = "Hola01"
Import-Module ADDSDeployment
Install-ADDSForest
-CreateDnsDelegation:$False `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Default" `
-DomainName $dominioFQDN `
-DomainNetbiosName $dominioNETBIOS `
-SafeModeAdministratorPassword (ConvertTo-SecureString -string $adminPass -AsPlainText -Force) `
-ForestMode "Default" `
-InstallDns:$True `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
}
function DespromocionarCD
{
Write-Host "Ejecuto el comando para despromocionar el CD"
Import-Module ADDSDeployment
Uninstall-ADDSDomainController -DemoteOperationMasterRole:$true -ForceRemoval:$true -Force:$true
}
function PromocionarCDreplica
{
Write-Host "Ejecuto el comando para promocionar la replica"
$nameServer="master-upv-es-replica"
$addressIP="192.168.1.202"
$networkInternal="Ethernet 1"
Rename-Computer -NewName "master-upv-es-replica"
Get-NetAdapter –name $networkInternal | Remove-NetIPAddress -Confirm:$false
Get-NetAdapter –name $networkInternal | New-NetIPAddress –addressfamily IPv4 –ipaddress 192.168.1.202 –prefixlength 24 –type unicast
Restart-Computer -force
Import-Module ServerManager
Add-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSDomainController `
-DomainName "upv.es" `
-Credential (Get-Credential) `
-SiteName "Default-First-Site-Name" `
-InstallDNS:$true `
-NoGlobalCatalog:$false `
-CreateDNSDelegation:$false `
-ReplicationSourceDC "master-upv-es.upv.es" `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
}
function ReplicarDatos
{
Write-Host "Ejecuto el comando para replicar los datos"
dsquery user -name *
repadmin /replsum * /bysrc /bydest /sort:delta
}
function Adaptador
{
Write-Host "Ejecuto el comando para saber el adaptador"
Get-NetAdapter
}
function SSID
{
Write-Host "Ejecuto el comando para saber el SSID"
whoami /user
}
function SaberServidor
{
Write-Host "Ejecuto el comando para saber el servidor al que estas conectado"
echo %logonserver%
}
function SaberServicios
{
Write-Host "Ejecuto el comando para saber servicios instalados"
Get-Windowsfeature
}



#Función que nos muestra un menú por pantalla con 3 opciones y una última para salir del mismo
# La función “mostrarMenu”, puede tomar como parámetro un título y devolverá por pantalla 
# "================ $Titulo================" , donde $Titulo será el título pasado por parámetro.
#Si no se le pasa un parámetro, por defecto $Titulo contendrá la cadena 'Selección de opciones'  
#https://technet.microsoft.com/es-es/library/jj554301.aspx
function mostrarMenu 
{ 
     param ( 
           [string]$Titulo = 'Selección de opciones' 
     ) 
     Clear-Host 
     Write-Host "================ $Titulo================" 
      
     
     Write-Host "1) Promocionar CD" 
     Write-Host "2) Despromocionar CD" 
     Write-Host "3) Promocionar CD replica" 
     Write-Host "4) Replicar Datos"     
     Write-Host "5) Adaptador"     
     Write-Host "6) Usuario y SSID"     
     Write-Host "7) Saber servidor"
     Write-Host "8) Saber servicios instalados"
     Write-Host "S) Presiona 'S' para salir" 
}
#Bucle principal del Script. El bucle se ejecuta de manera infinita hasta que se cumple
#la condición until ($input -eq 's'), es decir, hasta que se pulse la tecla s.
do 
{ 
     #Llamamos a la función mostrarMenu, para dibujar el menú de opciones por pantalla
     mostrarMenu 
     #Recogemos en la varaible input, el valor que el usuario escribe por teclado (opción del menú)
     $input = Read-Host "Elegir una Opción" 
     #https://ss64.com/ps/switch.html
     switch ($input) 
     { 
           '1' { 
                Clear-Host  
                PromocionarCD 
                pause
           } '2' { 
                Clear-Host  
                DespromocionarCD 
                pause
           } '3' { 
                Clear-Host  
                PromocionarCDreplica 
                pause
           } '4' { 
                Clear-Host  
                ReplicarDatos
                pause
           } '5' { 
                Clear-Host  
                Adaptador
                pause
           } '6' { 
                Clear-Host  
                SSID
                pause
           } '7' { 
                Clear-Host  
                SaberServidor
                pause
           } '8' { 
                Clear-Host  
                Saberservicios 
                pause
           } 's' {
                'Saliendo del script...'
                return 
           } 
           #Si no se selecciona una de las opciones del menú, es decir, se pulsa algun carácter
           #que no sea 1, 2, 3 o s, sacamos por pantalla un aviso e indicamos lo que hay que realizar.
           default { 
              'Por favor, Pulse una de las opciones disponibles [1-3] o s para salir'
           }
     } 
     pause 
} 
until ($input -eq 's')