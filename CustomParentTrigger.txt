trigger CustomParentTrigger on CustomParent__c (before insert,after insert,after Update) {
    if(Trigger.isInsert && Trigger.isAfter){
        CustomParentTriggerHandler.customParentAfterInsert(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){
        CustomParentTriggerHandler.customParentBeforeInsert(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        CustomParentTriggerHandler.customParentAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}