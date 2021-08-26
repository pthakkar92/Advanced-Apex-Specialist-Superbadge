public class Product2Extension {

  public List<ProductWrapper> productsToInsert {get; set;}

  public Product2Extension(ApexPages.StandardController controller){
    productsToInsert = new List<ProductWrapper>();
    AddRows();
  }

  public void AddRows(){
    for (Integer i=0; i<Constants.DEFAULT_ROWS; i++ ) {
      productsToInsert.add( new ProductWrapper() );
    }
  }

  public List<ChartHelper.ChartData> GetInventory(){
    return ChartHelper.GetInventory();
  }

  public List<SelectOption> GetFamilyOptions() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
    for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
      options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
    }
    return options;
  }

  public PageReference Save(){
    Savepoint sp = Database.setSavepoint();
    try {
      List<Product2> products = new List<Product2>();
      List<PricebookEntry> pbes = new List<PricebookEntry>();

      for (ProductWrapper prodwrapper : productsToInsert) {
        if(prodwrapper.productRecord != null && prodwrapper.pricebookEntryRecord != null) {
          if(prodwrapper.productRecord.Name != null && prodwrapper.productRecord.Family != null && constants.SELECT_ONE != prodwrapper.productRecord.Family && prodwrapper.productRecord.Initial_Inventory__c != null && prodwrapper.pricebookEntryRecord.UnitPrice != null) {
            products.add(prodwrapper.productRecord);
            PricebookEntry pbe = prodwrapper.pricebookEntryRecord;
            pbe.IsActive = true;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbes.add(pbe);
          }
        }
      }

      insert products;

      for (integer i = 0; i < pbes.size(); i++) {
        pbes[i].Product2Id = products[i].Id;
      }
      insert pbes;

      //If successful clear the list and display an informational message
      apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
      productsToInsert.clear();         //Do not remove
      AddRows();        //Do not remove
    } catch (Exception e){
      Database.rollback(sp);
      apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
    }
    return null;
  }

  public class ProductWrapper {
    public Product2 productRecord {get; set;}
    public PriceBookEntry pricebookEntryRecord {get; set;}

    public ProductWrapper() {
      productRecord = new product2(Initial_Inventory__c =0);
      pricebookEntryRecord = new pricebookEntry(Unitprice=0.0);
    }
  }
}