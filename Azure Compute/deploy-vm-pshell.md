# Azure VM Deployment with PowerShell - Simplified Tutorial

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

## Step 2: Create Resource Group

```powershell
# Create a new resource group
New-AzResourceGroup -Name 'rg-rfdemo-prod' -Location 'eastus'
```

## Step 3: Create Virtual Machine

Create a VM with a single command. When prompted, provide a username and password to be used as the sign-in credentials for the VM:

```powershell
New-AzVm `
    -ResourceGroupName 'rg-rfdemo-prod' `
    -Name 'vm-rfdemo-web01' `
    -Location 'eastus' `
    -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' `
    -VirtualNetworkName 'vnet-rfdemo-prod' `
    -SubnetName 'snet-rfdemo-web' `
    -SecurityGroupName 'nsg-rfdemo-web' `
    -PublicIpAddressName 'pip-rfdemo-web01' `
    -OpenPorts 80,3389
```

That's it! This single command creates:
- The virtual machine
- Virtual network and subnet
- Network security group with ports 80 and 3389 open
- Public IP address
- Network interface
- OS disk

## Step 4: Install Web Server (Optional)

To test your VM, install IIS web server:

```powershell
Invoke-AzVMRunCommand `
    -ResourceGroupName 'rg-rfdemo-prod' `
    -VMName 'vm-rfdemo-web01' `
    -CommandId 'RunPowerShellScript' `
    -ScriptString 'Install-WindowsFeature -Name Web-Server -IncludeManagementTools'
```

## Step 5: Get VM Information

```powershell
# Get VM details
Get-AzVM -ResourceGroupName 'rg-rfdemo-prod' -Name 'vm-rfdemo-web01'

# Get public IP address
Get-AzPublicIpAddress -ResourceGroupName 'rg-rfdemo-prod' -Name 'pip-rfdemo-web01'

# Check VM status
Get-AzVM -ResourceGroupName 'rg-rfdemo-prod' -Name 'vm-rfdemo-web01' -Status
```

## Complete Script

Here's the complete simplified script:

```powershell
# Connect to Azure
Connect-AzAccount

# Create Resource Group
New-AzResourceGroup -Name 'rg-rfdemo-prod' -Location 'eastus'

# Create VM (you'll be prompted for username/password)
New-AzVm `
    -ResourceGroupName 'rg-rfdemo-prod' `
    -Name 'vm-rfdemo-web01' `
    -Location 'eastus' `
    -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' `
    -VirtualNetworkName 'vnet-rfdemo-prod' `
    -SubnetName 'snet-rfdemo-web' `
    -SecurityGroupName 'nsg-rfdemo-web' `
    -PublicIpAddressName 'pip-rfdemo-web01' `
    -OpenPorts 80,3389

# Optional: Install IIS web server
Invoke-AzVMRunCommand `
    -ResourceGroupName 'rg-rfdemo-prod' `
    -VMName 'vm-rfdemo-web01' `
    -CommandId 'RunPowerShellScript' `
    -ScriptString 'Install-WindowsFeature -Name Web-Server -IncludeManagementTools'

# Get public IP to connect
$publicIp = Get-AzPublicIpAddress -ResourceGroupName 'rg-rfdemo-prod' -Name 'pip-rfdemo-web01'
Write-Host "VM Public IP: $($publicIp.IpAddress)" -ForegroundColor Green
Write-Host "RDP: Connect using Remote Desktop to $($publicIp.IpAddress):3389" -ForegroundColor Yellow
Write-Host "Web: Open browser to http://$($publicIp.IpAddress)" -ForegroundColor Yellow
```

## Cleanup Resources

When finished, remove all resources:

```powershell
# Remove the entire resource group (deletes all resources)
Remove-AzResourceGroup -Name 'rg-rfdemo-prod' -Force
```

## Key Benefits of This Approach

1. **Simplicity**: Single command creates everything needed
2. **Speed**: Much faster than creating each component individually
3. **Best Practices**: Automatically follows Azure naming and security conventions
4. **Error Prevention**: Less chance for configuration mistakes

## Common Parameters for New-AzVm

- `-Size`: VM size (default: Standard_DS1_v2)
- `-Credential`: Pre-create credentials instead of prompting
- `-Image`: OS image (Windows/Linux options available)
- `-OpenPorts`: Comma-separated list of ports to open
- `-Zone`: Availability zone (1, 2, or 3)

## Example with Custom VM Size

```powershell
New-AzVm `
    -ResourceGroupName 'rg-rfdemo-prod' `
    -Name 'vm-rfdemo-app01' `
    -Location 'eastus' `
    -Size 'Standard_B2ms' `
    -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' `
    -VirtualNetworkName 'vnet-rfdemo-prod' `
    -SubnetName 'snet-rfdemo-app' `
    -SecurityGroupName 'nsg-rfdemo-app' `
    -PublicIpAddressName 'pip-rfdemo-app01' `
    -OpenPorts 80,443,3389
```

## Troubleshooting

- **Authentication errors**: Run `Connect-AzAccount` again
- **Permission errors**: Ensure you have Contributor role on the subscription
- **VM size not available**: Try different regions or VM sizes
- **Name conflicts**: Use unique names or add random numbers to resource names