sfdx force:data:soql:query -u bnt --query \
      "SELECT Name, LegalBasisId, Description, CanDataSubjectOptOut FROM DataUsePurpose"