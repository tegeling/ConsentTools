/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-17-2022
 * @last modified by  : tegeling
 **/
public without sharing class ConsentController {
  @AuraEnabled(cacheable=true)
  public static ConsentWrapper getConsent(
    String recordId,
    String rgbaEmail,
    String rgbaPhone,
    String rgbaAddress
  ) {
    // Check object
    String individualId;
    if (Id.valueOf(recordId).getSobjectType() == Contact.getSObjectType()) {
      // Get Individual Id from Contact
      Contact c = [
        SELECT IndividualId
        FROM Contact
        WHERE Id = :recordId
        WITH SECURITY_ENFORCED
      ];
      individualId = c.IndividualId;
    } else if (Id.valueOf(recordId).getSobjectType() == Lead.getSObjectType()) {
      // Get Individual Id from Lead
      Lead l = [
        SELECT IndividualId
        FROM Lead
        WHERE Id = :recordId
        WITH SECURITY_ENFORCED
      ];
      individualId = l.IndividualId;
    } else if (Id.valueOf(recordId).getSobjectType() == User.getSObjectType()) {
      User u = [
        SELECT ContactId
        FROM User
        WHERE Id = :recordId
        WITH SECURITY_ENFORCED
      ];
      Contact c = [
        SELECT IndividualId
        FROM Contact
        WHERE Id = :u.ContactId
        WITH SECURITY_ENFORCED
      ];
      individualId = c.IndividualId;
    } else if (
      Id.valueOf(recordId).getSobjectType() == Account.getSObjectType()
    ) {
      // check PersonAccount
      Account a = [
        SELECT PersonIndividualId
        FROM Account
        WHERE Id = :recordId
        WITH SECURITY_ENFORCED
      ];
      individualId = a.PersonIndividualId;
    } else {
      // Object is not supported
      return new ConsentWrapper();
    }

    // Get Data Use Purposes
    List<DataUsePurpose> dups = [
      SELECT Id, Name
      FROM DataUsePurpose
      WHERE CanDataSubjectOptOut = TRUE
      WITH SECURITY_ENFORCED
    ];
    List<ConsentWrapper.DataUsePurpose> dupsWrapper = new List<ConsentWrapper.DataUsePurpose>();

    for (DataUsePurpose dup : dups) {
      ConsentWrapper.DataUsePurpose dupWrapper = new ConsentWrapper.DataUsePurpose();
      dupWrapper.id = dup.Id;
      dupWrapper.label = dup.Name;
      dupsWrapper.add(dupWrapper);
    }

    // Get Contact Point Emails
    List<ContactPointEmail> cpsEmail = [
      SELECT Id, EmailAddress
      FROM ContactPointEmail
      WHERE ParentId = :individualId
      WITH SECURITY_ENFORCED
    ];
    List<ConsentWrapper.ContactPointType> cptsWrapper = new List<ConsentWrapper.ContactPointType>();
    ConsentWrapper.ContactPointType cptEmail = new ConsentWrapper.ContactPointType();
    cptEmail.id = 'Email';
    cptEmail.label = 'Email';
    cptEmail.icon = 'utility:email';
    cptEmail.color = 'background-color:' + rgbaEmail + ';';
    List<ConsentWrapper.ContactPoint> cpsEmailWrapper = new List<ConsentWrapper.ContactPoint>();

    for (ContactPointEmail cpEmail : cpsEmail) {
      ConsentWrapper.ContactPoint cpWrapper = new ConsentWrapper.ContactPoint();
      cpWrapper.id = cpEmail.Id;
      cpWrapper.label = cpEmail.EmailAddress;
      cpsEmailWrapper.add(cpWrapper);
    }
    cptEmail.cps = cpsEmailWrapper;
    cptsWrapper.add(cptEmail);

    // Get Contact Point Phone
    List<ContactPointPhone> cpsPhone = [
      SELECT Id, TelephoneNumber
      FROM ContactPointPhone
      WHERE ParentId = :individualId
      WITH SECURITY_ENFORCED
    ];
    ConsentWrapper.ContactPointType cptPhone = new ConsentWrapper.ContactPointType();
    cptPhone.id = 'Phone';
    cptPhone.label = 'Phone';
    cptPhone.icon = 'utility:call';
    cptPhone.color = 'background-color:' + rgbaPhone + ';';
    List<ConsentWrapper.ContactPoint> cpsPhonenWrapper = new List<ConsentWrapper.ContactPoint>();

    for (ContactPointPhone cpPhone : cpsPhone) {
      ConsentWrapper.ContactPoint cpWrapper = new ConsentWrapper.ContactPoint();
      cpWrapper.id = cpPhone.Id;
      cpWrapper.label = cpPhone.TelephoneNumber;
      cpsPhonenWrapper.add(cpWrapper);
    }
    cptPhone.cps = cpsPhonenWrapper;
    cptsWrapper.add(cptPhone);

    // compile response
    ConsentWrapper response = new ConsentWrapper();
    response.dups = dupsWrapper;
    response.cpts = cptsWrapper;

    return response;
  }
  @AuraEnabled(cacheable=true)
  public static ContactPointConsent getContactPointConsent(
    String contactPointId,
    String dataUsePurposeId
  ) {
    ContactPointConsent cpc = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE
        ContactPointId = :contactPointId
        AND DataUsePurposeId = :dataUsePurposeId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    return cpc;
  }
}
