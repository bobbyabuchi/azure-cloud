# list the names of all subnets contained within all vnets
az network vnet list --query [].subnets[].name

# change the next-hop IP address whithin an existing route table
az network route-table route update
