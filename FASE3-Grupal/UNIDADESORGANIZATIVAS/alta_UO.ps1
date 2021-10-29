param($dominio,$suf)
$domainComponent="dc="+$dominio+",dc="+$suf
Write-Host $domainComponent
$ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
$fichero = import-csv -Path $ficheroCsvUO -delimiter :
foreach($line in $fichero)
{
   New-ADOrganizationalUnit -Description:$line.Description -Name:$line.Name -Path:$domainComponent -ProtectedFromAccidentalDeletion:$true
}