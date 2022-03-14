/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-09-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ITEM from "./consentContactPointType.html";
import TEMPLATE_HEADER from "./consentContactPointTypeHeader.html";

export default class ConsentContactPointType extends LightningElement {
  @api cpt;
  @api dup;
  @api isHeader;

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
