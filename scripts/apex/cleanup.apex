List<DataUsePurpose> dups = [SELECT Id FROM DataUsePurpose];
delete dups;

List<DataUseLegalBasis> dlbs = [SELECT Id FROM DataUseLegalBasis];
delete dlbs;

List<Entitlement> ent = [SELECT Id FROM Entitlement];
delete ent;

List<Contact> c = [SELECT Id FROM contact];
delete c;

List<Account> a = [SELECT Id FROM Account];
delete a;

List<ContactPointTypeConsent> cptc = [SELECT Id FROM ContactPointTypeConsent];
delete cptc;

List<ContactPointConsent> cpc = [SELECT Id FROM ContactPointConsent];
delete cpc;

List<ContactPointEmail> cpe = [SELECT Id FROM ContactPointEmail];
delete cpe;

List<ContactPointPhone> cpp = [SELECT Id FROM ContactPointPhone];
delete cpp;

List<ContactPointAddress> cpa = [SELECT Id FROM ContactPointAddress];
delete cpa;

List<Individual> ind = [SELECT Id FROM Individual];
delete ind;
