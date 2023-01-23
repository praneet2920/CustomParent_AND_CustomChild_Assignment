public class CustomParentTriggerHandler {
    
    public static void customParentAfterInsert( List<CustomParent__c> customParentList ) {
        List<CustomChild__c> customChildList = new List<CustomChild__c>();
        for( CustomParent__c cp : customParentList ) {
            CustomChild__c cc = new CustomChild__c();
            cc.Status__c = 'pending';
            cc.CustomChildParent__c = cp.Id;
            customChildList.add(cc);
        }
        insert customChildList;
    }
    
    public static void customParentBeforeInsert( List<CustomParent__c> customParentList ) {
        for( CustomParent__c cp : customParentList ) {
            cp.Status__c = 'pending';
        }
    }
    
    public static void customParentAfterUpdate( List<CustomParent__c> customParentNewList,Map<Id,CustomParent__c> customParentOldMap ) {
        Set<Id> customParentUpdated = new Set<Id>();
        for( CustomParent__c cp : customParentNewList ) {
            CustomParent__c cpOld = CustomParentOldMap.get(cp.Id);
            if( cp.Status__c != cpOld.Status__c ) {
                if( cp.Status__c=='Active' ) {  
                    customParentUpdated.add(cp.Id);
                    system.debug(customParentUpdated);
                } else if ( cp.Status__c=='Pending' || cp.Status__c=='Draft' ) {
                    customParentUpdated.add(cp.Id);
                    system.debug(customParentUpdated);
                } else if( cp.Status__c=='Withdrawn' || cp.Status__c=='Ready-to-withdraw' ) {
                    customParentUpdated.add(cp.Id);
                    system.debug(customParentUpdated);
                } else if( cp.Status__c=='Completed' ) {
                    customParentUpdated.add(cp.Id);
                }
            }
        }
        if ( !customParentUpdated.isEmpty() ) {
            List<CustomParent__c> cpList = 
                [ SELECT Id,Status__c,
                ( SELECT Status__c FROM CustomChilds__r)
                FROM CustomParent__c WHERE Id in: customParentUpdated ]; 
            List<CustomChild__c> customChildUpdateActive = new List<CustomChild__c>();
            List<CustomChild__c> customChildUpdateCompleted = new List<CustomChild__c>();
            List<CustomChild__c> customChildUpdateDraftOrPending = new List<CustomChild__c>();
            List<CustomChild__c> customChildUpdateWithdrawnOrReadyToWithdrawn = new List<CustomChild__c>();
            for ( CustomParent__c cp : cpList ) {
                if (cp.Status__c == 'active') {
                    customChildUpdateActive.addAll(cp.CustomChilds__r);   
                } else if ( cp.Status__c == 'completed' ) {
                    customChildUpdateCompleted.addAll(cp.CustomChilds__r);    
                } else if ( cp.Status__c == 'draft' || cp.Status__c == 'pending' ) {
                    customChildUpdateDraftOrPending.addAll(cp.CustomChilds__r);   
                } else if ( cp.Status__c == 'Withdrawn' || cp.Status__c == 'Ready-to-withdraw' ) {
                    customChildUpdateWithdrawnOrReadyToWithdrawn.addAll(cp.CustomChilds__r);    
                }   
            }
            if ( !customChildUpdateActive.isEmpty() ) {
                for ( CustomChild__c cc : customChildUpdateActive ) {
                    cc.Status__c = 'active';
                    cc.FromDate__c = system.today();
                    cc.ToDate__c = cc.FromDate__c.addYears(3);
                }
                update customChildUpdateActive;
            }
            if ( !customChildUpdateCompleted.isEmpty() ) {
                for ( CustomChild__c cc : customChildUpdateCompleted ) {
                    cc.Status__c = 'active';
                }
                update customChildUpdateCompleted;
            }
            if ( !customChildUpdateDraftOrPending.isEmpty() ) {
                for ( CustomChild__c cc : customChildUpdateDraftOrPending ) {
                    cc.Status__c = 'pending';
                }
                update customChildUpdateDraftOrPending;
            }
            if ( !customChildUpdateWithdrawnOrReadyToWithdrawn.isEmpty() ) {
                for ( CustomChild__c cc : customChildUpdateWithdrawnOrReadyToWithdrawn ) {
                    cc.Status__c = 'Withdrawn';
                }
                update customChildUpdateWithdrawnOrReadyToWithdrawn;
            }    
        }    
    }
}