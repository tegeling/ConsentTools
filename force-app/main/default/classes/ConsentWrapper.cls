/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-30-2022
 * @last modified by  : tegeling
 **/
public with sharing class ConsentWrapper {
  @TestVisible
  public class DataUsePurpose {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String label { get; set; }
  }
  @TestVisible
  public class ContactPointType {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String icon { get; set; }
    @AuraEnabled
    public String color { get; set; }
    @AuraEnabled
    public List<ContactPoint> cps { get; set; }
  }

  @TestVisible
  public class ContactPoint {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String label { get; set; }
  }

  @AuraEnabled
  public List<DataUsePurpose> dups { get; set; }
  @AuraEnabled
  public List<ContactPointType> cpts { get; set; }
}
