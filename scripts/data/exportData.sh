sfdx force:data:tree:export --query \
    "SELECT Name, ParentId FROM BusinessBrand" \
    --outputdir data --plan
