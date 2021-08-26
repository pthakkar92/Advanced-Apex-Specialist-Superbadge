@isTest
public class OrderTests {

  @testSetup static void SetupTestData(){
    TestDataFactory.InsertTestData(1);
  }


  @isTest static void OrderUpdate_UnitTest(){

    Test.startTest();
    Order o = [SELECT Id, Status FROM Order LIMIT 1];
    Product2 p = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];

    o.status = constants.ACTIVATED_ORDER_STATUS;
    Update o;
    Product2 updatedp = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];


    TestDataFactory.VerifyQuantityOrdered(p, updatedp, constants.DEFAULT_ROWS);
    Test.stopTest();

  }

  @isTest static void OrderExtension_UnitTest() {
    PageReference pageRef = Page.OrderEdit;
    Test.setCurrentPage(pageRef);
    Order o = [SELECT Id, Status FROM Order LIMIT 1];
    ApexPages.StandardController stdcontroller = new ApexPages.StandardController(o);
    OrderExtension ext = new OrderExtension(stdcontroller);
    System.assertEquals(1, ext.orderItemList.size());
    ext.OnFieldChange();
    ext.SelectFamily();
    ext.Save();
    ext.First();
    ext.Next();
    ext.Previous();
    ext.Last();
    ext.GetHasPrevious();
    ext.GetHasNext();
    ext.GetTotalPages();
    ext.GetPageNumber();
    List<SelectOption> options = ext.GetFamilyOptions();
  }

  // static TestMethod void Product2Trigger_UnitTest(){
  //   Test.startTest();
  //   Product2 p = new Product2();
  //   p.Name = 'Test Product';
  //   p.Family= 'Side';
  //   p.IsActive= true;
  //   p.Quantity_Ordered__c = 50;
  //   p.Initial_Inventory__c = 100;
  //   insert p;
  //
  //   // CollaborationGroup cgroup = new CollaborationGroup();
  //   // cgroup.Name='TEST'+Constants.INVENTORY_ANNOUNCEMENTS;
  //   // cgroup.Description='test';
  //   // cgroup.CollaborationType='Public';
  //   // cgroup.IsArchived = false;
  //   // cgroup.IsAutoArchiveDisabled = false;
  //   // insert cgroup;
  //
  //   p.Quantity_Ordered__c=96;
  //   update p;
  //   Test.stopTest();
  // }

}