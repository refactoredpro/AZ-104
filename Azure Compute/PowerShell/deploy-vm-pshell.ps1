# Connect to Azure
Connect-AzAccount

# Create Resource Group
New-AzResourceGroup -Name 'rg-rfdemo-test' -Location 'eastus'

# Create VM (you'll be prompted for username/password)
New-AzVm `
    -ResourceGroupName 'rg-rfdemo-test' `
    -Name 'vm-rfdemo-web01' `
    -Location 'eastus' `
    -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' `
    -VirtualNetworkName 'vnet-rfdemo-test' `
    -SubnetName 'snet-rfdemo-web' `
    -SecurityGroupName 'nsg-rfdemo-web' `
    -PublicIpAddressName 'pip-rfdemo-web01' `
    -OpenPorts 80,3389

# Optional: Install IIS web server
Invoke-AzVMRunCommand `
    -ResourceGroupName 'rg-rfdemo-test' `
    -VMName 'vm-rfdemo-web01' `
    -CommandId 'RunPowerShellScript' `
    -ScriptString 'Install-WindowsFeature -Name Web-Server -IncludeManagementTools'

# Get public IP to connect
$publicIp = Get-AzPublicIpAddress -ResourceGroupName 'rg-rfdemo-test' -Name 'pip-rfdemo-web01'
Write-Host "VM Public IP: $($publicIp.IpAddress)" -ForegroundColor Green
Write-Host "RDP: Connect using Remote Desktop to $($publicIp.IpAddress):3389" -ForegroundColor Yellow
Write-Host "Web: Open browser to http://$($publicIp.IpAddress)" -ForegroundColor Yellow