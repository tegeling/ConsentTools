/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-20-2022
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
    ContactPointAddress cpAddress = new ContactPointAddress(
      ParentId = i.Id,
      Name = 'Mailing Address'
    );
    insert cpAddress;
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
  static void doContactNoCPSTest() {
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
    DataUsePurpose dup = new DataUsePurpose(
      Name = 'DUP',
      CanDataSubjectOptOut = true
    );
    insert dup;

    Test.startTest();
    ConsentWrapper response = ConsentController.getConsent(
      c.Id,
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)'
    );
    Test.stopTest();
  }
  @isTest
  static void doUnsupportedObjectTest() {
    // setup test data
    DataUsePurpose dup = new DataUsePurpose(
      Name = 'DUP',
      CanDataSubjectOptOut = true
    );
    insert dup;

    Test.startTest();
    ConsentWrapper response = ConsentController.getConsent(
      dup.Id,
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)'
    );
    Test.stopTest();
  }
  @isTest
  static void doUpdateContactPointConsentTest() {
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

    Test.startTest();
    ConsentController.updateContactPointConsent(cpcEmail.Id, 'OptIn');
    Test.stopTest();
  }
  @isTest
  static void doCreateContactPointConsentTest() {
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
    ContactPointAddress cpAddress = new ContactPointAddress(
      ParentId = i.Id,
      Name = 'Mailing Address'
    );
    insert cpAddress;
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

    Test.startTest();
    ConsentController.createContactPointConsent(cpAddress.Id, dup.Id, 'OptIn');
    ConsentController.createContactPointConsent(cpEmail.Id, dup.Id, 'OptIn');
    ConsentController.createContactPointConsent(cpPhone.Id, dup.Id, 'OptIn');
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
    ContactPointAddress cpAddress = new ContactPointAddress(
      ParentId = i.Id,
      Name = 'Mailing Address'
    );
    insert cpAddress;
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
    Test.stopTest();
  }
  @isTest
  static void doLeadTest() {
    // setup test data
    Individual i = new Individual(
      FirstName = 'TestFirstname',
      LastName = 'TestLastname'
    );
    insert i;
    Lead l = new Lead(
      FirstName = i.FirstName,
      LastName = i.LastName,
      IndividualId = i.Id
    );
    insert l;
    ContactPointAddress cpAddress = new ContactPointAddress(
      ParentId = i.Id,
      Name = 'Mailing Address'
    );
    insert cpAddress;
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
      l.Id,
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)',
      'rgba(0,0,0,0.1)'
    );
    Test.stopTest();
  }
}
