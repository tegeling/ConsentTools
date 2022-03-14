sfdx force:package:create --name "Consent Tools" --description "Manage consent settings and view historical consent data." --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername consent-tools

sfdx force:package:version:create --package "Consent Tools" --path force-app --installationkeybypass --wait 20 --codecoverage --targetdevhubusername consent-tools

sfdx force:package:version:promote --package "Consent Tools@1.0.0-1" --targetdevhubusername consent-tools

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5I000001eey9QAA
https://test.salesforce.com/packaging/installPackage.apexp?p0=04t5I000001eey9QAA

