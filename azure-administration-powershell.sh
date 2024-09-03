#TODO Create an Azure Resource using scripts in Azure PowerShell 
# ========================================================================================================================

# 1. Use the New-AzVm cmdlet to create a VM.

New-AzVm 
    -ResourceGroupName learn-2827bde1-dfd2-4c89-a75f-969394dfb295 
    -Name "testvm-eus-01"
    -Credential (Get-Credential) 
    -Location "eastus"
    -Image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest 
    -OpenPorts 22
    -PublicIpAddressName "testvm-eus-01"

# 2. Create a username and password, then press Enter. PowerShell starts creating your VM.

# 3. The VM creation takes a few minutes to complete. When it's done, you can query it and assign the VM object to a variable ($vm).

$vm = (Get-AzVM -Name "testvm-eus-01" -ResourceGroupName learn-2827bde1-dfd2-4c89-a75f-969394dfb295)

# 4. Query the value to dump out the information about the VM.

$vm

# 5. You can reach into complex objects through a dot (.) notation. For example, to see the properties in the VMSize object associated with the HardwareProfile section, run the following command:

$vm.HardwareProfile

# 6. Or, to get information on one of the disks, run the following command:

$vm.StorageProfile.OsDisk

# 7. You can even pass the VM object into other cmdlets. For example, running the following command shows you all available sizes for your VM:

$vm | Get-AzVMSize

# 8. Now, run the following command to get your public IP address:

Get-AzPublicIpAddress -ResourceGroupName learn-2827bde1-dfd2-4c89-a75f-969394dfb295 -Name "testvm-eus-01"

# 9. With the IP address, you can connect to the VM with SSH. For example, if you used the username bob, and the IP address is 205.22.16.5, running this command would connect to the Linux machine:

ssh bobbyabuchi@52.142.8.185

#TODO Delete a VM

# To try out some more commands, let's delete the VM. First, we need to shut it down (enter Y if prompted to continue):

Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName

# When the VM has stopped, delete the VM by running the Remove-AzVM cmdlet (enter Y if prompted to continue):

Remove-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName

# Run this command to list all the resources in your resource group:

Get-AzResource -ResourceGroupName $vm.ResourceGroupName | Format-Table

# The Remove-AzVM command just deletes the VM. It doesn't clean up any of the other resources. At this point, we'd likely just delete the resource group itself and be done with it. However, let's run through the exercise to clean it up manually. You should see a pattern in the commands.

# 1. Delete the network interface:

$vm | Remove-AzNetworkInterface –Force

# 2. Delete the managed OS disks:

Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $vm.StorageProfile.OSDisk.Name | Remove-AzDisk -Force

# 3. Next, delete the virtual network:

Get-AzVirtualNetwork -ResourceGroupName $vm.ResourceGroupName | Remove-AzVirtualNetwork -Force

# 4. Delete the network security group:

Get-AzNetworkSecurityGroup -ResourceGroupName $vm.ResourceGroupName | Remove-AzNetworkSecurityGroup -Force

# 5. Finally, delete the public IP address:

Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Remove-AzPublicIpAddress -Force

#TODO Azure PowerShell Scripting 
# ===================================================================================================================

.\myScript.ps1

# variables declaration in PS 
$loc = "East US"
$iterations = 3

# variables ------------ can hold objects returned by cmdlets
$adminCredential = Get-Credential

# To work with the value stored in a variable
$loc = "East US"
New-AzResourceGroup -Name "MyResourceGroup" -Location $loc

# LOOPS ------- when you wan to execute a cmdlet a certain number of times.
For ($i = 1; $i -lt 3; $i++)
{
    $i
}

# samplePowerShellScript.ps1--------------------------------------------------------------------------
# cmdlet to execute
$cmdletToExecute = "Get-Process"

# Number of times to execute
$numberOfExecutions = 3

# Loop to execute the cmdlet multiple times
for ($i = 1; $i -lt $numberOfExecutions; $i++) {
    Write-Host "Executing cmdlet: $cmdletToExecute (Iteration: $i)"
    Invoke-Expression -Command $cmdletToExecute
    Write-Host "----------------------------------------"
}
Write-Host "Script completed."
# ----------------------------------------------------------------------------

# Parameters ---- ---- you can pass arguments on the command line

.\setupEnvironment.ps1 -size 5 -location "East US"

# Inside the script, you'll capture the values into variables. In this example, the parameters are matched by name:
param([string]$location, [int]$size)

# param names can be omitted from the command line. For example:
.\setupEnvironment.ps1 5 "East US"

# Inside the script, matching the parameters on position if unnamed
param([int]$size, [string]$location)


# Exercise - Create and save scripts in Azure PowerShell -------------------------------------------------------------

#* so when writing scripts inside Azure, instead of using nano, use
code "./powerShellScriptName.ps1"
#* The integrated Cloud Shell also supports vim, nano, and emacs if you'd prefer to use one of those editors.

#* Note: you'd have to authenticate with Azure using your credentials using Connect-AzAccount, 
#* but you're already authenticated in the Cloud Shell environment, so no need...

# In this scenerio, you'll continue with the example of a company that 
# makes Linux admin tools. Recall that you plan to use Linux VMs to let 
# potential customers test your software. You have a resource group ready, 
# and now it's time to create the VMs.

# Your company has paid for a booth at a large Linux trade show. 
# You plan a demo area containing three terminals each connected to a 
# separate Linux VM. At the end of each day, you want to delete the VMs 
# and re-create them so they start fresh every morning. Creating the VMs 
# manually after work when you're tired would be error prone. 
# You want to write a PowerShell script to automate the VM-creation process.

#* START OF POWERSHELL SCRIPT ----------------------------------------------------------------------------------------------
# first capture the input parameter in a variable
param([string]$resourceGroup)

# Prompt for a username and password for the VM's admin account and 
# capture the result in a variable:
$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."

# Create a loop that executes three times:
For ($i = 1; $i -le 3; $i++) 
{
    $vmName = "ConferenceDemo" + $i
    Write-Host "Creating VM: " $vmName
    # create a VM using the $vmName variable:
    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image
}
#* END OF POWERSHELL SCRIPT ----------------------------------------------------------------------------------------------

# Ctrl + S to save the file
# Save the file and close the editor using the "..." context menu on the top right of the editor (or use Ctrl + Q).

# Run the script.
./ConferenceDailyReset.ps1 learn-7bca179a-8b03-4daf-a243-a79abcf77afa

# The script will take several minutes to complete. When it's finished, verify it ran successfully by looking at the resources 
# you now have in your resource group:
Get-AzResource -ResourceType Microsoft.Compute/virtualMachines

# Remove Resource Group
Remove-AzResourceGroup -Name MyResourceGroupName

# End of Exercise ----------------------------------------------------------------------------------------------------

#TODO Deploy infrastructure with JSON Arm template
# =====================================================================================================================

#* Local ARM deployment
# this will require Azure PowerShell or CLI running locally on your PC

# 1. sign in to Azure using CLI or PowerShell
az login #CLI
Connect-AzAccount #PowerShel;

# 2. define a resource group or select an existing

#* CLI
az group create \
  --name {name of your resource group} \
  --location "{location}"

#* PowerShell
New-AzResourceGroup `
  -Name {name of your resource group} `
  -Location "{location}"

# 3. Start template deployment - ensure you have the latest version of CLI and PowerShell

#* CLI
templateFile="{provide-the-path-to-the-template-file}"
az deployment group create \
  --name blanktemplate \
  --resource-group myResourceGroup \
  --template-file $templateFile

#* PowerShell
$templateFile = "{provide-the-path-to-the-template-file}"
New-AzResourceGroupDeployment `
  -Name blanktemplate `
  -ResourceGroupName myResourceGroup `
  -TemplateFile $templateFile

#* templates can be linked to deploy complex solutions
#* you can also break down templates and deploy them through the main templates
#* when you deploy the main, it will trigger the linked template's deployment
#* you can store and secure the linked template with a SAS token
#* ARM template can be part of CI/CD - Azure Pipelines and Github Actions surpport this

#TODO Create and deploy an Azure Resource Manager template ====================================================

#* PowerShell
