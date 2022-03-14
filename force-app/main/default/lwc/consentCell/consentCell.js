/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-09-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from "lightning/uiRecordApi";

import getContactPointConsent from "@salesforce/apex/ConsentController.getContactPointConsent";

export default class ConsentCell extends LightningElement {
  @api cpId;
  @api dupId;
  cpc;

  hdlChange(evt) {
    this.cpc.PrivacyConsentStatus = evt.target.checked ? "OptIn" : "OptOut";
    this.$insertUpdateCPC();
  }

  get value() {
    return this.cpc.PrivacyConsentStatus === "OptIn";
  }

  async $insertUpdateCPC() {
    updateRecord({ fields: this.cpc })
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Consent updated",
            variant: "success"
          })
        );
      })
      .catch((error) => {
        console.log(JSON.stringify(error));
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error creating consent",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }

  async $fetchContactPointConsent() {
    getContactPointConsent({
      contactPointId: this.cpId,
      dataUsePurposeId: this.dupId
    })
      .then((result) => {
        this.cpc = result
          ? JSON.parse(JSON.stringify(result))
          : {
              Id: undefined,
              PrivacyConsentStatus: "OptOut",
              ContactPointId: this.cpId,
              DataUsePurposeId: this.dupId
            };
      })
      .catch((error) => {
        this.cpc = {
          Id: undefined,
          PrivacyConsentStatus: "OptOut",
          ContactPointId: this.cpId,
          DataUsePurposeId: this.dupId
        };
        console.log(JSON.parse(JSON.stringify(error)));
      });
  }

  connectedCallback() {
    this.$fetchContactPointConsent();
  }
}
