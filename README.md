# APIM-CUSTOMROLES

Used to define fine grained access control over  products and apis in a given APIM Service

One Group of api developers can control their own APIs and Products without other teams accidently deleting or changing 

Everyone can see all other products and APIs in the APIM Service but only those with correct access can make changes to their own APIs and Products

CustomRole-API.ps1    script to create custom role for an individual api

CustomRole-Product.pst script to creat  custom role for a product

workflow:

1. Create a couple Products in APIM
2. Creat a couple API in APIM
