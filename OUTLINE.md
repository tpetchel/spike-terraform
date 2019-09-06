## 1 - Introduction

TBD

## 2 - SCENARIO UNIT

* (Do we care about having a backlog of tasks for this LP?)
* PROBLEM STATEMENT - TBD
* Tim and Andy discuss options
    * Azure Resource Manager templates (We don't use the term "ARM")
      * In the summary, link to [Build Azure Resource Manager templates](https://docs.microsoft.com/en-us/learn/modules/build-azure-vm-templates/index)
    * Terraform
    * What else?
* Tim and Andy form a plan
  * They like Terraform because they still deploy some websites to their on-prem datacenter. Terraform would enable them to bridge their deployments from on-prem to Azure.

## 3 - How does Terraform work?

Andy explains to Tim how Terraform works.

Brainstorm of things to cover:

* Providers
* Resources
  * Azure-specific examples that you'll use in this module.
* Variables
* Outputs
  * I think when we run locally, the example should have an outputs section that prints the App Service endpoint. Learner uses that to see the default home page.
* Lifecycle
  * init
  * plan
  * apply
    * state files
      * local
      * remote
  * destroy
* Running Terraform through automation
  * Why you need a service principal

## 4 - Exercise - Provision Azure resources in Azure Pipelines by using Terraform

Tim and Andy decide to start by running Terraform "locally" (e.g. outside the pipeline) to get a feel for it.

Let's see about giving the learner a sandbox for this unit?

Steps:

1. `curl` down a basic TF plan that we provide.
1. Walk the learner through it - highlight the essential parts.

    (BTW, I submitted a request to engineering to add Terraform as a language that gets colorized correctly. Ping me to dig that up.)
1. `terraform init`
1. `terraform plan`
1. `terraform apply`

    Note the output - the App Service endpoint.
1. Visit App Service endpoint - verify the default home page.
1. `terraform destroy`

## 5 - Exercise - Set up your Azure DevOps environment

TBD, but like the others.

Include getting the sample repo that has a starter azure-pipelines.yml

## 6 - Exercise - Provision Azure resources in Azure Pipelines by using Terraform

* This one is done in the learner's Azure subscription.
* Remind the learner about LP3, where they learned about release pipelines, including stages.
* Here, you add a stage that provisions App Service instances.
  * Decision: All 4 (Dev, Test, Staging, Production), or just one for learning purposes?
* The _Build_ stage builds the _Space Game_ website. The Provisioning stage sets up the resources. Later stage(s) deploy to those environments.
  * Do that trick where you write back the Terraform outputs (the App Service endpoints) back to pipeline variables?
* Set up remote state, the service principal, pipeline variables, and the like.
* Push up the change and watch it run.
* Navigate to the App Service and see the _Space Game_ website. Rejoice.

## 7 - Exercise - Clean up your Azure DevOps environment

TBD, but like the others.

Be sure to tear down Azure resources.

## 8 - Summary

TBD

Link to resources:

* ARM templates (see ref to Learn module above)
* TF docs (relevant things shown in the module - Azure provider, backend config, and so on.)
