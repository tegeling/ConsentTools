/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
@isTest(SeeAllData=false)
public with sharing class Test_ConsentController {
  @isTest
  static void doContactGetConsentTest() {
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
    ContactPointConsent cpcAddress = new ContactPointConsent(
      ContactPointId = cpAddress.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Address Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcAddress;
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
    ConsentWrapper response = null;
    try {
      response = ConsentController.getConsent(
        c.Id,
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)'
      );
    } catch (Exception e) {
      system.assert(false, 'The getConsent method fails with exception');
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      1,
      response?.dups?.size(),
      'The DUP list size should be 1'
    );
    System.assertEquals(
      3,
      response?.cpts?.size(),
      'The CPT list size should be 3'
    );
  }
  @isTest
  static void doGetContactPointConsentTest() {
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
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;
    ContactPointConsent cpcEmail = new ContactPointConsent(
      ContactPointId = cpEmail.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Email Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcEmail;

    Test.startTest();
    ContactPointConsent cpcEmailResponse = null;
    try {
      cpcEmailResponse = ConsentController.getContactPointConsent(
        cpEmail.Id,
        dup.Id,
        bb.Id
      );
    } catch (Exception e) {
      system.assert(
        false,
        'The getContactPointConsent method fails with exception'
      );
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      'OptOut',
      cpcEmailResponse?.PrivacyConsentStatus,
      'Email Consent should be OptOut'
    );
  }
  @isTest
  static void doGetContactPointConsentNullTest() {
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
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;

    Test.startTest();
    ContactPointConsent cpcEmailResponse = null;
    try {
      cpcEmailResponse = ConsentController.getContactPointConsent(
        cpEmail.Id,
        dup.Id,
        bb.Id
      );
    } catch (Exception e) {
      system.assert(
        false,
        'The getContactPointConsent method fails with exception'
      );
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      null,
      cpcEmailResponse,
      'No Email Consent should be found'
    );
  }
  @isTest
  static void doGetContactPointConsentHistoryTest() {
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
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;
    ContactPointConsent cpcEmail = new ContactPointConsent(
      ContactPointId = cpEmail.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Email Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcEmail;

    Test.startTest();
    ContactPointConsent cpcEmail20200801 = null;
    ContactPointConsent cpcEmail20200301 = null;
    try {
      cpcEmail20200801 = ConsentController.getContactPointConsentHistory(
        cpEmail.Id,
        dup.Id,
        bb.Id,
        datetime.newInstance(2020, 8, 1)
      );
      cpcEmail20200301 = ConsentController.getContactPointConsentHistory(
        cpEmail.Id,
        dup.Id,
        bb.Id,
        datetime.newInstance(2020, 3, 1)
      );
    } catch (Exception e) {
      system.assert(
        false,
        'The getContactPointConsentHistory method fails with exception'
      );
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      'OptIn',
      cpcEmail20200801?.PrivacyConsentStatus,
      'Historical Email Consent should be OptIn'
    );
    System.assertEquals(
      'OptOut',
      cpcEmail20200301?.PrivacyConsentStatus,
      'Historical Email Consent should be OptOut'
    );
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
    ConsentWrapper response = null;
    try {
      response = ConsentController.getConsent(
        c.Id,
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)'
      );
    } catch (Exception e) {
      system.assert(false, 'The getConsent method fails with exception');
    }
    Test.stopTest();
    // check results
    System.assertEquals(
      1,
      response?.dups?.size(),
      'The DUP list size should be 1'
    );
    System.assertEquals(
      0,
      response?.cpts?.size(),
      'The CPT list size should be 0'
    );
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
    ConsentWrapper response = null;
    try {
      response = ConsentController.getConsent(
        dup.Id,
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)'
      );
    } catch (ConsentController.ConsentException e) {
      // check results
      String errorMsg = e.getMessage();
      system.assertEquals(
        'Unsupported object',
        errorMsg,
        'The updateContacts method fails with exception'
      );
    } catch (Exception e) {
      system.assert(false, 'The getConsent method fails with exception');
    }
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
    try {
      ConsentController.updateContactPointConsent(cpcEmail.Id, 'OptIn');
    } catch (Exception e) {
      system.assert(
        false,
        'The updateContactPointConsent method fails with exception'
      );
    }
    Test.stopTest();
    ContactPointConsent cpcEmailUpdate = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE Id = :cpcEmail.Id
      LIMIT 1
    ];
    System.assertEquals(
      'OptIn',
      cpcEmailUpdate?.PrivacyConsentStatus,
      'The consent should be OptIn'
    );
  }
  @isTest
  static void doUpdateContactPointConsentExceptionTest() {
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

    User u1 = createUser('Minimum Access - Salesforce');
    System.runAs(u1) {
      Test.startTest();
      try {
        ConsentController.updateContactPointConsent(cpcEmail.Id, 'OptIn');
      } catch (ConsentController.ConsentException e) {
        // check results
        String errorMsg = e.getMessage();
        system.assertEquals(
          'Insufficient permissions to update ContactPointConsent',
          errorMsg,
          'The updateContactPointConsent method fails with exception'
        );
      } catch (Exception e) {
        system.assert(
          false,
          'The updateContactPointConsent method fails with exception'
        );
      }
      Test.stopTest();
    }
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
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;

    Test.startTest();
    String cpcAddressId = null;
    String cpcEmailId = null;
    String cpcPhoneId = null;
    try {
      cpcAddressId = ConsentController.createContactPointConsent(
        cpAddress.Id,
        dup.Id,
        bb.Id,
        'OptIn'
      );
      cpcEmailId = ConsentController.createContactPointConsent(
        cpEmail.Id,
        dup.Id,
        bb.Id,
        'OptIn'
      );
      cpcPhoneId = ConsentController.createContactPointConsent(
        cpPhone.Id,
        dup.Id,
        bb.Id,
        'OptIn'
      );
    } catch (Exception e) {
      system.assert(
        false,
        'The createContactPointConsent method fails with exception'
      );
    }
    Test.stopTest();
    System.assert(cpcAddressId != null, 'The address consent is null');
    System.assert(cpcEmailId != null, 'The email consent is null');
    System.assert(cpcPhoneId != null, 'The phone consent is null');

    ContactPointConsent cpcAddress = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE Id = :cpcAddressId
      LIMIT 1
    ];
    ContactPointConsent cpcEmail = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE Id = :cpcEmailId
      LIMIT 1
    ];
    ContactPointConsent cpcPhone = [
      SELECT Id, PrivacyConsentStatus
      FROM ContactPointConsent
      WHERE Id = :cpcPhoneId
      LIMIT 1
    ];
    System.assertEquals(
      'OptIn',
      cpcAddress?.PrivacyConsentStatus,
      'The address consent should be OptIn'
    );
    System.assertEquals(
      'OptIn',
      cpcEmail?.PrivacyConsentStatus,
      'The email consent should be OptIn'
    );
    System.assertEquals(
      'OptIn',
      cpcPhone?.PrivacyConsentStatus,
      'The phone consent should be OptIn'
    );
  }
  @isTest
  static void doCreateContactPointConsentExceptionTest() {
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
    DataUsePurpose dup = new DataUsePurpose(
      Name = 'DUP',
      CanDataSubjectOptOut = true
    );
    insert dup;
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;
    User u1 = createUser('Minimum Access - Salesforce');
    System.runAs(u1) {
      Test.startTest();
      try {
        ConsentController.createContactPointConsent(
          cpAddress.Id,
          dup.Id,
          bb.Id,
          'OptIn'
        );
      } catch (ConsentController.ConsentException e) {
        // check results
        String errorMsg = e.getMessage();
        system.assertEquals(
          'Insufficient permissions to create ContactPointConsent',
          errorMsg,
          'The createContactPointConsent method fails with exception'
        );
      } catch (Exception e) {
        system.assert(
          false,
          'The createContactPointConsent method fails with exception'
        );
      }
      Test.stopTest();
    }
  }
  @isTest
  static void doCreateContactPointConsentUnknownTest() {
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
    BusinessBrand bb = new BusinessBrand(Name = 'ABC Brand');
    insert bb;
    Test.startTest();
    try {
      ConsentController.createContactPointConsent(
        dup.Id,
        dup.Id,
        bb.Id,
        'OptIn'
      );
    } catch (ConsentController.ConsentException e) {
      // check results
      String errorMsg = e.getMessage();
      system.assertEquals(
        'Unknown Contact Point record',
        errorMsg,
        'The createContactPointConsent method fails with exception'
      );
    } catch (Exception e) {
      system.assert(
        false,
        'The createContactPointConsent method fails with exception'
      );
    }
    Test.stopTest();
  }
  @isTest
  static void doPersonAccountGetConsentTest() {
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
    ContactPointConsent cpcAddress = new ContactPointConsent(
      ContactPointId = cpAddress.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Address Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcAddress;
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
    ConsentWrapper response = null;
    try {
      response = ConsentController.getConsent(
        a.Id,
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)'
      );
    } catch (Exception e) {
      system.assert(false, 'The getConsent method fails with exception');
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      1,
      response?.dups?.size(),
      'The DUP list size should be 1'
    );
    System.assertEquals(
      3,
      response?.cpts?.size(),
      'The CPT list size should be 3'
    );
  }
  @isTest
  static void doLeadGetConsentTest() {
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
    ContactPointConsent cpcAddress = new ContactPointConsent(
      ContactPointId = cpAddress.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Address Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcAddress;
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
    ConsentWrapper response = null;
    try {
      response = ConsentController.getConsent(
        l.Id,
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)',
        'rgba(0,0,0,0.1)'
      );
    } catch (Exception e) {
      system.assert(false, 'The getConsent method fails with exception');
    }
    Test.stopTest();

    // check results
    System.assertEquals(
      1,
      response?.dups?.size(),
      'The DUP list size should be 1'
    );
    System.assertEquals(
      3,
      response?.cpts?.size(),
      'The CPT list size should be 3'
    );
  }
  @isTest
  static void doUserGetConsentTest() {
    // setup test data
    User adminUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    UserRole userrole = new UserRole(
      DeveloperName = 'MyCustomRole',
      Name = 'My Role'
    );
    insert userrole;
    adminUser.UserRoleId = userRole.Id;
    update adminUser;
    User u1 = null;
    System.runAs(adminUser) {
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
      ContactPointConsent cpcAddress = new ContactPointConsent(
        ContactPointId = cpAddress.Id,
        DataUsePurposeId = dup.Id,
        Name = 'Address Consent',
        PrivacyConsentStatus = 'OptOut'
      );
      insert cpcAddress;
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
      u1 = createExternalUser('External Identity User', c.Id);
      i.OwnerId = u1.Id;
      update i;
      cpcAddress.OwnerId = u1.Id;
      update cpcAddress;
      cpcEmail.OwnerId = u1.Id;
      update cpcEmail;
      cpcPhone.OwnerId = u1.Id;
      update cpcPhone;
    }
    ConsentWrapper response = null;
    Test.startTest();
    System.runAs(u1) {
      try {
        response = ConsentController.getConsent(
          u1.Id,
          'rgba(0,0,0,0.1)',
          'rgba(0,0,0,0.1)',
          'rgba(0,0,0,0.1)'
        );
      } catch (ConsentController.ConsentException e) {
        // check results
        String errorMsg = e.getMessage();
        system.assertEquals(
          'Insufficient permissions to create ContactPointConsent',
          errorMsg,
          'The createContactPointConsent method fails with exception'
        );
      } catch (Exception e) {
        system.assert(
          false,
          'The createContactPointConsent method fails with exception'
        );
      }
    }
    Test.stopTest();
    // check results
    // need manual sharing rules to see DUP record
    System.assertEquals(
      1,
      response?.dups?.size(),
      'The DUP list size should be 1'
    );
    System.assertEquals(
      3,
      response?.cpts?.size(),
      'The CPT list size should be 3'
    );
  }
  private static User createUser(String profile) {
    return new User(
      ProfileId = [SELECT Id FROM Profile WHERE Name = :profile]
      .Id,
      LastName = 'last',
      Email = 'testUser@test.com',
      UserName = 'Test.User' + DateTime.now().getTime() + '@test.com',
      Alias = 'alias',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US'
    );
  }
  private static User createExternalUser(String profile, String contactId) {
    User u = new User(
      ProfileId = [SELECT Id FROM Profile WHERE Name = :profile]
      .Id,
      LastName = 'last',
      Email = 'testUser@test.com',
      UserName = 'Test.User.External' + DateTime.now().getTime() + '@test.com',
      Alias = 'alias',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ContactId = contactId
    );
    insert u;
    // assign permission set
    PermissionSet ps = [
      SELECT Id
      FROM PermissionSet
      WHERE Name = 'ConsentSettingsExternal'
    ];
    insert new PermissionSetAssignment(
      AssigneeId = u.Id,
      PermissionSetId = ps.Id
    );
    return u;
  }
}
