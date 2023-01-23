@isTest
public class CustomParentTestClass {
    
    @testSetup
    public static void testSetupMethod(){
        List<CustomParent__c> customParentList = new List<CustomParent__c> ();
        for ( Integer i = 0 ; i < 10 ; i++ ) {
            CustomParent__c cp = new CustomParent__c();
       		cp.Status__c = 'pending';
        	customParentList.add(cp);
        }
        insert customParentList;
    }
    
    @isTest
    public static void testCustomParentAfterInsert(){
        CustomParent__c cp = new CustomParent__c();
        cp.Status__c = 'pending';
        test.startTest();
        insert cp;
        test.stopTest();
    }
    
    @isTest
    public static void testCustomParentAfterUpdate_statusIsActive(){
        List<CustomParent__c> CustomParentList = new List<CustomParent__c> ( [ SELECT Id, Status__c From CustomParent__c ] );
        Set<Id> customParentIdSet = new Set<Id>();
        for ( CustomParent__c cp : CustomParentList ) {
            cp.Status__c = 'active';
        }
        Test.startTest();
        update CustomParentList;
        for (CustomParent__c cp : [ SELECT Id, Status__c From CustomParent__c WHERE Status__c = 'active' ] ){
            customParentIdSet.add(cp.id);
        }
        List<CustomChild__c> customChildList = [ SELECT Status__c FROM CustomChild__c WHERE CustomChildParent__c IN : customParentIdSet ];
        system.assertEquals('Active', customChildList[0].Status__c);
        Test.stopTest();  
    }
    
     @isTest
    public static void testCustomParentAfterUpdate_statusIsCompleted(){
        List<CustomParent__c> CustomParentList = new List<CustomParent__c> ( [ SELECT Id, Status__c From CustomParent__c ] );
        Set<Id> customParentIdSet = new Set<Id>();
        for ( CustomParent__c cp : CustomParentList ) {
            cp.Status__c = 'Completed';
        }
        Test.startTest();
        update CustomParentList;
        for (CustomParent__c cp : [ SELECT Id, Status__c From CustomParent__c WHERE Status__c = 'Completed' ] ){
            customParentIdSet.add(cp.id);
        }
        List<CustomChild__c> customChildList = [ SELECT Status__c FROM CustomChild__c WHERE CustomChildParent__c IN : customParentIdSet ];
        system.assertEquals('Active', customChildList[0].Status__c);
        Test.stopTest();  
    }
    
     @isTest
    public static void testCustomParentAfterUpdate_statusIsDraftOrPending(){
        List<CustomParent__c> CustomParentList = new List<CustomParent__c> ( [ SELECT Id, Status__c From CustomParent__c ] );
        Set<Id> customParentIdSet = new Set<Id>();
        for ( CustomParent__c cp : CustomParentList ) {
            cp.Status__c = 'Draft';
        }
        Test.startTest();
        update CustomParentList;
        for (CustomParent__c cp : [ SELECT Id, Status__c From CustomParent__c WHERE Status__c = 'Draft' ] ){
            customParentIdSet.add(cp.id);
        }
        List<CustomChild__c> customChildList = [ SELECT Status__c FROM CustomChild__c WHERE CustomChildParent__c IN : customParentIdSet ];
        system.assertEquals('Pending', customChildList[0].Status__c);
        Test.stopTest();  
    }
    
     @isTest
    public static void testCustomParentAfterUpdate_statusIsWithdrawnOrReadyToWithdrawn(){
        List<CustomParent__c> CustomParentList = new List<CustomParent__c> ( [ SELECT Id, Status__c From CustomParent__c ] );
        Set<Id> customParentIdSet = new Set<Id>();
        for ( CustomParent__c cp : CustomParentList ) {
            cp.Status__c = 'Withdrawn';
        }
        Test.startTest();
        update CustomParentList;
        for (CustomParent__c cp : [ SELECT Id, Status__c From CustomParent__c WHERE Status__c = 'Withdrawn' ] ){
            customParentIdSet.add(cp.id);
        }
        List<CustomChild__c> customChildList = [ SELECT Status__c FROM CustomChild__c WHERE CustomChildParent__c IN : customParentIdSet ];
        system.assertEquals('Withdrawn', customChildList[0].Status__c);
        Test.stopTest();  
    }
    
}