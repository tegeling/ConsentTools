/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-20-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContactPointConsent from "@salesforce/apex/ConsentController.getContactPointConsent";
import updateContactPointConsent from "@salesforce/apex/ConsentController.updateContactPointConsent";
import createContactPointConsent from "@salesforce/apex/ConsentController.createContactPointConsent";

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
    if (this.cpc.Id === undefined) {
      // create new CPC
      createContactPointConsent({
        contactPointId: this.cpc.ContactPointId,
        dataUsePurposeId: this.cpc.DataUsePurposeId,
        privacyConsentStatus: this.cpc.PrivacyConsentStatus
      })
        .then((result) => {
          this.cpc.Id = result;
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
    } else {
      // update existing CPC
      try {
        await updateContactPointConsent({
          contactPointConsentId: this.cpc.Id,
          privacyConsentStatus: this.cpc.PrivacyConsentStatus
        });
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Consent updated",
            variant: "success"
          })
        );
      } catch (error) {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error creating consent",
            message: error.body.message,
            variant: "error"
          })
        );
      }
    }
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
