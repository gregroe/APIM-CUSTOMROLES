#Custome Role Definition for APIM apis
#Use for fine grain RBAC read/write access for individual APIs

#define input parameters
$UserName = 'user4' # THE USERNAME of the person you want to assign API Custom role access to
$RG = 'APIM'  #YOUR RESOURCE GROUP NAME
$APIM_SVC_NAME = 'APIM-CONTOSO'#YOUR APIM SERVICE NAME
$API_NAME = 'product4api'  #YOUR API NAME
$CUSTOM_ROLENAME = 'API Managment for' + $API_NAME  #The Custom Role Name you want to use

#login to subscription
Login-AzAccount

#get assignable scope which is the Id of the API
$apimContext = New-AzApiManagementContext -ResourceGroupName $RG -ServiceName $APIM_SVC_NAME
$ApiId = Get-AzApiManagementApi -Context $apimContext -ApiId $API_NAME
$AssignableScope = $ApiId.Id

#get the User objectId
$user_info = Get-AzADUser -StartsWith $UserName
$user_ObjectId = $user_info.Id

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

#Assign Custom Role to User
New-AzRoleAssignment -ObjectId $user_ObjectId -RoleDefinitionName $CUSTOM_ROLENAME -Scope $AssignableScope




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
                 