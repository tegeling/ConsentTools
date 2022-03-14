sfdx force:data:tree:export --query \
    "SELECT Name, Source, Description FROM DataUseLegalBasis" \
    --outputdir data --plan
