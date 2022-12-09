/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 12-07-2022
 * @last modified by  : tegeling@salesforce.com
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ITEM from "./consentContactPoint.html";
import TEMPLATE_HEADER from "./consentContactPointHeader.html";

export default class ConsentContactPoint extends LightningElement {
  @api cp;
  @api dup;
  @api isHeader;
  @api brandId;
  _getconsentdate;
  _businessbrandid;
  @api set getconsentdate(consentdate) {
    this._getconsentdate = consentdate;
  }
  get getconsentdate() {
    return this._getconsentdate;
  }

  set bbid(businessbrandid) {
    console.log("**** set ConsentContactPoint.bbid: " + this._businessbrandid);
    this._businessbrandid = businessbrandid;
  }
  @api get bbid() {
    return this._businessbrandid;
  }

  render() {
    return this.isHeader ? TEMPLATE_HEADER : TEMPLATE_ITEM;
  }
}
