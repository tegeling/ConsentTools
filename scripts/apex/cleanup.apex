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
