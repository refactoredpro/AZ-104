# Variables
$resourceGroupName = "rg-rfdemo-prod"
$location = "East US"
$vmName = "vm-rfdemo-web01"
$vmSize = "Standard_B2s"
$vnetName = "vnet-rfdemo-prod"
$subnetName = "snet-rfdemo-web"
$nsgName = "nsg-rfdemo-web"
$publicIpName = "pip-rfdemo-web01"
$nicName = "nic-rfdemo-web01"
$osDiskName = "disk-rfdemo-web01-os"

# Connect to Azure (if not already connected)
Connect-AzAccount

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create NSG
$rdpRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $nsgName -SecurityRules $rdpRule

# Create VNet
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroup $nsg
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vnetName -AddressPrefix "10.0.0.0/16" -Subnet $subnetConfig

# Create Public IP
$publicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Location $location -Name $publicIpName -AllocationMethod Static -Sku Standard

# Create NIC
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
$nic = New-AzNetworkInterface -ResourceGroupName $resourceGroupName -Location $location -Name $nicName -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id

# Get credentials
$credential = Get-Credential -Message "Enter username and password for the VM"

# Create VM
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
$vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $credential -ProvisionVMAgent -EnableAutoUpdate
$vmConfig = Set-AzVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest"
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
$vmConfig = Set-AzVMOSDisk -VM $vmConfig -Name $osDiskName -CreateOption FromImage -StorageAccountType "Premium_LRS"

# Deploy VM
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

# Display results
$publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpName
Write-Host "VM deployed successfully!" -ForegroundColor Green
Write-Host "Public IP: $($publicIpAddress.IpAddress)" -ForegroundColor Yellow