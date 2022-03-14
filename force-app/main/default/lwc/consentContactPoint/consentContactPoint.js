/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 03-09-2022
 * @last modified by  : tegeling
 **/
import { LightningElement, api } from "lwc";

import TEMPLATE_ITEM from "./consentContactPoint.html";
import TEMPLATE_HEADER from "./consentContactPointHeader.html";

export default class ConsentContactPoint extends LightningElement {
  @api cp;
  @api dup;
  @api isHeader;

  render() {
    return this.isHeader ? TEMPLATE_HEADER : TEMPLATE_ITEM;
  }
}
