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