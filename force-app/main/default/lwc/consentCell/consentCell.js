/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContactPointConsent from "@salesforce/apex/ConsentController.getContactPointConsent";
import getContactPointConsentHistory from "@salesforce/apex/ConsentController.getContactPointConsentHistory";
import updateContactPointConsent from "@salesforce/apex/ConsentController.updateContactPointConsent";
import createContactPointConsent from "@salesforce/apex/ConsentController.createContactPointConsent";

export default class ConsentCell extends LightningElement {
  isDisabled = false;
  @api cpId;
  @api dupId;
  @api brandId;
  _getconsentdate;
  _businessbrandid;
  @api set getconsentdate(consentdate) {
    //debugger;
    this._getconsentdate = consentdate;
    if (consentdate != null) {
      this.isDisabled = true;
    }
    this.$fetchContactPointConsent();
  }
  get getconsentdate() {
    return this._getconsentdate;
  }

  set bbid(businessbrandid) {
    //debugger;
    this._businessbrandid = businessbrandid;
    console.log("**** set ConsentCell.bbid: " + this._businessbrandid);
    this.$fetchContactPointConsent();
  }

  @api get bbid() {
    return this._businessbrandid;
  }

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
        privacyConsentStatus: this.cpc.PrivacyConsentStatus,
        brandId: this._businessbrandid
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
    //debugger;
    if (this.getconsentdate == null) {
      getContactPointConsent({
        contactPointId: this.cpId,
        dataUsePurposeId: this.dupId,
        brandId: this._businessbrandid
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
    } else {
      //debugger;
      getContactPointConsentHistory({
        contactPointId: this.cpId,
        dataUsePurposeId: this.dupId,
        brandId: this._businessbrandid,
        timeStamp: this.getconsentdate
      })
        .then((result) => {
          //debugger;
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
          //debugger;
          this.cpc = {
            Id: undefined,
            PrivacyConsentStatus: "OptOut",
            ContactPointId: this.cpId,
            DataUsePurposeId: this.dupId
          };
          console.log(JSON.parse(JSON.stringify(error)));
        });
    }
  }
  /*
  connectedCallback() {
    debugger;
    this.$fetchContactPointConsent();
  }
  */
}
