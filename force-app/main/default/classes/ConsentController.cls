/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-30-2022
 * @last modified by  : tegeling
 **/
public with sharing class ConsentController {
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
      throw new ConsentController.ConsentException('Unsupported object');
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

    // Init CPT wrapper
    List<ConsentWrapper.ContactPointType> cptsWrapper = new List<ConsentWrapper.ContactPointType>();

    // Get Contact Point Address
    List<ContactPointAddress> cpsAddress = [
      SELECT Id, Name
      FROM ContactPointAddress
      WHERE ParentId = :individualId
      WITH SECURITY_ENFORCED
    ];
    ConsentWrapper.ContactPointType cptAddress = new ConsentWrapper.ContactPointType();
    cptAddress.id = 'Address';
    cptAddress.label = 'Address';
    cptAddress.icon = 'utility:home';
    cptAddress.color = 'background-color:' + rgbaAddress + ';';
    List<ConsentWrapper.ContactPoint> cpsAddressWrapper = new List<ConsentWrapper.ContactPoint>();

    for (ContactPointAddress cpAddress : cpsAddress) {
      ConsentWrapper.ContactPoint cpWrapper = new ConsentWrapper.ContactPoint();
      cpWrapper.id = cpAddress.Id;
      cpWrapper.label = cpAddress.Name;
      cpsAddressWrapper.add(cpWrapper);
    }
    cptAddress.cps = cpsAddressWrapper;
    if (cpsAddress.size() > 0) {
      cptsWrapper.add(cptAddress);
    }

    // Get Contact Point Email
    List<ContactPointEmail> cpsEmail = [
      SELECT Id, EmailAddress
      FROM ContactPointEmail
      WHERE ParentId = :individualId
      WITH SECURITY_ENFORCED
    ];
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
    if (cpsEmail.size() > 0) {
      cptsWrapper.add(cptEmail);
    }

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
    if (cpsPhone.size() > 0) {
      cptsWrapper.add(cptPhone);
    }

    // compile response
    ConsentWrapper response = new ConsentWrapper();
    response.dups = dupsWrapper;
    response.cpts = cptsWrapper;

    return response;
  }

  @AuraEnabled(cacheable=true)
  public static ContactPointConsent getContactPointConsentHistory(
    String contactPointId,
    String dataUsePurposeId,
    Datetime timeStamp
  ) {
    ContactPointConsent historicCPC = null;
    List<ContactPointConsent> cpc = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE
        ContactPointId = :contactPointId
        AND DataUsePurposeId = :dataUsePurposeId
      WITH SECURITY_ENFORCED
    ];
    if (cpc.size() == 1) {
      historicCPC = cpc[0];
      List<ConsentHistoryWrapper> cpch = new List<ConsentHistoryWrapper>();
      if (Test.isRunningTest()) {
        // simulate test data
        ConsentHistoryWrapper cpch1 = new ConsentHistoryWrapper();
        cpch1.contactPointConsentId = historicCPC.Id;
        cpch1.field = 'PrivacyConsentStatus';
        cpch1.newValue = 'OptOut';
        cpch1.oldValue = 'OptIn';
        cpch1.createdDate = datetime.newInstance(2020, 12, 1);
        ConsentHistoryWrapper cpch2 = new ConsentHistoryWrapper();
        cpch2.contactPointConsentId = historicCPC.Id;
        cpch2.field = 'PrivacyConsentStatus';
        cpch2.newValue = 'OptIn';
        cpch2.oldValue = 'OptOut';
        cpch2.createdDate = datetime.newInstance(2020, 5, 1);
        ConsentHistoryWrapper cpch3 = new ConsentHistoryWrapper();
        cpch3.contactPointConsentId = historicCPC.Id;
        cpch3.field = 'PrivacyConsentStatus';
        cpch3.newValue = 'OptOut';
        cpch3.oldValue = 'OptIn';
        cpch3.createdDate = datetime.newInstance(2020, 1, 1);
        cpch.add(cpch1);
        cpch.add(cpch2);
        cpch.add(cpch3);
      } else {
        List<ContactPointConsentHistory> cpchRecords = [
          SELECT
            Id,
            ContactPointConsentId,
            Field,
            CreatedDate,
            OldValue,
            NewValue
          FROM ContactPointConsentHistory
          WHERE
            ContactPointConsentId = :cpc[0].Id
            AND Field = 'PrivacyConsentStatus'
          WITH SECURITY_ENFORCED
          ORDER BY CreatedDate DESC
        ];
        for (ContactPointConsentHistory cpchRecord : cpchRecords) {
          ConsentHistoryWrapper cpchWrapper = new ConsentHistoryWrapper();
          cpchWrapper.contactPointConsentId = cpchRecord.ContactPointConsentId;
          cpchWrapper.field = cpchRecord.Field;
          cpchWrapper.newValue = (String) cpchRecord.NewValue;
          cpchWrapper.oldValue = (String) cpchRecord.OldValue;
          cpchWrapper.createdDate = cpchRecord.CreatedDate;
          cpch.add(cpchWrapper);
        }
      }
      for (ConsentHistoryWrapper curCPCH : cpch) {
        // compare create date with timeStamp
        if (curCPCH.createdDate > timeStamp) {
          historicCPC.PrivacyConsentStatus = curCPCH.oldValue;
        }
      }
      return historicCPC;
    }
    return null;
  }

  @AuraEnabled(cacheable=true)
  public static ContactPointConsent getContactPointConsent(
    String contactPointId,
    String dataUsePurposeId
  ) {
    List<ContactPointConsent> cpc = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE
        ContactPointId = :contactPointId
        AND DataUsePurposeId = :dataUsePurposeId
      WITH SECURITY_ENFORCED
    ];
    if (cpc.size() == 1) {
      return cpc[0];
    }
    return null;
  }
  @AuraEnabled
  public static void updateContactPointConsent(
    String contactPointConsentId,
    String privacyConsentStatus
  ) {
    if (!Schema.sObjectType.ContactPointConsent.isUpdateable()) {
      throw new ConsentController.ConsentException(
        'Insufficient permissions to update ContactPointConsent'
      );
    }
    ContactPointConsent cpc = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE Id = :contactPointConsentId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    cpc.PrivacyConsentStatus = privacyConsentStatus;
    update cpc;
  }
  @AuraEnabled
  public static String createContactPointConsent(
    String contactPointId,
    String dataUsePurposeId,
    String privacyConsentStatus
  ) {
    if (!Schema.sObjectType.ContactPointConsent.isCreateable()) {
      throw new ConsentController.ConsentException(
        'Insufficient permissions to create ContactPointConsent'
      );
    }
    String individualId;
    String cpName;
    if (contactPointId.startsWith('8lW')) {
      // Contact Point Address
      ContactPointAddress cpAddress = [
        SELECT ParentId, Name
        FROM ContactPointAddress
        WHERE Id = :contactPointId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      individualId = cpAddress.ParentId;
      cpName = cpAddress.Name;
    } else if (contactPointId.startsWith('9Vl')) {
      // Contact Point Email
      ContactPointEmail cpEmail = [
        SELECT ParentId, Name
        FROM ContactPointEmail
        WHERE Id = :contactPointId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      individualId = cpEmail.ParentId;
      cpName = cpEmail.Name;
    } else if (contactPointId.startsWith('0Ow')) {
      // Contact Point Phone
      ContactPointPhone cpPhone = [
        SELECT ParentId, Name
        FROM ContactPointPhone
        WHERE Id = :contactPointId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      individualId = cpPhone.ParentId;
      cpName = cpPhone.Name;
    } else {
      // unknown Contact Point
      throw new ConsentController.ConsentException(
        'Unknown Contact Point record'
      );
    }
    Individual i = [
      SELECT FirstName, LastName, OwnerId
      FROM Individual
      WHERE Id = :individualId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    DataUsePurpose dup = [
      SELECT Name
      FROM DataUsePurpose
      WHERE Id = :dataUsePurposeId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    // compose CPC Name
    String cpcName =
      i.FirstName +
      ' ' +
      i.LastName +
      ' - ' +
      cpName +
      ' - ' +
      dup.Name;
    ContactPointConsent cpc = new ContactPointConsent(
      Name = cpcName,
      ContactPointId = contactPointId,
      DataUsePurposeId = dataUsePurposeId,
      PrivacyConsentStatus = privacyConsentStatus,
      OwnerId = i.OwnerId
    );
    insert cpc;
    return cpc.Id;
  }
  public class ConsentException extends Exception {
  }
}
