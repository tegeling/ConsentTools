/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-30-2022
 * @last modified by  : tegeling
 **/
public with sharing class ConsentHistoryWrapper {
  public ConsentHistoryWrapper() {
  }
  public String contactPointConsentId { get; set; }
  public String field { get; set; }
  public Datetime createdDate { get; set; }
  public String newValue { get; set; }
  public String oldValue { get; set; }
}
