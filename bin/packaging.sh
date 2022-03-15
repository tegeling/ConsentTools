sfdx force:package:create --name "Consent Tools" --description "Manage consent settings and view historical consent data." --packagetype Unlocked --path force-app --nonamespace --targetdevhubusername devhubWinter22

sfdx force:package:version:create --package "Consent Tools" --path force-app --installationkeybypass --skipancestorcheck --wait 20 --codecoverage --targetdevhubusername devhubWinter22

sfdx force:package:version:promote --package "Consent Tools@1.1.1-1" --targetdevhubusername devhubWinter22

https://login.salesforce.com/packaging/installPackage.apexp?p0=04t7Q000000DdvaQAC
https://test.salesforce.com/packaging/installPackage.apexp?p0=04t7Q000000DdvaQAC

