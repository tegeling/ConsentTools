/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-09-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ROOT from "./consentDataUsePurposes.html";
import TEMPLATE_CHILD from "./consentDataUsePurpose.html";
import TEMPLATE_HEADER from "./consentDataUsePurposeHeader.html";

export default class ConsentDataUsePurpose extends LightningElement {
  @api dup;
  @api cpts;

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
