#..COMPUTE....................................................

# create a windows virtual machine with arm template
az deployment group create --name <deployment-name> \
    --template-file <path-to-template-file> \
    --parameters '{"adminUsername": {"value": "<admin-username>"}, "adminPassword": {"value": "<admin-password>"}}' \
    --resource-group <resource-group-name>

#..move a VM to a different resource group, subscription & region

# deallocate the resources
az vm deadallocate --name myVM \
    --resource-group oldResourceGroup
# create the new resource group if none exists
az group create --name newResourceGroup \
    --location newRegion
# move the VM to new resource group
az vm create --name myVM \
    --resource-group newResourceGroup\
    --location newRegion \
    --source oldResourceGroup
az vm wait --name myVM\
    --resource-group oldResourceGroup --deleted

#..NETWORK....................................................

#..STORAGE....................................................

#..MONITOR....................................................

#..IAM....................................................