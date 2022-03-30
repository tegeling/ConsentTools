/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-30-2022
 * @last modified by  : tegeling
 **/
@isTest(SeeAllData=false)
public with sharing class Test_ConsentHistoryInvocable {
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
    ContactPointConsent cpcEmail = new ContactPointConsent(
      ContactPointId = cpEmail.Id,
      DataUsePurposeId = dup.Id,
      Name = 'Email Consent',
      PrivacyConsentStatus = 'OptOut'
    );
    insert cpcEmail;
    // setup request parameter
    List<ConsentHistoryInvocable.Request> request = new List<ConsentHistoryInvocable.Request>();
    ConsentHistoryInvocable.Request r = new ConsentHistoryInvocable.Request();
    r.cpId = cpEmail.Id;
    r.dupId = dup.Id;
    r.timeStamp = datetime.newInstance(2020, 8, 1);
    request.add(r);
    // invoke test
    Test.startTest();
    List<String> cpcEmail20200801 = ConsentHistoryInvocable.getContactPointConsentHistory(
      request
    );
    Test.stopTest();
    // check results
    System.assertEquals(
      1,
      cpcEmail20200801.size(),
      'Historical Email Consent size should be 1'
    );

    System.assertEquals(
      'OptIn',
      cpcEmail20200801[0],
      'Historical Email Consent should be OptIn'
    );
  }
}
