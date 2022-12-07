/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ROOT from "./consentDataUsePurposes.html";
import TEMPLATE_CHILD from "./consentDataUsePurpose.html";
import TEMPLATE_HEADER from "./consentDataUsePurposeHeader.html";

export default class ConsentDataUsePurpose extends LightningElement {
  @api dup;
  @api cpts;
  _bbid;
  _getconsentdate;
  @api set getconsentdate(consentdate) {
    this._getconsentdate = consentdate;
  }
  get getconsentdate() {
    return this._getconsentdate;
  }
  set bbid(bbid) {
    console.log("**** set ConsentDataUsePurpose.bbid: " + bbid);
    this._bbid = bbid;
  }
  @api get bbid() {
    return this._bbid;
  }

  get dupSize() {
    return "3";
  }

  get classes() {
    return "slds-text-align_center";
  }

  render() {
    return Array.isArray(this.dup)
      ? TEMPLATE_ROOT
      : this.dup
      ? TEMPLATE_CHILD
      : TEMPLATE_HEADER;
  }
}
