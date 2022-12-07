/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ITEM from "./consentContactPointType.html";
import TEMPLATE_HEADER from "./consentContactPointTypeHeader.html";

export default class ConsentContactPointType extends LightningElement {
  @api cpt;
  @api dup;
  @api brandId;
  @api isHeader;
  _getconsentdate;
  _businessbrandid;
  @api set getconsentdate(consentdate) {
    this._getconsentdate = consentdate;
  }
  get getconsentdate() {
    return this._getconsentdate;
  }

  set bbid(businessbrandid) {
    this._businessbrandid = businessbrandid;
    console.log(
      "**** set ConsentContactPointType.bbid: " + this._businessbrandid
    );
  }
  @api get bbid() {
    return this._businessbrandid;
  }

  get colSize() {
    return Math.floor(12 / this.cpt.cps.length);
  }

  get label() {
    return " " + this.cpt.label;
  }
  get classes() {
    return this.isHeader
      ? "slds-text-align_center"
      : "slds-align_absolute-center";
  }

  render() {
    return this.isHeader ? TEMPLATE_HEADER : TEMPLATE_ITEM;
  }
}
