# azf5
```
$kvName = "scsAzPKIkeyvault"
$resourceGroupName = "f5-rg"
$location = "eastus"  
$certificateName = "mycert"
$certificateSubjectName = "CN=www.contoso.com"  
$certificateValidityInMonths = 1
$policy = New-AzKeyVaultCertificatePolicy -SubjectName $certificateSubjectName -ValidityInMonths $certificateValidityInMonths 
Add-AzKeyVaultCertificate -VaultName $kvName -Name $certificateName -CertificatePolicy $policy
```
