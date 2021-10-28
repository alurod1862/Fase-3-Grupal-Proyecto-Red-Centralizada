$dominio="upv"
$sufijo="es"
$dc="dc="+$dominio+",dc="+$sufijo

{
  Import-Module ActiveDirectory #Se carga el módulo
}

$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios"
$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter :                  
foreach($linea_leida in $fichero_csv_importado)
{ 
  $rutaContenedor = $linea_leida.ContainerPath+","+$dc 
  $passAccount=ConvertTo-SecureString $linea_leida.AcountPassword -AsPlainText -force
    
    $name=$linea_leida.Name
    $nameShort=$linea_leida.Name+'.'+$linea_leida.Surname
    $Surnames=$linea_leida.Surname+' '+$linea_leida.Surname2
    $nameLarge=$linea_leida.Name+' '+$linea_leida.Surname+' '+$linea_leida.Surname2

    New-ADUser `
            -SamAccountName $nameShort `
            -UserPrincipalName $nameShort `
            -Name $nameShort `
            -Surname $Surnames `
            -DisplayName $nameLarge `
            -GivenName $name `
            -LogonWorkstations:$linea.Computer `
            -Description $linea_leida.Description `
            -EmailAddress $email `
            -AccountPassword $passAccount `
            -Enabled $true `
            -CannotChangePassword $false `
            -ChangePasswordAtLogon $true `
            -Path $rutaContenedor

}