# Student Lab Guide: Creating and Configuring Azure Web Apps

## Lab Overview
In this lab, you will learn how to create, deploy, and configure a web application using Azure App Service. You'll explore key features like scaling, custom domains, SSL certificates, and monitoring capabilities.

## Learning Objectives
By the end of this lab, you will be able to:
- Create an Azure App Service and Web App
- Configure deployment settings and deploy sample code
- Set up custom application settings and connection strings
- Configure scaling and monitoring options
- Understand security and SSL certificate management
- Troubleshoot common web app issues

## Prerequisites
- Access to an Azure subscription
- Basic understanding of web applications
- Familiarity with the Azure Portal
- Optional: Basic knowledge of HTML/CSS for custom deployment

## Time Required
Approximately 60-75 minutes

---

## Part 1: Create the Web App

### Step 1: Navigate to Web App Creation
1. Open the **Azure Portal** (portal.azure.com)
2. Sign in with your Azure credentials
3. Click **"+ Create a resource"** (top-left corner)
4. Search for **"Web App"** in the search box
5. Select **"Web App"** from the results
6. Click **"Create"**

### Step 2: Configure Basic Settings
Fill out the **Basics** tab:

**Project Details:**
- **Subscription**: Select your assigned subscription
- **Resource Group**: Choose existing or click **"Create new"**
  - If creating new, name it: `rg-webapp-lab-[yourname]`

**Instance Details:**
- **Name**: Enter a unique name (e.g., `webapp-lab-yourname-001`)
  - **Note**: This becomes your URL: `https://yourappname.azurewebsites.net`
- **Publish**: Select **"Code"**
- **Runtime stack**: Choose **".NET 8 (LTS)"** (or your preferred stack)
- **Operating System**: Select **"Windows"** (easier for beginners)
- **Region**: Choose a region close to you (e.g., "East US")

### Step 3: Configure App Service Plan
**App Service Plan:**
- Click **"Create new"** if no plan exists
- **Name**: `asp-webapp-lab-[yourname]`
- **Pricing tier**: Click **"Explore pricing tiers"**
  - For this lab: Select **"Basic B1"** (provides good features for learning)
  - Click **"Apply"**

### Step 4: Review and Create
1. Click **"Review + Create"**
2. Review all settings for accuracy
3. Click **"Create"**
4. Wait for deployment (usually 2-3 minutes)
5. Click **"Go to resource"** when deployment completes

---

## Part 2: Explore and Test Your Web App

### Step 5: View Your Web App
1. On your Web App overview page, find the **"Default domain"**
2. Click on the URL (e.g., `https://yourapp.azurewebsites.net`)
3. You should see a default "Your web app is running and waiting for your content" page
4. **Bookmark this URL** for later testing

### Step 6: Explore the Web App Dashboard
Take time to explore these key sections in the left menu:

**Deployment:**
- **Deployment Center**: For connecting code repositories
- **Deployment slots**: For staging environments (Premium tiers)

**Settings:**
- **Configuration**: Application settings and connection strings
- **Authentication**: Identity and access management
- **Custom domains**: For your own domain names
- **TLS/SSL settings**: Certificate management

**Monitoring:**
- **Metrics**: Performance monitoring
- **Log stream**: Real-time application logs
- **Application Insights**: Advanced monitoring (if configured)

---

## Part 3: Deploy Sample Content

### Step 7: Deploy Using Local Git (Simple Method)
1. In your Web App, go to **"Deployment Center"** (under Deployment section)
2. Select **"Local Git"** as the source
3. Click **"Save"**
4. Note the **Git Clone URL** that appears

### Step 8: Set Up Deployment Credentials
1. Still in Deployment Center, click **"FTPS credentials"** tab
2. Under **User scope**, set:
   - **Username**: Choose a unique username
   - **Password**: Create a strong password
3. Click **"Save"**
4. **Write down these credentials** for later use

### Step 9: Deploy Sample HTML (Alternative Method)
For a simpler deployment without Git:

1. Go to **"Advanced Tools"** under Development Tools
2. Click **"Go →"** (opens Kudu console in new tab)
3. Navigate to **"Debug console"** → **"CMD"**
4. Navigate to `site/wwwroot/` folder
5. Delete the default `hostingstart.html` file
6. Create a new file called `index.html`
7. Add this sample content:

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Azure Web App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f8ff; }
        .container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
        h1 { color: #0066cc; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My Azure Web App!</h1>
        <p>This web app is running on Azure App Service.</p>
        <p>Deployed on: <span id="date"></span></p>
        <script>document.getElementById('date').textContent = new Date();</script>
    </div>
</body>
</html>
```

8. Save the file and return to your web app URL to see the changes

---

## Part 4: Configure Application Settings

### Step 10: Add Application Settings
1. Return to your Web App in the Azure Portal
2. Go to **"Environment Variables"** under Settings
3. In the **"Application settings"** tab, click **"+ New application setting"**
4. Add these sample settings:

**Setting 1:**
- **Name**: `ENVIRONMENT`
- **Value**: `Development`
- Click **"OK"**

**Setting 2:**
- **Name**: `APP_VERSION`
- **Value**: `1.0.0`
- Click **"OK"**

5. Click **"Save"** at the top
6. Click **"Continue"** when prompted about restart

### Step 11: Add Connection String (Practice)
1. Go to the **"Connection strings"** tab
2. Click **"+ New connection string"**
3. Configure a sample database connection:
   - **Name**: `DefaultConnection`
   - **Value**: `Server=myserver;Database=mydb;User Id=myuser;Password=mypass;`
   - **Type**: Select **"SQL Database"**
4. Click **"OK"**
5. Click **"Save"**

---

## Part 5: Configure Scaling and Performance

### Step 12: Explore Scaling Options
1. Go to **"Scale up (App Service plan)"** under Settings
2. Explore different pricing tiers:
   - **Basic**: Good for development and testing
   - **Standard**: Supports staging slots and custom domains
   - **Premium**: High performance, advanced security features
3. **Note**: Don't change the tier unless instructed (costs money)

### Step 13: Configure Scale Out (if using Standard or higher)
1. Go to **"Scale out (App Service plan)"** under Settings
2. Review auto-scaling options:
   - **Manual scale**: Set fixed instance count
   - **Custom autoscale**: Scale based on metrics like CPU usage
3. For this lab, leave settings as default

---

## Part 6: Monitoring and Diagnostics

### Step 14: Enable Application Logging
1. Go to **"App Service logs"** under Monitoring
2. Configure logging settings:
   - **Application logging (Filesystem)**: Turn **On**
   - **Level**: Select **"Information"**
   - **Web server logging**: Turn **On**
   - **Detailed error messages**: Turn **On**
   - **Failed request tracing**: Turn **On**
3. Click **"Save"**

### Step 15: View Live Logs
1. Go to **"Log stream"** under Monitoring and verify that you can view the log stream.

### Step 16: Review Metrics
1. Go to **"Metrics"** under Monitoring
2. Explore available metrics:
   - **Requests**: Number of HTTP requests
   - **Response time**: Application performance
   - **CPU percentage**: Resource usage
   - **Memory percentage**: Memory consumption
3. Click **"Add metric"** and select **"Requests"**
4. Set time range to **"Last 30 minutes"**


### Step 19: Explore Custom Domain Options
**Note**: This section is for learning only - don't purchase domains for the lab

1. Go to **"Custom domains"** under Settings
2. Click **"+ Add custom domain"**
3. Review the requirements:
   - You need to own a domain name
   - DNS configuration is required
   - SSL certificates can be added
4. Click **"Cancel"** (don't proceed unless you have a domain)

---

### General Notes on Testing and Performance

1. **Functionality Test**:
   - Visit your web app URL
   - Verify your custom content loads correctly
   - Test both HTTP→HTTPS redirect

2. **Performance Test**:
   - Use browser developer tools (F12)
   - Check loading times and resource usage
   - Review network requests

### Practice Troubleshooting
1. Go to **"Diagnose and solve problems"** under Support + troubleshooting
2. Explore available diagnostic tools:
   - **Availability and Performance**
   - **Configuration and Management**
   - **SSL and Domains**
3. Click on **"Availability and Performance"**
4. Review the health check results

## Lab Validation Checklist

Confirm successful completion by verifying:

**Basic Setup:**
- ✅ Web App created and accessible via default domain
- ✅ Custom HTML content deployed and visible
- ✅ Application settings configured correctly

**Configuration:**
- ✅ Logging enabled and log stream working
- ✅ HTTPS redirect functioning properly
- ✅ Metrics showing request data

**Security:**
- ✅ HTTPS Only enabled
- ✅ SSL certificate working (default *.azurewebsites.net)
- ✅ Application settings stored securely

**Monitoring:**
- ✅ Can view live logs and metrics
- ✅ Diagnostic tools accessible and functional

---

## Troubleshooting Common Issues

### Issue 1: Web app shows "Service Unavailable"
**Solutions:**
- Check if the App Service Plan has sufficient resources
- Review application logs for errors
- Verify deployment was successful

### Issue 2: Custom domain not working
**Solutions:**
- Verify DNS records are configured correctly
- Allow time for DNS propagation (up to 48 hours)
- Check custom domain configuration in portal

### Issue 3: SSL certificate errors
**Solutions:**
- Ensure HTTPS Only is configured properly
- For custom domains, verify SSL certificate is bound
- Check certificate expiration dates

### Issue 4: Application settings not taking effect
**Solutions:**
- Ensure you clicked "Save" after adding settings
- Restart the web app if necessary
- Check for typos in setting names

---

## Key Takeaways

**Azure App Service Benefits:**
- Fully managed platform-as-a-service (PaaS)
- Built-in scaling and load balancing
- Integrated security and compliance features
- Multiple deployment options and CI/CD support

**Best Practices Learned:**
- Always use HTTPS for production applications
- Implement proper logging and monitoring
- Use staging slots for safe deployments (Standard tier+)
- Configure auto-scaling based on demand
- Regular security updates and patching are automatic

**Cost Management:**
- Choose appropriate App Service Plan tier
- Monitor resource usage and scale appropriately
- Use deployment slots efficiently
- Consider serverless options (Azure Functions) for simple apps

---

## Next Steps and Additional Learning

**Explore Further:**
- Deploy from GitHub/Azure DevOps
- Configure custom domains with your own domain
- Set up Application Insights for advanced monitoring
- Implement authentication and authorization
- Create deployment slots for staging
- Integrate with Azure databases and storage

**Additional Resources:**
- Azure App Service documentation
- Azure DevOps integration tutorials
- Application Insights monitoring guides
- Azure security best practices

Congratulations! You've successfully created, configured, and deployed an Azure Web App with proper monitoring and security settings.