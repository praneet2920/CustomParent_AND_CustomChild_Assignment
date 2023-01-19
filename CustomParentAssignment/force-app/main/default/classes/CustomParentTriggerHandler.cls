public class CustomParentTriggerHandler {
    
    public static void customParentAfterInsert(List<CustomParent__c> customParentList){
        List<CustomChild__c> customChildList = new List<CustomChild__c>();
        for(CustomParent__c cp : customParentList){
            CustomChild__c cc = new CustomChild__c();
            cc.Status__c = 'pending';
            cc.CustomChildParent__c = cp.Id;
            customChildList.add(cc);
        }
        insert customChildList;
    }
    
    public static void customParentBeforeInsert(List<CustomParent__c> customParentList){
        for(CustomParent__c cp : customParentList){
            cp.Status__c = 'pending';
        }
    }
    
    public static void customParentAfterUpdate(List<CustomParent__c> customParentNewList,Map<Id,CustomParent__c> customParentOldMap){
        Set<Id> customParentUpdated = new Set<Id>();
        
        List<CustomChild__c> customChildUpdateList = new List<CustomChild__c>();
        for(CustomParent__c cp : customParentNewList){
            CustomParent__c cpOld = CustomParentOldMap.get(cp.Id);
            if(cp.Status__c != cpOld.Status__c){
                if(cp.Status__c=='Active' ){
                    
                    customParentUpdated.add(cp.Id);
                    
                    system.debug(customParentUpdated);
                }else if(cp.Status__c=='Pending' || cp.Status__c=='Draft'){
                    customParentUpdated.add(cp.Id);
                    system.debug(customParentUpdated);
                }else if(cp.Status__c=='Withdrawn' || cp.Status__c=='Ready-to-withdraw'){
                    customParentUpdated.add(cp.Id);
                    system.debug(customParentUpdated);
                }else if(cp.Status__c=='Completed'){
                    customParentUpdated.add(cp.Id);
                }
            }
        }
        if(!customParentUpdated.isEmpty()){
            
            List<CustomParent__c> cpList = [ Select id,status__c,(select status__c from CustomChilds__r) from CustomParent__c where id in: customParentUpdated ]; 
            for(CustomParent__c cp : cpList){
                CustomChild__c cc = cp.CustomChilds__r[0];
                system.debug(cc);
                if(cp.Status__c == 'active'){
                    cc.Status__c = 'active';
                    cc.FromDate__c = system.today();
                    cc.ToDate__c = cc.FromDate__c.addYears(3);
                    customChildUpdateList.add(cc);
                }else if(cp.Status__c == 'completed'){
                    cc.Status__c = 'active';
                    customChildUpdateList.add(cc);
                }else if(cp.Status__c == 'draft' || cp.Status__c == 'pending'){
                    cc.Status__c = 'pending';
                    customChildUpdateList.add(cc);
                }else if(cp.Status__c == 'Withdrawn' || cp.Status__c == 'Ready-to-withdraw'){
                    cc.Status__c = 'Withdrawn';
                    customChildUpdateList.add(cc);
                }
                
            }
            
        }
        
        if(!customChildUpdateList.isEmpty()){
            update customChildUpdateList;
        }
        
    }
}