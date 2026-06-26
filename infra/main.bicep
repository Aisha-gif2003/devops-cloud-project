@description('Azure region for all resources')
param location string = resourceGroup().location

@description('Name of the Azure Container Registry (must be globally unique, alphanumeric only)')
param acrName string = 'devopscloudacr${uniqueString(resourceGroup().id)}'

@description('Name of the AKS cluster')
param aksClusterName string = 'devops-cloud-aks'

@description('DNS prefix for the AKS API server')
param dnsPrefix string = 'devopscloudaks'

@description('VM size for the AKS node pool (B2s_v2 fits Azure for Students free credit)')
param nodeVmSize string = 'Standard_B2s_v2'

@description('Number of nodes in the default AKS node pool')
param nodeCount int = 1

@description('Kubernetes version (leave empty to use AKS default)')
param kubernetesVersion string = ''

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: empty(kubernetesVersion) ? null : kubernetesVersion
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVmSize
        mode: 'System'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
      }
    ]
  }
}

@description('Grants the AKS cluster identity AcrPull access on the registry, so nodes can pull images without imagePullSecrets')
resource aksAcrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, aks.id, 'AcrPull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: aks.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
  }
}

output acrLoginServer string = acr.properties.loginServer
output acrName string = acr.name
output aksClusterName string = aks.name
