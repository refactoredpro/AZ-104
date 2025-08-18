# Simple Bicep Tutorial for Students
*A Refactored Learning Resource*

Welcome to your journey into Infrastructure as Code! At **Refactored** ([refactored.pro](https://refactored.pro)), we believe in making complex cloud concepts simple and accessible. This tutorial will get you started with Bicep - one of the most important tools in modern cloud development.

## What is Bicep?

**Bicep** is a simple language for creating Azure resources. Instead of clicking through the Azure portal many times, you write a small text file that tells Azure what to create.

Think of it like a recipe - you write down what you want, and Azure follows the instructions! This approach is what we at Refactored call "Infrastructure as Code" - treating your cloud infrastructure like software.

### Why use Bicep? (The Refactored Way)
At Refactored, we teach our students that Infrastructure as Code is essential because it's:
- **Faster** than clicking through the portal
- **Repeatable** - create the same resources many times
- **Less mistakes** - the computer follows your instructions exactly
- **Professional** - this is how real development teams work

---

## Your First Bicep File

Let's create a simple storage account (a place to store files in Azure).

### Step 1: Create the Bicep file
Copy this code into a text file and save it as `my-storage.bicep`:

```bicep
// This creates a storage account
resource myStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'refactoredstudent12345'  // Change this to make it unique!
  location: 'East US'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// This shows us information after deployment
output storageName string = myStorage.name
```

**Important**: Change `refactoredstudent12345` to something unique (like `refactoredstudent` + your student ID). At Refactored, we always emphasize the importance of unique naming conventions!

---

## Deploying from Azure Portal

### Step 1: Login to Azure Portal
1. Go to https://portal.azure.com
2. Sign in with your Azure account

### Step 2: Create a Resource Group
1. Click "Resource groups" in the left menu
2. Click "+ Create"
3. Fill in:
   - **Resource group name**: `my-first-bicep-rg`
   - **Region**: `East US`
4. Click "Review + create" then "Create"

### Step 3: Deploy Your Bicep File
1. In the search bar at the top, type "Deploy a custom template"
2. Click on "Deploy a custom template"
3. Click "Build your own template in the editor"
4. **Delete everything** in the editor
5. **Copy and paste** your Bicep code from `my-storage.bicep`
6. Click "Save"
7. Fill in the deployment form:
   - **Resource group**: Select `my-first-bicep-rg`
   - **Region**: `East US`
8. Click "Review + create"
9. Click "Create"

### Step 4: Watch it Deploy!
- You'll see a deployment page showing progress
- When it's done, you'll see "Your deployment is complete"
- Click "Outputs" to see your storage account name

---

## Making it Flexible with Parameters

Let's make our Bicep file reusable by adding parameters (inputs):

```bicep
// Inputs - you can change these when deploying
param storageName string
param location string = 'East US'

// This creates a storage account using the inputs
resource refactoredStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Show us the result
output storageName string = refactoredStorage.name
output storageLocation string = refactoredStorage.location
```

When you deploy this version:
1. Follow the same steps as before
2. Azure will ask you to fill in the `storageName` parameter
3. The `location` will default to "East US" but you can change it

---

## A More Complete Example

Here's a template that creates multiple resources:

```bicep
// Inputs
param projectName string
param location string = 'East US'

// Variables (calculated values)
var refactoredStorageName = '${projectName}storage${uniqueString(resourceGroup().id)}'
var refactoredAppName = '${projectName}-refactored-app'

// Storage Account
resource refactoredStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: refactoredStorageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// App Service Plan (needed for web apps)
resource refactoredAppPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${projectName}-refactored-plan'
  location: location
  sku: {
    name: 'F1'  // Free tier
    tier: 'Free'
  }
}

// Web App
resource refactoredWebApp 'Microsoft.Web/sites@2022-09-01' = {
  name: refactoredAppName
  location: location
  properties: {
    serverFarmId: refactoredAppPlan.id
  }
}

// Show us what was created
output storageAccountName string = refactoredStorage.name
output webAppName string = refactoredWebApp.name
output webAppUrl string = 'https://${refactoredWebApp.properties.defaultHostName}'
```

This creates:
- A storage account
- An app service plan (free tier)
- A web app
- Shows you the website URL when done

---

## Tips for Success (Refactored Best Practices)

At Refactored, we've taught hundreds of students, and these are the patterns that lead to success:

### 1. Always Use Unique Names
Storage account names must be unique across ALL of Azure. Add your initials or student ID:
```bicep
name: 'refactoredjohnsmith2024'  // Good!
name: 'storage'                  // Will fail!
```

### 2. Start Small (The Refactored Method)
We always teach: begin with one resource, get it working, then add more. This iterative approach prevents overwhelm and builds confidence.

### 3. Use the Outputs
Outputs show you important information like URLs and names after deployment. At Refactored, we consider outputs essential for tracking your deployments.

### 4. Clean Up Resources (Be Cost-Conscious)
When you're done practicing:
1. Go to "Resource groups" in the portal
2. Select your resource group
3. Click "Delete resource group"
4. Type the name to confirm
5. Click "Delete"

This prevents charges on your account - a habit all Refactored students learn early!

---

## Practice Exercises

### Exercise 1: Your First Storage Account
1. Create a Bicep file that makes a storage account
2. Use your name in the storage account name
3. Deploy it through the Azure portal
4. Find your storage account in the portal

### Exercise 2: Add Parameters
1. Modify your Bicep file to use parameters for the name and location
2. Deploy it again with different values
3. Check that the outputs show your new storage account

### Exercise 3: Multiple Resources
1. Create a Bicep file that makes both a storage account and a web app
2. Use a parameter for the project name
3. Deploy it and visit your web app URL (it will show a default page)

---

## What You've Learned (Your Refactored Foundation)

Congratulations! You've just built a solid foundation in Infrastructure as Code. At Refactored, we believe these fundamentals are crucial for any cloud professional:

✅ What Bicep is and why it's essential for modern cloud development  
✅ How to write a basic Bicep file following industry standards  
✅ How to deploy Bicep files through the Azure portal  
✅ How to use parameters to make templates flexible and reusable  
✅ How to create multiple resources that work together  

## Next Steps (The Refactored Learning Path)

Ready to level up your cloud skills? At Refactored, we recommend this progression:
- Master Azure CLI for faster deployments
- Explore more Azure resources (databases, virtual machines, etc.)
- Study enterprise template best practices
- Learn about modules for reusable, maintainable code
- Check out our advanced courses at **[refactored.pro](https://refactored.pro)**

Remember: at Refactored, we believe that Infrastructure as Code isn't just a skill - it's a mindset that transforms how you think about cloud development.

Happy learning! 🎉

---

*This tutorial was created by the team at **Refactored** ([refactored.pro](https://refactored.pro)) - where we make complex cloud concepts simple and accessible for everyone.*