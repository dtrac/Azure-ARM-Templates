#Requires -Version 3.0

Param(
    [string] $ResourceGroupLocation = 'uksouth',
    [string] $ResourceGroupName = 'TRACE-UKS-DEV-IT-LAB-INT-RG',
    [string] $TemplateFile = 'azuredeploy.json',
    [string] $TemplateParametersFile = 'azuredeploy.parameters.json',
    [ValidateNotNullOrEmpty()]
    [string] $SubscriptionId = (Read-Host -Prompt 'Subscription ID')
)

$ErrorActionPreference = 'Stop'

Set-AzContext -Subscription $subscriptionId

$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))
$TemplateJson = Get-Content $TemplateParametersFile | ConvertFrom-Json

Remove-AzVirtualNetwork -Name $TemplateJson.parameters.vnetName.value `
                        -ResourceGroupName $ResourceGroupName `
                        -Confirm:$false `
                        -Force -Verbose `
                        -ErrorVariable $ErrorMessages
                        
if ($ErrorMessages) {
        Write-Output '', 'Resource removal returned the following errors:', @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
    }