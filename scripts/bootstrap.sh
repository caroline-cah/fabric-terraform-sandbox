#!/bin/bash
set -e

# ---- Azure tenant, GitHub account and service principal ----
SUBSCRIPTION_ID="codewithcaro-dev"
GITHUB_ORG="caroline-cah"
GITHUB_REPO="fabric-terraform-sandbox"
APP_NAME="fabric-iac-playground-sp"
# -----------------------

echo "🔐 Logging in to Azure"
az login
az account set --subscription "$SUBSCRIPTION_ID"

echo "📋 Creating Entra ID app registration"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
echo "App ID: $APP_ID"

echo "👤 Creating service principal"
SP_OBJECT_ID=$(az ad sp create --id "$APP_ID" --query id -o tsv)
echo "SP Object ID: $SP_OBJECT_ID"

echo "🔗 Creating federated credential (main branch)"
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
    \"name\": \"github-main\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:${GITHUB_ORG}/${GITHUB_REPO}:ref:refs/heads/main\",
    \"audiences\": [\"api://AzureADTokenExchange\"],
    \"description\": \"GitHub Actions OIDC for main branch\"
  }"

echo "🔑 Assigning Contributor role on subscription"
az role assignment create \
  --role "Contributor" \
  --subscription "$SUBSCRIPTION_ID" \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal

TENANT_ID=$(az account show --query tenantId -o tsv)