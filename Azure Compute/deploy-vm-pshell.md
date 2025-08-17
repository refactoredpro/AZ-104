# Azure VM Deployment with PowerShell Tutorial

## Prerequisites

Before starting, ensure you have:
- Azure PowerShell module installed
- An active Azure subscription
- Appropriate permissions to create resources

## Step 1: Install and Connect to Azure

### Install Azure PowerShell Module
```powershell
# Install the Azure PowerShell module (run as Administrator)
Install-Module -Name Az -AllowClobber -Scope AllUsers
```

### Connect to Your Azure Account
```powershell
# Sign in to Azure
Connect-AzAccount

# Verify your subscription
Get-AzSubscription

# Set the subscription context (if you have multiple subscriptions)
Set-AzContext -SubscriptionId "your-subscription-id"
```

## Step 2: Define Variables

Set up variables for your VM deployment:

```powershell
# Resource group and location
$resourceGroupName = "rg-rfdemo-prod"
$location = "East US"

# VM configuration
$vmName = "vm-rfdemo-web01"
$vmSize = "Standard_B2s"
$adminUsername = "rfdemo-admin"

# Network configuration
$vnetName = "vnet-rfdemo-prod"
$subnetName = "snet-rfdemo-web"
$nsgName = "nsg-rfdemo-web"
$publicIpName = "pip-rfdemo-web01"
$nicName = "nic-rfdemo-web01"

# Storage
$osDiskName = "disk-rfdemo-web01-os"
```

## Step 3: Create Resource Group

```powershell
# Create a new resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location
```

## Step 4: Create Network Security Group

```powershell
# Create NSG rules
$rdpRule = New-AzNetworkSecurityRuleConfig `
    -Name "AllowRDP" `
    -Description "Allow RDP" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1000 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389

# Create the NSG
$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nsgName `
    -SecurityRules $rdpRule
```

## Step 5: Create Virtual Network

```powershell
# Create subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
    -Name $subnetName `
    -AddressPrefix "10.0.1.0/24" `
    -NetworkSecurityGroup $nsg

# Create virtual network
$vnet = New-AzVirtualNetwork `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $vnetName `
    -AddressPrefix "10.0.0.0/16" `
    -Subnet $subnetConfig
```

## Step 6: Create Public IP Address

```powershell
# Create public IP
$publicIp = New-AzPublicIpAddress `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $publicIpName `
    -AllocationMethod Static `
    -Sku Standard
```

## Step 7: Create Network Interface

```powershell
# Get the subnet
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# Create network interface
$nic = New-AzNetworkInterface `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nicName `
    -SubnetId $subnet.Id `
    -PublicIpAddressId $publicIp.Id
```

## Step 8: Create VM Configuration

```powershell
# Get credentials for the VM
$credential = Get-Credential -Message "Enter username and password for the VM"

# Create VM configuration
$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize

# Set operating system configuration
$vmConfig = Set-AzVMOperatingSystem `
    -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential $credential `
    -ProvisionVMAgent `
    -EnableAutoUpdate

# Set source image
$vmConfig = Set-AzVMSourceImage `
    -VM $vmConfig `
    -PublisherName "MicrosoftWindowsServer" `
    -Offer "WindowsServer" `
    -Skus "2022-Datacenter" `
    -Version "latest"

# Add network interface
$vmConfig = Add-AzVMNetworkInterface `
    -VM $vmConfig `
    -Id $nic.Id

# Set OS disk configuration
$vmConfig = Set-AzVMOSDisk `
    -VM $vmConfig `
    -Name $osDiskName `
    -CreateOption FromImage `
    -StorageAccountType "Premium_LRS"
```

## Step 9: Deploy the Virtual Machine

```powershell
# Create the virtual machine
Write-Host "Creating virtual machine..." -ForegroundColor Green
New-AzVM `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -VM $vmConfig `
    -Verbose
```

## Step 10: Verify Deployment

```powershell
# Get VM information
Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Get public IP address
$publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpName
Write-Host "VM Public IP: $($publicIpAddress.IpAddress)" -ForegroundColor Yellow

# Get VM status
Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status
```

## Complete Script Example

Here's the complete script you can run all at once:

```powershell
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
```

## Cleanup Resources

When you're done testing, clean up resources to avoid charges:

```powershell
# Remove the entire resource group (this deletes all resources within it)
Remove-AzResourceGroup -Name $resourceGroupName -Force
```

## Tips and Best Practices

1. **Security**: Always use strong passwords and consider using SSH keys for Linux VMs
2. **Cost Management**: Choose appropriate VM sizes and stop VMs when not in use
3. **Monitoring**: Enable Azure Monitor for your VMs
4. **Backup**: Configure Azure Backup for important VMs
5. **Updates**: Keep your Azure PowerShell module updated with `Update-Module Az`

## Common VM Sizes

- **Standard_B1s**: 1 vCPU, 1 GB RAM (Basic workloads)
- **Standard_B2s**: 2 vCPUs, 4 GB RAM (Small applications)
- **Standard_D2s_v3**: 2 vCPUs, 8 GB RAM (General purpose)
- **Standard_D4s_v3**: 4 vCPUs, 16 GB RAM (Production workloads)

## Troubleshooting

If you encounter errors:
1. Check your Azure permissions
2. Verify subscription limits haven't been exceeded
3. Ensure the VM size is available in your chosen region
4. Check for naming conflicts with existing resources