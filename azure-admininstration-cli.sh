# list the names of all subnets contained within all vnets
az network vnet list --query [].subnets[].name

# change the next-hop IP address whithin an existing route table
az network route-table route update

# create a windows virtual machine with arm template
az deployment group create --name <deployment-name> --template-file <path-to-template-file> --parameters '{"adminUsername": {"value": "<admin-username>"}, "adminPassword": {"value": "<admin-password>"}}' --resource-group <resource-group-name>
