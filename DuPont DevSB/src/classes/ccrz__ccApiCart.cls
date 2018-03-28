/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ccApiCart {
    global static String ACTIVECART;
    global static String BYEFFECTIVEACCOUNT;
    global static String BYOWNER;
    global static String BYSTOREFRONT;
    global static String BYUSER;
    global static String CART_ENCID;
    global static String CART_ENCIDLIST;
    global static String CART_ID;
    global static String CART_IDLIST;
    global static String CART_OBJ;
    global static String CART_OBJLIST;
    global static String CARTITEMSBYID;
    global static String CARTLOCALE;
    global static String CARTNAME;
    global static String CARTPRICINGTIERLIST;
    global static String CARTSTATUS;
    global static String CARTTYPE;
    global static String CICMTS;
    global static String CILIST;
    global static String CIPREPROC;
    global static String CIQTY;
    global static String COUPON_CODE;
    global static String DELIVERYDATE;
    global static String ENTITYNAME;
    global static String HEADERONLY;
    global static String INCRERROR;
    global static String INCRWARN;
    global static String INELIGIBLEPRODUCTS;
    global static String ISREPRICE;
    global static String ISSKIPPRICING;
    global static String ITEMGROUPID;
    global static String ITEMID;
    global static String LINE_DATA;
    global static String MERGELINES;
    global static String MOVEDATA;
    global static String NONSTDPRODUCTS;
    global static String ORDER_ID;
    global static String PAYMENTDATA;
    global static String PAYMENTRESULT;
    global static String PRODSADDEDTOCART;
    global static String RECALCGROUPS;
    global static String SHIPPING_ADDR;
    global static String SHIPPING_ADDRLIST;
    global static String SHIPPING_OPTIONS;
    global static String SUBCRESULT;
    global static String TARGETGROUP;
    global static String TARGETQTY;
    global static String TRANSACTIONRESULT;
    global static String TRANSPAYMENTDATA;
    global ccApiCart() {

    }
    global static Map<String,Object> addTo(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> cartAdjustment(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> cloneCart(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> createCartItemGroup(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> create(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> fetch(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> getShippingOptions(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> initItemGroups(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> place(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> price(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> processItemGroups(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> removeCart(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> removeFrom(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> reviseCartItemGroup(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> revise(Map<String,Object> inputData) {
        return null;
    }
global class LineData {
    global String label {
        get;
        set;
    }
    global List<ccrz.ccApiCart.LineData> minorItems {
        get;
        set;
    }
    global Id parentProductId {
        get;
        set;
    }
    global String parentSku {
        get;
        set;
    }
    global Decimal price {
        get;
        set;
    }
    global Id productId {
        get;
        set;
    }
    global Decimal qty {
        get;
        set;
    }
    global Decimal quantity {
        get;
        set;
    }
    global String scrSku {
        get;
    }
    global Id sellerId {
        get;
        set;
    }
    global Id sfid {
        get;
        set;
    }
    global String sku {
        get;
        set;
    }
    global String subProdTermId {
        get;
        set;
    }
    global Decimal subscriptionFrequency {
        get;
        set;
    }
    global Decimal subTotal {
        get;
        set;
    }
    global LineData() {

    }
    global LineData(Id id) {

    }
    global LineData(String sku, Decimal qty) {

    }
}
}
