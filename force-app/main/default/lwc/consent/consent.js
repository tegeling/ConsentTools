/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-22-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api, wire } from "lwc";
import getConsent from "@salesforce/apex/ConsentController.getConsent";
import { subscribe, MessageContext } from "lightning/messageService";
import CONSENTUPDATE_CHANNEL from "@salesforce/messageChannel/ConsentUpdate__c";

export default class Consent extends LightningElement {
  dups;
  cpts;

  @api recordId;
  @api rgbaEmail;
  @api rgbaPhone;
  @api rgbaAddress;

  @wire(MessageContext)
  messageContext;

  get ready() {
    return this.dups && this.cpts;
  }

  fetchConsent() {
    console.log("### LWC Consent Settings fetchConsent()");
    getConsent({
      recordId: this.recordId,
      rgbaEmail: this.rgbaEmail,
      rgbaPhone: this.rgbaPhone,
      rgbaAddress: this.rgbaAddress
    })
      .then((result) => {
        console.log("### LWC Consent Settings fetchConsent() result");
        console.log(JSON.stringify(result));
        this.dups = result.dups;
        let i = 0;
        result.cpts.forEach((cpt) => {
          i += cpt.cps.length;
        });
        this.cpts = JSON.parse(JSON.stringify(result.cpts));
        this.cpts.forEach((cpt) => {
          cpt._size = Math.floor(12 / i) * cpt.cps.length;
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  // Standard lifecycle hooks used to sub/unsub to message channel
  connectedCallback() {
    console.log("### LWC Consent Settings connectedCallback()");
    this.subscribeToMessageChannel();
    this.dups = undefined;
    this.cpts = undefined;
    this.fetchConsent();
  }

  // Encapsulate logic for LMS subscribe.
  subscribeToMessageChannel() {
    this.subscription = subscribe(
      this.messageContext,
      CONSENTUPDATE_CHANNEL,
      (message) => this.handleMessage(message)
    );
  }

  // Handler for message received by component
  handleMessage(message) {
    console.log("### Event received");
    console.log(JSON.stringify(message));
    this.dups = undefined;
    this.cpts = undefined;
    this.fetchConsent();
  }
}
