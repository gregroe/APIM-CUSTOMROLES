

Login-AzAccount

#Get-AzRoleDefinition -Name "API Management Service Reader Role" | ConvertTo-Json | Out-File "Your local path of choice\APIMAdminCustomRole_YOUR_PRODUCT_NAME.json"
Get-AzRoleDefinition -Name "API Management Service Reader Role" | ConvertTo-Json | Out-File c:\temp\APIMAdminCustomRole_echoproduct.json

#get the id of product in API Management

#$apimContext = New-AzApiManagementContext -ResourceGroupName "YourResource Group name under which API Management instance is present" -ServiceName "API Management service instance name"
#Get-AzApiManagementProduct -Context $apimContext -Title HR

$apimContext = New-AzApiManagementContext -ResourceGroupName APIM -ServiceName APIM-Contoso
Get-AzApiManagementProduct -Context $apimContext -Title echoproduct


#to create new role for the first time

#New-AzRoleDefinition -InputFile "Your local path of choice\APIMProductAdminCustomRole.json"
New-AzRoleDefinition -InputFile c:\temp\APIMConferenceAppAdminCustomRole_echoproduct.json

#this adds the Id automatically to role definition



#to retrive role definition ID in powershell object

#$role = Get-AzRoleDefinition "API Management Service Product Admin - HR/ Or name suitable to your requirement."
#$role
$role = Get-AzRoleDefinition "API Management Service Conference App echoproduct"
$role


#record Id and add to json file
#API Management Service Conference App echoproduct  81e5fac4-fd12-411b-8e7b-56b092247d50



#to update role for subsequent times

#Set-AzRoleDefinition -InputFile "Your local path of choice\APIMProductAdminCustomRole.json"
Set-AzRoleDefinition -InputFile "c:\temp\APIMConferenceAppAdminCustomRole_echoproduct.json"



#product specific scope level role will not be visible in the UI therefore assign using powershell - 

#Get-AzADUser -StartsWith "Your User name - can be Microsoft account or your Azure AD account"
Get-AzADUser -StartsWith baker

#record the ObjectId of the output 

# lad@m365x536742.onmicrosoft.com 099579a3-6f86-4be4-b920-d6946ade7757
# baker@m365x536742.onmicrosoft.com e0d88146-b36a-4891-924a-32d410448d7a



#get api management id to grant access to user

#$apim = Get-AzApiManagement -ResourceGroupName "YourResourceGroupName" -Name "YourAPI Management name"
#$apim.Id

$apim = Get-AzApiManagement -ResourceGroupName APIM -Name APIM-Contoso
$apim.Id




#assign role at resource scope level means at API Management level directly

#New-AzRoleAssignment -ObjectId "Object Id of your user" -RoleDefinitionName "Reader" -ResourceName "Your API Management namne" -ResourceType Microsoft.ApiManagement/service -ResourceGroupName "Your Resource group name"
#New-AzRoleAssignment  -SignInName "SignIn Name or UPN of your user" -RoleDefinitionName "API Management Service Product Admin - HR/ or name of your custom role from JSON" -Scope "completed Id of the product. Sample here - /subscriptions/SubscriptionId/resourceGroups/ResourceGroupName/providers/Microsoft.ApiManagement/service/API Management Name/products/ProductsName"

New-AzRoleAssignment -ObjectId e0d88146-b36a-4891-924a-32d410448d7a -RoleDefinitionName "Reader" -ResourceName "APIM-Contoso" -ResourceType Microsoft.ApiManagement/service -ResourceGroupName APIM
New-AzRoleAssignment  -SignInName baker@m365x536742.onmicrosoft.com -RoleDefinitionName "API Management Service Conference App echoproduct" -Scope "/subscriptions/2d3ae17e-28f2-4dc4-afb0-cb254d888ef2/resourceGroups/APIM/providers/Microsoft.ApiManagement/service/APIM-Contoso/products/echoproduct"



#to check level of access for a user on API Management use below powershell - custom roles will not be visible on the portal

#Get-AzRoleAssignment -ObjectId "Object Id of your user"
Get-AzRoleAssignment -ObjectId e0d88146-b36a-4891-924a-32d410448d7a

