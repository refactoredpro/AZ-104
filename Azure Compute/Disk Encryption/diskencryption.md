# Azure Portal Guide: Windows VM Disk Encryption & Disk Management

## Part 1: Configuring Disk Encryption on a Windows VM

### Prerequisites
- Azure subscription with appropriate permissions
- Windows VM already deployed in Azure
- VM must be running (encryption cannot be enabled on stopped VMs)

### Step-by-Step Instructions

#### Step 1: Create a Key Vault (if you don't have one)
1. Navigate to the **Azure Portal** (portal.azure.com)
2. Click **"+ Create a resource"**
3. Search for **"Key Vault"** and select it
4. Click **"Create"**
5. Fill out the required information:
   - **Subscription**: Select your subscription
   - **Resource Group**: Choose existing or create new
   - **Key Vault Name**: Enter a unique name
   - **Region**: Select same region as your VM
6. Go to the **"Access Policy"** tab
7. Under **"Enable Access to"**, check:
   - ✅ Azure Virtual Machines for deployment
   - ✅ Azure Resource Manager for template deployment
   - ✅ Azure Disk Encryption for volume encryption
8. Click **"Review + Create"** then **"Create"**

#### Step 2: Enable Disk Encryption on the VM
1. In the Azure Portal, navigate to **"Virtual Machines"**
2. Select your Windows VM from the list
3. In the left sidebar, under **"Settings"**, click **"Disks"**
4. At the top of the Disks blade, click **"Additional Settings"**
5. Click **"Enable encryption"**
6. In the encryption settings:
   - **Key Vault**: Select the Key Vault you created
   - **Key**: Leave as "Create new key" or select existing
   - **Encryption Type**: Choose "Encryption at rest with platform-managed key" or "customer-managed key"
   - **Volumes to encrypt**: Select "OS and data disks" or choose specific volumes
7. Click **"Save"**

#### Step 3: Monitor Encryption Progress
1. Return to your VM's **"Disks"** section
2. You'll see the encryption status showing **"Encrypting..."**
3. This process can take 30-60 minutes depending on disk size
4. Once complete, status will show **"Encrypted"**

---

## Part 2: Adding a Disk to an Existing Windows VM

### Step-by-Step Instructions

#### Step 1: Create and Attach the Data Disk
1. Navigate to your Windows VM in the Azure Portal
2. In the left sidebar, click **"Disks"** under **"Settings"**
3. Click **"+ Create and attach a new disk"**
4. Configure the new disk:
   - **Disk name**: Enter a descriptive name
   - **Source type**: Select **"None (empty disk)"**
   - **Size**: Choose appropriate size (e.g., 128 GB)
   - **Account type**: Select performance tier (Standard HDD, Standard SSD, or Premium SSD)
   - **Encryption**: Choose encryption type if different from default
5. Click **"Apply"** to save changes

#### Step 2: Connect to the VM and Initialize the Disk
1. From your VM overview page, click **"Connect"**
2. Choose your connection method (RDP recommended for Windows)
3. Download the RDP file and connect to your VM
4. Once logged in, right-click **"This PC"** and select **"Manage"**
5. In Computer Management, click **"Disk Management"** on the left

#### Step 3: Initialize and Format the New Disk
1. You should see a popup asking to initialize the new disk
   - If not, right-click the unallocated disk and select **"Initialize Disk"**
2. Choose **"GPT"** partition style and click **"OK"**
3. Right-click the unallocated space and select **"New Simple Volume"**
4. Follow the New Simple Volume Wizard:
   - **Volume size**: Use maximum available space or specify custom size
   - **Drive letter**: Assign a drive letter (e.g., E:)
   - **File system**: Choose **"NTFS"**
   - **Volume label**: Enter a descriptive name
5. Click **"Finish"**

#### Step 4: Verify the Disk is Ready
1. Open **"File Explorer"**
2. Verify the new drive appears with the assigned letter
3. The disk is now ready for use

### Optional: Enable Encryption on the New Data Disk
If you want to encrypt the new disk:
1. Return to Azure Portal → Your VM → **"Disks"**
2. Find your new data disk in the list
3. If encryption isn't already enabled, follow the encryption steps from Part 1
4. The new disk will be encrypted along with existing disks

---

## Important Notes

### Disk Encryption
- Encryption can take significant time (30+ minutes)
- VM performance may be temporarily impacted during encryption
- Always ensure you have backups before enabling encryption
- Some VM sizes and older generations don't support encryption

### Adding Disks
- You can add up to 64 data disks depending on VM size
- Premium SSD requires Premium Storage-capable VM sizes
- Consider proximity placement groups for multiple VMs sharing data

### Troubleshooting Tips
- If encryption fails, check that the VM is running and Key Vault permissions are correct
- For disk attachment issues, verify the VM size supports additional disks
- Always test disk operations in a non-production environment first