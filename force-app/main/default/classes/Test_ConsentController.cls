/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-17-2022
 * @last modified by  : tegeling
 **/
@isTest(SeeAllData=false)
public with sharing class Test_ConsentController {
  @isTest
  static void doContactTest() {
    // setup test data
    Account a = new Account(Name = 'TestAccount');
    insert a;
    Individual i = new Individual(
      FirstName = 'TestFirstname',
      LastName = 'TestLastname'
    );
    insert i;
    Contact c = new Contact(
      AccountId = a.Id,
      FirstName = i.FirstName,
      LastName = i.LastName,
      IndividualId = i.Id
    );
    insert c;
    ContactPointEmail cpEmail = new ContactPointEmail(
      ParentId = i.Id,
      EmailAddress = 'test@gmail.com',
      IsPrimary = true
    );
    insert cpEmail;
    ContactPointPhone cpPhone = new ContactPointPhone(
      ParentId = i.Id,
      TelephoneNumber = '0123456',
      IsPrimary = true
    );
    insert cpPhone;
    DataUsePurpose dup = new DataUsePurpose(
      Name = 'DUP',
      CanDataSubjectOptOut = true
    );
    insert dup;
    ContactPointConsent cpcEmail = new ContactPointConsent(
      ContactPointId = cpEmail.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Email Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcEmail;
    ContactPointConsent cpcPhone = new ContactPointConsent(
      ContactPointId = cpPhone.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Phone Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcPhone;

    Test.startTest();
    ConsentWrapper response = ConsentController.getConsent(
      c.Id,
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)'
    );
    ContactPointConsent cpcEmailResponse = ConsentController.getContactPointConsent(
      cpEmail.Id,
      dup.Id
    );
    Test.stopTest();
  }
  @isTest
  static void doPersonAccountTest() {
    // setup test data
    // Check if PersonAccount record types exist
    List<RecordType> recordtypes = [
      SELECT Id, DeveloperName
      FROM RecordType
      WHERE SobjectType = 'Account' AND IsPersonType = TRUE
    ];
    if (recordtypes.size() == 0) {
      // no PersonAccount record types found
      return;
    }
    Individual i = new Individual(
      FirstName = 'TestFirstname',
      LastName = 'TestLastname'
    );
    insert i;
    Account a = new Account(
      FirstName = i.FirstName,
      LastName = i.LastName,
      RecordTypeId = recordtypes[0].Id,
      PersonIndividualId = i.Id
    );
    insert a;
    ContactPointEmail cpEmail = new ContactPointEmail(
      ParentId = i.Id,
      EmailAddress = 'test@gmail.com',
      IsPrimary = true
    );
    insert cpEmail;
    ContactPointPhone cpPhone = new ContactPointPhone(
      ParentId = i.Id,
      TelephoneNumber = '0123456',
      IsPrimary = true
    );
    insert cpPhone;
    DataUsePurpose dup = new DataUsePurpose(
      Name = 'DUP',
      CanDataSubjectOptOut = true
    );
    insert dup;
    ContactPointConsent cpcEmail = new ContactPointConsent(
      ContactPointId = cpEmail.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Email Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcEmail;
    ContactPointConsent cpcPhone = new ContactPointConsent(
      ContactPointId = cpPhone.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Phone Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcPhone;

    Test.startTest();
    ConsentWrapper response = ConsentController.getConsent(
      a.Id,
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)'
    );
    ContactPointConsent cpcEmailResponse = ConsentController.getContactPointConsent(
      cpEmail.Id,
      dup.Id
    );
    Test.stopTest();
  }
}
