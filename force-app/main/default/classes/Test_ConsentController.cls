/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-14-2022
 * @last modified by  : tegeling
 **/
@isTest(SeeAllData=false)
public with sharing class Test_ConsentController {
  @isTest
  static void doTest() {
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
}
