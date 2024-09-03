# list the names of all subnets contained within all vnets
az network vnet list --query [].subnets[].name
