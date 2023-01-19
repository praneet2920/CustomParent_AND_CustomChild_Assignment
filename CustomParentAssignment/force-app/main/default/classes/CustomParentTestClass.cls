@isTest
public class CustomParentTestClass {
    
    
    
    @isTest
    public static void testCustomParentAfterInsert(){
        CustomParent__c cp = new CustomParent__c();
        cp.Status__c = 'pending';
        test.startTest();
        insert cp;
        
        CustomChild__c cc = new CustomChild__c();
        cc.CustomChildParent__c = cp.Id;
        
        insert cc;     
        test.stopTest();
    }
    
    @isTest
    public static void testCustomParentAfterUpdate(){
        CustomParent__c cp = new CustomParent__c();
        cp.Status__c = 'pending';
        insert cp;
        
        CustomChild__c cc = new CustomChild__c();
        cc.CustomChildParent__c = cp.Id;
        insert cc; 
        
        CustomParent__c cp1 = new CustomParent__c();
        cp.Status__c = 'pending';
        insert cp1;
        
        CustomChild__c cc1 = new CustomChild__c();
        cc.CustomChildParent__c = cp.Id;
        insert cc1; 
        
        CustomParent__c cp2 = new CustomParent__c();
        cp.Status__c = 'pending';
        insert cp2;
        
        CustomChild__c cc2 = new CustomChild__c();
        cc.CustomChildParent__c = cp.Id;
        insert cc2; 
        
        CustomParent__c cp3 = new CustomParent__c();
        cp.Status__c = 'pending';
        insert cp3;
        
        CustomChild__c cc3 = new CustomChild__c();
        cc.CustomChildParent__c = cp.Id;
        insert cc3; 
        List<CustomParent__c> cpList = new List<CustomParent__c>();
        
        cp.Status__c = 'Withdrawn';
        cp1.Status__c = 'Active';
        cp2.Status__c = 'Completed';
        cp3.Status__c = 'Draft';
        cpList.add(cp);
        cpList.add(cp1);
        cpList.add(cp2);
        cpList.add(cp3);
        test.startTest();
        update cpList;
        
        
        
        cc1.Status__c = 'active';
        cc1.FromDate__c = system.today();
        cc1.ToDate__c = cc1.FromDate__c.addYears(3);
        update cc1;
        
        cc2.Status__c='active';
        update cc2;
        
        
        cc3.Status__c = 'pending';
        update cc3;
        
        
        cc.Status__c = 'withdrawn';
        update cc;
        
        
        
        test.stopTest();
        
    }
    
}