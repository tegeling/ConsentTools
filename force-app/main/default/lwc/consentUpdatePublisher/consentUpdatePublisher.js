/**
 * @description       :
 * @author            : tegeling
 * @group             :
 * @last modified on  : 03-22-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api, wire } from "lwc";
import { publish, MessageContext } from "lightning/messageService";
import CONSENTUPDATE_CHANNEL from "@salesforce/messageChannel/ConsentUpdate__c";

export default class ConsentUpdatePublisher extends LightningElement {
  @api recordId;

  @wire(MessageContext)
  messageContext;

  // Publish event
  connectedCallback() {
    const payload = { recordId: this.recordId };
    publish(this.messageContext, CONSENTUPDATE_CHANNEL, payload);
  }
}
