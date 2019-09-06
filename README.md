# spike-terraform

## Setup

1. Fork me!
1. Clone me.
1. Open a terminal window and sign in to Azure through the CLI.

    ```azurecli
    az login
    ```

## Run locally (using local state)

1. Switch to the `local` branch.

    ```bash
    git checkout local
    ```

1. Run Terraform.

    ```bash
    terraform init
    terraform apply -auto-approve
    ```

1. Verify the result (through the CLI, portal, etc.).
1. Run a second time.

    ```bash
    terraform apply -auto-approve
    ```

1. Tear it all down

    ```bash
    terraform destroy -auto-approve
    ```

## Run locally (using remote state)

1. Switch to the `remote` branch.

    ```bash
    git checkout remote
    ```

1. Create a storage account.

    ```azurecli
    az group create -n spike-tf-storage-rg -l westus
    az storage account create -n spiketfsa -g spike-tf-storage-rg -l westus --sku Standard_LRS
    ```

1. Create a storage container.

    ```azurecli
    az storage container create --account-name spiketfsa --name tfstate
    ```

1. Get your Blob Storage access key.

    ```azurecli
    ARM_ACCESS_KEY=$(az storage account keys list \
        --account-name spiketfsa \
        --query "[?keyName=='key1'][value]" \
        --output tsv)
    ```

1. Print it out

    ```bash
    echo $ARM_ACCESS_KEY
    ```

1. Export your Blob Storage access key.

    ```bash
    export ARM_ACCESS_KEY
    ```

1. Run Terraform.

    ```bash
    terraform init
    terraform apply -auto-approve
    ```

1. Tear it all down

    ```bash
    terraform destroy -auto-approve
    ```

## Run locally (using service principal)

1. Switch to the `remote` branch.

    ```bash
    git checkout remote
    ```

1. Get your subscription ID

    ```azurecli
    ARM_SUBSCRIPTION_ID=$(az account list --query "[?isDefault][id]" --all --output tsv)
    ```

1. Print it out.

    ```bash
    echo $ARM_SUBSCRIPTION_ID
    ```

1. Create a service principal.

    ```azurecli
    az ad sp create-for-rbac \
      --role="Contributor" \
      --scopes="/subscriptions/$ARM_SUBSCRIPTION_ID" \
      --name spike-tf-sp
    ```

    Note the output.

    ```json
    {
      "appId": "00000000-0000-0000-0000-000000000000",
      "displayName": "spike-tf-sp",
      "name": "http://spike-tf-sp",
      "password": "00000000-0000-0000-0000-000000000000",
      "tenant": "00000000-0000-0000-0000-000000000000"
    }
    ```

    These values will later map as:

    * `appId`: `ARM_CLIENT_ID`
    * `password`: `ARM_CLIENT_SECRET`
    * `tenant`: `ARM_TENANT_ID`

1. Export variables.

    ```bash
    export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
    export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
    export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
    export ARM_SUBSCRIPTION_ID
    ```

    This works on shells such as Zsh. For Bash, you need:

    ```bash
    export ARM\_CLIENT\_ID="00000000-0000-0000-0000-000000000000"
    export ARM\_CLIENT\_SECRET="00000000-0000-0000-0000-000000000000" 
    export ARM\_TENANT\_ID="00000000-0000-0000-0000-000000000000"
    export ARM\_SUBSCRIPTION\_ID
    ```

1. Run Terraform.

    ```bash
    terraform init
    terraform apply -auto-approve
    ```

1. Tear it all down

    ```bash
    terraform destroy -auto-approve
    ```

## Run in pipeline (using remote state)

1. Create an Azure DevOps project. I named mine "TF"
1. In Azure Pipelines, create a variable group named "Azure Credentials". Add these keys:
    * `arm_client_id`
    * `arm_client_secret`
    * `arm_subscription_id`
    * `arm_tenant_id`
1. Create a project in Azure Pipelines that's connected to this repo. Let it run the `master` branch. Watch it bring up infrastructure.
1. Manually trigger the pipeline. Watch it run, but not create or modify any resources.
1. In the Azure portal, delete the resource group **spike-tf-rg**.
1. Manually trigger the pipeline a second time. Watch it bring the infrastructure back up.
