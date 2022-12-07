/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
import { LightningElement, api, wire, track } from "lwc";
import getConsent from "@salesforce/apex/ConsentController.getConsent";
import getBrandList from "@salesforce/apex/ConsentController.getBrandList";

export default class Consent extends LightningElement {
  dups;
  cpts;
  brandOptions = [];
  businessBrandId;

  @track consentDate;
  @api recordId;
  @api rgbaEmail;
  @api rgbaPhone;
  @api rgbaAddress;
  @api brandId;

  @wire(getBrandList)
  wiredBrandList({ error, data }) {
    if (data) {
      this.businessBrandId = data[0].Id;
      this.brandOptions = data.map((record) => ({
        value: record.Id,
        label: record.Name
      }));
    } else if (error) {
      this.brandOptions = undefined;
    }
  }

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

  consentdateChange(event) {
    const cd = event.target.value;
    this.consentDate = cd;
    console.log("**** Consent Date selected: " + this.consentDate);
  }

  handleBrandSelected(event) {
    const b = event.detail.value;
    this.businessBrandId = b;
    console.log("**** BrandId selected: " + this.businessBrandId);
  }

  get ready() {
    return this.dups && this.cpts && this.businessBrandId;
  }

  get bbid() {
    return this.businessBrandId;
  }
}
