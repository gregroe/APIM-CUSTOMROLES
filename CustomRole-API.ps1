#Custom  Role Definition for APIM apis
#Use for fine grain RBAC read/write access for individual APIs
#1. Assumes you have Created AAD Security Group for the API DevTeam
#2.Create an API in the APIM Service.
#3. Take Note the APIM Service Name, the Resource Group Name, and the API Name

#login to subscription
#Login-AzAccount

#define input parameters

$RG = 'APIM'  #YOUR RESOURCE GROUP NAME
$APIM_SVC_NAME = 'APIM-CONTOSO'#YOUR APIM SERVICE NAME
$API_NAME = 'api4' # the name of the APIM Product or API you want to assign a custom role to
$CUSTOM_ROLENAME = 'APIM Mgmt Access ' + $APIM_SVC_NAME + " " +  $API_NAME  #The Custom Role Name you want to use
$AADGroupName = 'api4DevTeam' 

#AAD Group role assisngment.  In the case you want to Assign a custom role to a particular AAD Security Group. get the AAD group objectId.
#users in that group will assume those custom role permissions 
$AADgroupinfo = Get-AzADGroup -DisplayNameStartsWith $AADGroupName
$AssignableObjectId = $AADgroupinfo.Id

#Get the APIM Service instance context
$apimContext = New-AzApiManagementContext -ResourceGroupName $RG -ServiceName $APIM_SVC_NAME

#API Guid . In the case you want to assign custom role to a particular APIM API
$ApiId = Get-AzApiManagementApi -Context $apimContext -ApiId $API_NAME
$AssignableScope = $ApiId.Id

#Create the Custom Role Definition
$role = Get-AzRoleDefinition "API Management Service Reader Role"
$role.Id = $null
$role.Name = $CUSTOM_ROLENAME
$role.Description = 'Has read access to APIM-Contoso instance and write access to ' + $API_NAME
$role.Actions.Add('Microsoft.ApiManagement/service/apis/write')
$role.Actions.Add('Microsoft.ApiManagement/service/apis/*/write')
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add($AssignableScope)
New-AzRoleDefinition -Role $role

#Assign Custom Role to AAD Group or User
New-AzRoleAssignment -ObjectId $AssignableObjectId -RoleDefinitionName $CUSTOM_ROLENAME -Scope $AssignableScope

#Assign API Management Service Reader Role to AAD group
$AssignableScope = (Get-AzApiManagement -ResourceGroupName $RG -Name $APIM_SVC_NAME).Id
New-AzRoleAssignment -ObjectId $AssignableObjectId -RoleDefinitionName 'API Management Service Reader Role' -Scope $AssignableScope




############################ utility functions ################################################################

#list assigned roled to user
#Get-AzRoleAssignment -ObjectId $user_ObjectId   

#get id of api   
#az apim api list --resource-group APIM --service-name APIM-Contoso  

#remove custom role assignment and delete custom role definition
#Remove-AzRoleAssignment -ObjectId 44f4add8-3c83-406e-8502-d633e601b08d -RoleDefinitionName "Product3api3 API Contributor" -Scope /subscriptions/2d3ae17e-28f2-4dc4-afb0-cb254d888ef2/resourceGroups/APIM/providers/Microsoft.ApiManagement/service/APIM-CONTOSO/apis/product3api3
#Remove-AzRoleAssignment -ObjectId $user_ObjectId -RoleDefinitionName $CUSTOM_ROLENAME + " Contributor" -Scope $AssignableScope  #this works see the sample above

#Get a list of all Custom Role Definitions
#Get-AzRoleDefinition | FT Name, IsCustom    #List Custom roles in Subscription

#Delete a custom role
#Get-AzRoleDefinition $CUSTOM_ROLENAME | Remove-AzRoleDefinition  

#update Custom Role Definition
#$role = Get-AzRoleDefinition $CUSTOM_ROLENAME
#$role.Actions.Add("Microsoft.ApiManagement/service/*/read")
#$role.Actions.Add("Microsoft.ApiManagement/service/read")
#Set-AzRoleDefinition -Role $role
                 