param($dominio,$sufijoDominio)
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