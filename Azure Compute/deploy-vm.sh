#!/bin/bash

# Simple Azure VM Deployment Script
# Edit the variables below to customize your deployment

set -e  # Exit on any error

# =============================================================================
# CONFIGURATION - EDIT THESE VALUES
# =============================================================================

RESOURCE_GROUP_NAME="rg-vm-demo"
LOCATION="East US"
VM_NAME="vm-demo-001"
ADMIN_USERNAME="azureuser"

# VM Configuration
VM_SIZE="Standard_B2s"  # 2 vCPUs, 4GB RAM
IMAGE="Ubuntu2204"      # Ubuntu 22.04 LTS
OS_DISK_SIZE_GB="30"

# Network Configuration
VNET_NAME="vnet-demo"
SUBNET_NAME="subnet-demo"
NSG_NAME="nsg-demo"
PUBLIC_IP_NAME="pip-demo"
NIC_NAME="nic-demo"

# Network Address Spaces
VNET_ADDRESS_PREFIX="10.0.0.0/16"
SUBNET_ADDRESS_PREFIX="10.0.1.0/24"

# SSH Key (will be generated automatically)
SSH_KEY_PATH="$HOME/.ssh/azure_vm_key"

# =============================================================================
# FUNCTIONS
# =============================================================================

print_status() {
    echo "▶ $1"
}

print_success() {
    echo "✓ $1"
}

print_error() {
    echo "✗ $1" >&2
}

check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first."
        exit 1
    fi
}

login_check() {
    print_status "Checking Azure login status..."
    if ! az account show &> /dev/null; then
        print_status "Not logged in. Please log in to Azure..."
        az login
    fi
    print_success "Azure login verified"
}

generate_ssh_key() {
    if [ ! -f "$SSH_KEY_PATH" ]; then
        print_status "Generating SSH key pair..."
        ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "azure-vm-key"
        print_success "SSH key generated: $SSH_KEY_PATH"
    else
        print_success "SSH key already exists: $SSH_KEY_PATH"
    fi
}

create_resource_group() {
    print_status "Creating resource group: $RESOURCE_GROUP_NAME"
    az group create \
        --name "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --output table
    print_success "Resource group created"
}

create_virtual_network() {
    print_status "Creating virtual network: $VNET_NAME"
    az network vnet create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$VNET_NAME" \
        --address-prefix "$VNET_ADDRESS_PREFIX" \
        --subnet-name "$SUBNET_NAME" \
        --subnet-prefix "$SUBNET_ADDRESS_PREFIX" \
        --output table
    print_success "Virtual network created"
}

create_network_security_group() {
    print_status "Creating network security group: $NSG_NAME"
    az network nsg create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$NSG_NAME" \
        --output table

    print_status "Adding SSH rule to NSG..."
    az network nsg rule create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --nsg-name "$NSG_NAME" \
        --name "SSH" \
        --protocol tcp \
        --priority 1001 \
        --destination-port-range 22 \
        --access allow \
        --output table

    print_status "Adding HTTP rule to NSG..."
    az network nsg rule create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --nsg-name "$NSG_NAME" \
        --name "HTTP" \
        --protocol tcp \
        --priority 1002 \
        --destination-port-range 80 \
        --access allow \
        --output table

    print_success "Network security group configured"
}

create_public_ip() {
    print_status "Creating public IP: $PUBLIC_IP_NAME"
    az network public-ip create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$PUBLIC_IP_NAME" \
        --sku Standard \
        --allocation-method Static \
        --output table
    print_success "Public IP created"
}

create_network_interface() {
    print_status "Creating network interface: $NIC_NAME"
    az network nic create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$NIC_NAME" \
        --vnet-name "$VNET_NAME" \
        --subnet "$SUBNET_NAME" \
        --public-ip-address "$PUBLIC_IP_NAME" \
        --network-security-group "$NSG_NAME" \
        --output table
    print_success "Network interface created"
}

create_virtual_machine() {
    print_status "Creating virtual machine: $VM_NAME"
    az vm create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$VM_NAME" \
        --size "$VM_SIZE" \
        --image "$IMAGE" \
        --admin-username "$ADMIN_USERNAME" \
        --ssh-key-values "$SSH_KEY_PATH.pub" \
        --nics "$NIC_NAME" \
        --os-disk-size-gb "$OS_DISK_SIZE_GB" \
        --storage-sku Premium_LRS \
        --output table
    print_success "Virtual machine created"
}

show_connection_info() {
    print_status "Getting connection information..."
    
    PUBLIC_IP=$(az network public-ip show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$PUBLIC_IP_NAME" \
        --query ipAddress \
        --output tsv)
    
    echo ""
    echo "🎉 VM Deployment Complete!"
    echo "=========================="
    echo "Resource Group: $RESOURCE_GROUP_NAME"
    echo "VM Name: $VM_NAME"
    echo "Location: $LOCATION"
    echo "Size: $VM_SIZE"
    echo "Admin Username: $ADMIN_USERNAME"
    echo "Public IP: $PUBLIC_IP"
    echo ""
    echo "SSH Connection Command:"
    echo "ssh -i $SSH_KEY_PATH $ADMIN_USERNAME@$PUBLIC_IP"
    echo ""
    echo "To delete all resources when done:"
    echo "az group delete --name $RESOURCE_GROUP_NAME --yes"
    echo ""
}

# =============================================================================
# MAIN SCRIPT
# =============================================================================

echo "🚀 Starting Azure VM Deployment"
echo "==============================="
echo "VM Name: $VM_NAME"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION"
echo "Size: $VM_SIZE"
echo ""

# Pre-flight checks
check_azure_cli
login_check
generate_ssh_key

# Create all resources
create_resource_group
create_virtual_network
create_network_security_group
create_public_ip
create_network_interface
create_virtual_machine

# Show how to connect
show_connection_info