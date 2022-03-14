/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-14-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api, wire } from "lwc";
import getConsent from "@salesforce/apex/ConsentController.getConsent";

export default class Consent extends LightningElement {
  dups;
  cpts;

  @api recordId;
  @api rgbaEmail;
  @api rgbaPhone;
  @api rgbaAddress;

  @wire(getConsent, {
    recordId: "$recordId",
    rgbaEmail: "$rgbaEmail",
    rgbaPhone: "$rgbaPhone",
    rgbaAddress: "$rgbaAddress"
  })
  consentResponse({ error, data }) {
    if (data) {
      this.dups = data.dups;
      let i = 0;
      data.cpts.forEach((cpt) => {
        i += cpt.cps.length;
      });
      this.cpts = JSON.parse(JSON.stringify(data.cpts));
      this.cpts.forEach((cpt) => {
        cpt._size = Math.floor(12 / i) * cpt.cps.length;
      });
    } else if (error) {
      console.log(error);
    }
  }

  get ready() {
    return this.dups && this.cpts;
  }
}
