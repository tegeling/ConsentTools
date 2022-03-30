/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-30-2022
 * @last modified by  : tegeling
 **/
public with sharing class ConsentHistoryInvocable {
  @InvocableMethod(
    label='Check Contact Point Consent History'
    description='Returns Privacy Status from Contact Point History.'
  )
  public static List<String> getContactPointConsentHistory(
    List<ConsentHistoryInvocable.Request> request
  ) {
    List<String> consentHistoryList = new List<String>();
    for (ConsentHistoryInvocable.Request r : request) {
      ContactPointConsent cpc = ConsentController.getContactPointConsentHistory(
        r.cpId,
        r.dupId,
        r.timeStamp
      );
      consentHistoryList.add(cpc?.PrivacyConsentStatus);
    }
    return consentHistoryList;
  }
  public class Request {
    @InvocableVariable(
      label='Contact Point Id'
      description='Record Id of Email, Phone or Address Contact Point'
      required=true
    )
    public String cpId;

    @InvocableVariable(
      label='Data Use Purpose Id'
      description='Record Id of Data Use Purpose'
      required=true
    )
    public String dupId;

    @InvocableVariable(
      label='Timestamp'
      description='Datetime for which the historical preference status is retrieved'
      required=true
    )
    public Datetime timeStamp;
  }
}
