/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 07-21-2022
 * @last modified by  : dirk.gronert@salesforce.com
 **/
import { LightningElement, api, track } from "lwc";
import getWebSiteEngagements from "@salesforce/apex/CDPService.getWebSiteEngagements";

export default class ProductBrowseEngagement extends LightningElement {
  @api recordId;
  @api emailField;
  @track state = {
    Product: true,
    Category: true,
    Blog: true
  };
  data;
  error;

  hdlFilter(evt) {
    evt.stopPropagation();
    this.state[evt.target.name] = !this.state[evt.target.name];
    this.$loadData();
  }

  $constructFilter() {
    let _filter = [];
    if (Object.values(this.state).every((val) => val === true)) return _filter;
    Object.keys(this.state).forEach((key) => {
      if (this.state[key]) {
        _filter.push(key);
      }
    });
    return _filter;
  }

  async $loadData() {
    //getWebSiteEngagements({ ctxId: this.recordId, ctxEmailField: this.emailField})
    getWebSiteEngagements({
      ctxId: this.recordId,
      ctxEmailField: this.emailField,
      engagementVehicles: this.$constructFilter()
    })
      .then((result) => {
        this.data = result.map((pbe) => {
          return {
            id: pbe.id,
            product: pbe.product,
            eventDateTime: Date.parse(pbe.eventDateTime),
            url: pbe.url,
            category: pbe.category,
            icon:
              pbe.product === "Product"
                ? "standard:product"
                : "standard:topic2",
            iconClass:
              pbe.product === "Product"
                ? "slds-icon-standard-event slds-timeline__icon"
                : "slds-icon-standard-task slds-timeline__icon",
            timeline:
              pbe.product === "Product"
                ? "slds-timeline__item_expandable slds-timeline__item_event "
                : "slds-timeline__item_expandable slds-timeline__item_task"
          };
        });
      })
      .catch((error) => {
        this.error = error;
      });
  }

  connectedCallback() {
    this.$loadData();
  }
}
