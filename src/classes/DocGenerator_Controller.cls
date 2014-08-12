public with sharing class DocGenerator_Controller {

    public Id rootId {get;set;}
    transient public Functional_Area__c root {get; set;}
    transient public Map<Id,List<Functional_Area__c>> documentMap {get;set;}
    transient public Map<Id,Boolean> hasChild {get;set;} //does this functional area have children?
    transient public Map<Id,Boolean> hasDesigns {get;set;} //does this functional area have any designs?
    transient public Map<Id,Boolean> hasAttachments {get;set;} //does this design area have any attachments?
    
    transient public Map<Id,List<Design__c>> designsByFA {get; set;} //designs by functional area
    transient public Map<Id,Set<Id>> storyIdsByDesign {get; set;} //user stories by design
    transient public Map<Id,List<Requirements__c>> storiesByDesign {get; set;} //user stories by design
    transient public Map<Id,List<Attachment>> attachmentsByDesign {get; set;} //attachemtns by design
    
    transient private Set<Id> functionalareas;
    transient private Set<Id> designs;
    
    transient public String renderAs {get; set;}
    
    //constructor
    public DocGenerator_Controller(){
        this.rootId = ApexPages.currentPage().getParameters().get('functionalarea');
        
        //choose rendering option
        if(ApexPages.currentPage().getParameters().get('renderAs') == 'PDF')
            this.renderAs = 'pdf';
        
        //build document map
        this.documentMap = new Map<Id,List<Functional_Area__c>>();
        this.hasChild = new Map<Id,Boolean>();
        this.hasDesigns = new Map<Id,Boolean>();
        this.hasAttachments = new Map<Id,Boolean>();
        this.designsByFA = new Map<Id,List<Design__c>>();
        this.storiesByDesign = new Map<Id,List<Requirements__c>>();
        this.attachmentsByDesign = new Map<Id,List<Attachment>>();
        this.functionalareas = new Set<Id>();
        this.designs = new Set<Id>();
        
        for(Functional_Area__c fa : [
             Select Id, Parent_Functional_Area__c, Name, Overview__c
             from Functional_Area__c
             order by TOC_Sort__c ASC
        ]){
            this.functionalareas.add(fa.Id);
            //check for root element
            if(fa.Id == this.rootId){
                this.root = fa;
            }
            
            //build document map
            if(this.documentMap.containsKey(fa.Parent_Functional_Area__c)){
                this.documentMap.get(fa.Parent_Functional_Area__c).add(fa);
            }else{
                List<Functional_Area__c> children = new List<Functional_Area__c>();
                children.add(fa);
                this.documentMap.put(fa.Parent_Functional_Area__c, children);
            }
            
            //build map of has child
            if(!this.hasChild.containsKey(fa.Id)){
                this.hasChild.put(fa.Id, false);
            }
            this.hasChild.put(fa.Parent_Functional_Area__c, true);
            
            //Initalise map of designs, so always contains entries
            List<Design__c> designs = new List<Design__c>();
            this.designsByFA.put(fa.Id, designs);
            this.hasDesigns.put(fa.Id, false);
            
        }
        
        //Get details of designs 
        for(Design__c design : [Select Id, Design_Summary__c, Design_Details__c, Functional_Area__c, Name 
                                From Design__c 
                                where Functional_Area__c in : this.functionalareas
                                order by TOC_Sort__c ASC
                                ]){
             this.designs.add(design.Id);

             this.designsByFA.get(design.Functional_Area__c).add(design);
             this.hasDesigns.put(design.Functional_Area__c, true);

             
            //Initalise map of stories, so always contains entries
            List<Requirements__c> reqs = new List<Requirements__c>();
            this.storiesByDesign.put(design.Id, reqs);
            List<Attachment> atts = new List<Attachment>();
            this.attachmentsByDesign.put(design.Id, atts);
            //track if this has attachments
            this.hasAttachments.put(design.Id, false); 
        }
        //and related user stories
        this.storyIdsByDesign = new Map<Id,Set<Id>>();
        for(UserStory2Design__c u2d: [Select Id, Design__c, User_Story__c FROM UserStory2Design__c where Design__c in : this.designs
                                ]){
             if(!this.storyIdsByDesign.containsKey(u2d.Design__c)){
                 Set<Id> stories = new Set<Id>();
                 stories.add(u2d.User_Story__c);
                 this.storyIdsByDesign.put(u2d.Design__c, stories);
             }else{
                 this.storyIdsByDesign.get(u2d.Design__c).add(u2d.User_Story__c);
             }
        }        
        //and now get the actual user stories
        
        Map<Id,Requirements__c> storymap = new Map<Id,Requirements__c>([Select Id, Name, User_Story__c FROM Requirements__c Order By Name ASC]);
        for(Id design : this.storyIdsByDesign.keyset()){
            List<Requirements__c> stories = new List<Requirements__c>();
            for(Id story : this.storyIdsByDesign.get(design)){
                if(storymap.containsKey(story)){
                    stories.add(storymap.get(story));
                }
            }
            this.storiesByDesign.put(design, stories);
        }
        
        //get "reference documents" - i.e. attachments on design object
        for(Attachment att : [Select Id, Name, ParentID
                                From Attachment 
                                where ParentID in : this.designs
                                ]){
            this.attachmentsByDesign.get(att.ParentID).add(att);
            this.hasAttachments.put(att.ParentID, true);                    
        }
    }
    
    // To generate word formatted version of the Functinal Document.
    public PageReference ConvertToWordFormat(){
        PageReference wordFormatPage = new PageReference('/apex/DocGenerator?functionalarea='+this.rootId+'&renderAs=PDF');
        wordFormatPage.setRedirect(true);
        return wordFormatPage;
        
    }
}