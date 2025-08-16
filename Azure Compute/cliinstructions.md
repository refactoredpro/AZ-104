# Azure VM Deployment - Quick Steps

## Step 1: Access Azure Cloud Shell
1. Go to [portal.azure.com](https://portal.azure.com)
2. Click the **Cloud Shell icon** (>_) in the top toolbar
3. Choose **Bash** when prompted

## Step 2: Create the Script
```bash
nano deploy-vm.sh
```
Copy and paste the script content, then save with `Ctrl+X`, `Y`, `Enter`

## Step 3: Make it Executable
```bash
chmod +x deploy-vm.sh
```

## Step 4: Run the Script
```bash
./deploy-vm.sh
```

## Step 5: Connect to Your VM
Use the SSH command displayed at the end:
```bash
ssh -i ~/.ssh/azure_vm_key azureuser@<PUBLIC_IP>
```