#!/bin/bash

DURATION=7

if [ "$#" -eq 1 ]; then
  DURATION=$1
fi

sfdx force:org:create -a ConsentToolsScratchOrg -s -f config/project-scratch-def.json -d $DURATION
sfdx force:source:push
sfdx force:user:permset:assign -n ConsentSettingsInternal
sfdx force:data:tree:import --plan ./data/Consent-plan.json
sfdx force:org:open -p /lightning/app/c__Consent_Management
echo "Org is set up"