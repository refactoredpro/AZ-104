# Student Lab Guide: Adding a Data Disk to an Existing Windows VM

## Lab Overview
In this lab, you will learn how to expand storage capacity for your Windows virtual machine by adding and configuring a new data disk. This is essential for managing growing storage requirements.

## Learning Objectives
By the end of this lab, you will be able to:
- Create and attach a new data disk through the Azure Portal
- Connect to a Windows VM using Remote Desktop
- Initialize and format a new disk in Windows
- Verify the disk is ready for use

## Prerequisites
- Access to an Azure subscription
- An existing Windows VM in Azure (running or stopped)
- Remote Desktop Protocol (RDP) client installed on your computer
- Basic familiarity with Windows disk management

## Time Required
Approximately 20-30 minutes

---

## Part 1: Create and Attach the Data Disk

### Step 1: Navigate to Your VM
1. Open the **Azure Portal** (portal.azure.com)
2. Sign in with your Azure credentials
3. Go to **"Virtual Machines"** from the left menu or search bar
4. Find and click on your Windows VM from the list

### Step 2: Access Disk Management
1. In your VM's left sidebar, find the **"Settings"** section
2. Click on **"Disks"**
3. You'll see your current disks:
   - **OS disk** (usually named something like "myVM_OsDisk_...")
   - Any existing **data disks**

### Step 3: Add a New Disk
1. At the top of the Disks page, click **"+ Create and attach a new disk"**
2. A new row will appear for disk configuration

### Step 4: Configure the New Disk
Fill out the disk settings:
- **Disk name**: Enter a descriptive name (e.g., "myVM-datadisk-01")
- **Source type**: Select **"None (empty disk)"**
- **Size (GiB)**: Choose your desired size
  - **For this lab**: Use **128 GB** (good for practice)
  - **Production**: Size based on your needs
- **Account type**: Select storage performance:
  - **Standard HDD**: Lowest cost, good for backups
  - **Standard SSD**: Better performance, moderate cost
  - **Premium SSD**: Highest performance (requires compatible VM size)
- **Encryption**: Leave as default unless you have specific requirements

### Step 5: Apply Changes
1. Click **"Apply"** at the top of the page
2. Wait for the deployment to complete (usually 2-3 minutes)
3. You should see your new disk appear in the list

---

## Part 2: Connect to Your VM

### Step 6: Start Your VM (if needed)
1. If your VM is stopped, click **"Start"** from the VM overview page
2. Wait for the status to change to **"Running"**

### Step 7: Get Connection Information
1. From your VM overview page, click **"Connect"**
2. Select **"RDP"** from the dropdown
3. Click **"Download RDP File"**
4. Save the file to your computer

### Step 8: Connect via Remote Desktop
1. Open the downloaded RDP file
2. Click **"Connect"** when prompted
3. Enter your VM credentials:
   - **Username**: Your VM admin username
   - **Password**: Your VM admin password
4. Click **"OK"**
5. If you see a certificate warning, click **"Yes"** to continue

---

## Part 3: Initialize and Format the New Disk

### Step 9: Open Disk Management
1. Once connected to your VM, right-click on **"This PC"** (on desktop or in File Explorer)
2. Select **"Manage"** from the context menu
3. In the Computer Management window, click **"Disk Management"** in the left panel

### Step 10: Initialize the New Disk
1. You should see a popup window asking to **"Initialize Disk"**
   - If you don't see this popup, right-click on the unallocated disk (usually "Disk 2") and select **"Initialize Disk"**
2. In the Initialize Disk window:
   - **Disk selection**: Your new disk should be checked
   - **Partition style**: Select **"GPT (GUID Partition Table)"**
3. Click **"OK"**

### Step 11: Create a New Volume
1. Right-click on the **unallocated space** of your new disk
2. Select **"New Simple Volume..."**
3. The New Simple Volume Wizard will open

### Step 12: Configure the Volume
Follow the wizard steps:

**Step 12a: Volume Size**
- **Volume size**: Leave as maximum (uses full disk) or specify custom size
- Click **"Next"**

**Step 12b: Drive Letter**
- **Assign drive letter**: Choose an available letter (e.g., **E:**)
- Click **"Next"**

**Step 12c: Format Settings**
- **File system**: Select **"NTFS"**
- **Allocation unit size**: Leave as **"Default"**
- **Volume label**: Enter a name (e.g., "DataDisk" or "Storage")
- **Perform a quick format**: Leave checked ✅
- **Enable file and folder compression**: Usually leave unchecked
- Click **"Next"**

### Step 13: Complete the Process
1. Review your settings in the summary
2. Click **"Finish"**
3. The formatting process will begin (usually takes 1-2 minutes)

---

## Part 4: Verify and Test the New Disk

### Step 14: Confirm Disk is Available
1. Open **"File Explorer"** (Windows key + E)
2. Look in **"This PC"**
3. You should see your new drive with the assigned letter (e.g., "DataDisk (E:)")

### Step 15: Test the Disk
1. Double-click on your new drive to open it
2. Try creating a new folder:
   - Right-click in the empty space
   - Select **"New"** → **"Folder"**
   - Name it "Test Folder"
3. Create a test file inside the folder to verify write permissions

### Step 16: Check Disk Properties
1. Right-click on your new drive in File Explorer
2. Select **"Properties"**
3. Verify:
   - **Capacity**: Matches what you configured
   - **File system**: Shows NTFS
   - **Available space**: Should be nearly full capacity

---

## Optional: Enable Encryption on New Disk

If you completed the disk encryption lab previously and want to encrypt this new disk:

### Step 17: Return to Azure Portal
1. Minimize your RDP session (don't close it)
2. Go back to Azure Portal → Your VM → **"Disks"**

### Step 18: Enable Encryption
1. If encryption isn't automatically applied, look for encryption options
2. Your new data disk should be included in the next encryption cycle
3. Follow the same encryption process from the previous lab if needed

---

## Troubleshooting Common Issues

### Issue 1: New disk doesn't appear in Disk Management
- **Solution**: Try refreshing Disk Management (Action → Refresh)
- If still not visible, restart the VM

### Issue 2: "Disk already initialized" error
- **Solution**: The disk was already initialized; skip to creating a new volume

### Issue 3: Cannot format the disk
- **Solution**: Ensure you have administrator privileges
- Try running Disk Management as administrator

### Issue 4: RDP connection fails
- **Solution**: Verify VM is running and NSG allows RDP (port 3389)
- Check that you're using the correct username/password

---

## Lab Validation

To confirm successful completion:
1. ✅ New data disk visible in Azure Portal under VM → Disks
2. ✅ Disk appears in Windows Disk Management as healthy
3. ✅ New drive visible in File Explorer with assigned letter
4. ✅ Can create files and folders on the new drive
5. ✅ Disk properties show correct size and NTFS format

## Key Takeaways
- Azure allows dynamic addition of data disks without VM downtime
- New disks must be initialized and formatted before use
- GPT partition style is recommended for disks larger than 2TB
- Different storage types offer different performance and cost characteristics
- Always test disk operations in non-production environments first

## Best Practices Learned
- Use descriptive names for disks and volumes
- Choose appropriate storage type based on performance requirements
- Consider encryption for sensitive data
- Plan disk sizes based on growth projections
- Regular backups are essential for data protection