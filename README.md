# Salesforce Consent Tools

[![Github Workflow](https://github.com/tegeling/ConsentTools/actions/workflows/scratch-org-sfdx-ci-master.yml/badge.svg?branch=main)](https://github.com/tegeling/ConsentTools/actions/workflows/scratch-org-sfdx-ci-master.yml)
[![codecov](https://codecov.io/gh/tegeling/ConsentTools/branch/main/graph/badge.svg?token=LEWOTO1743)](https://codecov.io/gh/tegeling/ConsentTools)

Manage consent settings and view historical consent data.
Enrich your user interface with a Lightning Web Component to easily change consent setting and opt in or opt out. Supports both internal and external access.

# ConsentSettings web component

# Setup and Configuration Steps

## Deploy Metadata

### Installing the app using a Scratch Org

1. Set up your environment including:

   - Enable Dev Hub in your Trailhead Playground
   - Install Salesforce CLI
   - Install Visual Studio Code
   - Install the Visual Studio Code Salesforce extensions

1. If you haven't already done so, authorize your hub org and provide it with an alias (**devhub** in the command below):

   ```
   sfdx auth:web:login -d -a devhub
   ```

1. Clone the ConsentTools repository:

   ```
   git clone https://github.com/tegeling/ConsentTools
   cd ConsentTools
   ```

1. Create a scratch org and provide it with an alias (**Consent** in the command below):

   ```
   sfdx force:org:create -s -f config/project-scratch-def.json -a Consent
   ```

1. Push the app to your scratch org:

   ```
   sfdx force:source:push
   ```

1. Assign the **ConsentPerm** permission set to the default user:

   ```
   sfdx force:user:permset:assign -n ConsentPerm
   ```

1. Open the scratch org:

   ```
   sfdx force:org:open
   ```

### Installing the app using an Unlocked Package

Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org or if you don't want to install the local developement tools. You can use a non source-tracked orgs such as a free [Developer Edition Org](https://developer.salesforce.com/signup) or a [Trailhead Playground](https://trailhead.salesforce.com/).

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

1. Log in to your org

1. Click [https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5I000001eeyOQAQ](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5I000001eeyOQAQ) to install the MarketingCloudAssetConnector unlocked package in your org.

1. Select **Install for All Users**

1. In App Launcher, click **View All** then select the **Creative Assets** tab.
