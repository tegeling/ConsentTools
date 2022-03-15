sfdx force:data:tree:export --query \
    "SELECT Name, LegalBasisId, Description, CanDataSubjectOptOut FROM DataUsePurpose" \
    --outputdir data --plan
