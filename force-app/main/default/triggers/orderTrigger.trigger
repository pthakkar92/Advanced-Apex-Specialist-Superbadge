/**
 * @name orderTrigger
 * @description
 **/
trigger OrderTrigger  on Order (after update) {

  if (Trigger.new != null) {
    OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
  }

}
