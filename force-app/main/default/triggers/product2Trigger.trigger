/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    try {
        for ( Product2 p : Trigger.New ){
            if (
                p.Id != null && (
                    ( p.Family == 'Entree' && p.Quantity_Remaining__c < 20 )||
                    ( p.Family == 'Side' && p.Quantity_Remaining__c < 10 )||
                    ( p.Family == 'Dessert' && p.Quantity_Remaining__c < 15 )||
                    ( p.Family == 'Beverage' && p.Quantity_Remaining__c < 5 )
                )
            ){
                insert new FeedItem(
                    Body=p.Name+' Quantity is down to '+p.Quantity_Remaining__c,
                    ParentId = p.Id
                );
            }
        }
    } catch ( Exception e ){
        //A good developer would do something with this Exception!
    }
}