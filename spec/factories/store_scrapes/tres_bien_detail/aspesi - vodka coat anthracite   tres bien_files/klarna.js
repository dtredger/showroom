
var Klarna = Class.create({
    initialize: function() {
        this.element_id = false;
        this.merchant_id = false;
        this.fee = false;
        this.country = false;
        this.url = false;
    },

    setMerchantId: function(merchant_id) {
        this.merchant_id = merchant_id;
    },

    setElementId: function(element_id) {
        this.element_id = element_id;
    },

    setFee: function(fee) {
        this.fee = fee;
    },

    setCountry: function(country) {
        this.country = country;
    },

    setUrl: function(url) {
        this.url = url;
    },

    loadExternal: function() {
        var script = new Element('script', {
            src: 'http://tres-bien.com/js/klarnainvoice.js'
        });
        $$('head').first().insert(script);
        var scriptpp = new Element('script', {
            src: 'http://tres-bien.com/js/klarnapart.js'
        });
        $$('head').first().insert(scriptpp);
   },

    showTerms: function() {
        var manager = this;
        InitKlarnaInvoiceElements(manager.element_id, manager.merchant_id, manager.country, manager.fee);
        ShowKlarnaInvoicePopup();
    },

    showPPTerms: function() {
        var managerpp = this;
        InitKlarnaPartPaymentElements(managerpp.element_id, managerpp.merchant_id, managerpp.country, managerpp.fee);
        ShowKlarnaPartPaymentPopup();
    },

    getAddresses: function(pno) {
        var elemt = this.element_id;
        Element.show('loadingmask-' + this.element_id);
        var reloadurl = this.url;
        new Ajax.Updater('output-div-' + this.element_id, reloadurl + '?cache' + parseInt(Math.random() * 99999999) + '&type=' + this.element_id, {
            parameters: 'pno=' + pno,
            onComplete: function(response) {
                Element.hide('loadingmask-' + elemt);
            }
        });
    }
});

var klarna = new Klarna();
var klarnapp = new Klarna();

document.observe('dom:loaded', function() {
    klarna.loadExternal();
});

