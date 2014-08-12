public class GeographyCoverage {
    public Geography_Coverage__c coverage{get;set;}
    boolean recordFound;
    public Geography_Coverage__c coverageRec{get;set;}
    String recordID;
    public GeographyCoverage(ApexPages.StandardController controller) {
        recordId = controller.getId();
        if(recordId != null){
            coverageRec = [select Category__c
                                            , Area__c
                                            , Sub_Area__c
                                            , Location__c
                                            , Country__c
                                            , Description__c
                                            , Coverage_Owner__c
                                            , Notes__c
                                            , OwnerId 
                                            , Sales_Organization__c 
                                         from Geography_Coverage__c  
                                         where id = :recordId ];
            coverage= coverageRec;         
            recordFound = true;
            system.debug('coverageRec:' + coverageRec);
            category = coverageRec.Category__c;
            country = coverageRec.Country__c;
            area = coverageRec.Area__c;
            subArea = coverageRec.Sub_Area__c;
            location = coverageRec.Location__c;
            salesOrg = coverageRec.Sales_Organization__c;
        
        }else{
            coverageRec= new Geography_Coverage__c();
            system.debug('coverage:' + coverage);
            coverage= coverageRec;
            recordFound = false;
        }
    }


   
    String category;                 /* String value for the category */
    String prevCategory;            
    String area;                    /* String value for the area*/
    String prevArea;
    String subArea;                    /* String value for the subarea*/
    String prevSubArea;
    String location;                    /* String value for the Location*/
    String prevLocation;
    String country;                    /* String value for the Location*/
    String prevCountry;
    String Description;
    String SalesOrg;
    String CoverageOwner;
    String Notes;
    
    public String getCategory() { 
       return category;             /* Getter for the category value */
    }                
   
    public void setCategory(String s) { 
        category = s; 
        system.debug('category getting passed from page:' + category);
    }        /* Setter for the category value */       
    
    public String getArea() {
       return area;                  /* Getter for the area value */
    }    
    public void setArea(String s) {
            area= s; 
    }
    
    public String getSubArea() {
            return subArea;                 /* Getter for the subarea value */      
   }        
    public void setSubArea(String s) { 
        subarea= s; location = ''; 
    }             /* Setter for the subarea value */
    
    
    public String getLocation() {
            return location;                /* Getter for the Location value */
      }      
    public void setLocation(String s) { 
        location= s; }             /* Setter for the Locationvalue */
        
    public String getCountry() {
            return country;                /* Getter for the Location value */
    }      
    public void setCountry(String s) { 
        country= s; }             /* Setter for the Locationvalue */
        
    public String getSalesOrg() {
            return salesOrg;                /* Getter for the Location value */
    }      
    public void setSalesOrg(String s) { 
        SalesOrg= s; }             /* Setter for the Locationvalue */    
  

    /* Getter which dynamically generates the categories from the Perceptive_Config_Value__c object. */
    public List<SelectOption> getCategories() {

       List<SelectOption> optionList = new List<SelectOption>();
       List<String> pulledOptionList = new List<String>();  
        optionList.add(new SelectOption('','- None -'));        /* Add a null option to force the user to make a selection. */

        /* Loop through the feature_category__c records creating a selectOption for each result with the record ID as the value and the name as the label displayed in the selectList */
        for (Perceptive_Config_Value__c fc: [select value__c
                                                    , id
                                                    , name 
                                                    from Perceptive_Config_Value__c 
                                                    where name = 'Category']){
        
                                                
        pulledOptionList.add(fc.value__c);  
        pulledOptionList.sort();
        }
        for (integer i = 0; i<pulledOptionList.size(); i++){
            optionList.add(new SelectOption(pulledOptionList[i], pulledOptionList[i]));
        }
       // optionList.add(new SelectOption(fc.value__c, fc.value__c));
        return optionList;      
    }

    /* Getter which generates the options for the Area selectList based on the current value of the selected category. If there is no value selected then only the null option should be returned. */ 
    public List<SelectOption> getAreas() {
      List<SelectOption> optionList = new List<SelectOption>();
      List<String> pulledOptionList = new List<String>();
      optionList.add(new SelectOption('', '- None -'));      /* Add a null option to force the user to make a selection. */
      system.debug('category selected:' + category);
      if(category!= NULL) {                    /* If a category has been selected then query for the related values */
          system.debug('prevCategory:' + prevCategory);
          if(category != prevCategory && prevCategory != null){
              area = '';
              subArea = '';
              location = '';
              country = '';
          }    

        /* Loop over the related feature records for the given category creating a selectOption with the value being the feature record ID and the label is the name of the feature. */
          string CategoryChoice = category + ' Category';                //all category choices in the values object have their choice + category
            system.debug('CategoryChoice:' + CategoryChoice);
          for (Perceptive_Config_Value__c area: [select value__c 
                                                    from Perceptive_Config_Value__c 
                                                    where Name = :CategoryChoice]){
            pulledOptionList.add(area.value__c);  
            pulledOptionList.sort();
          }
      }else{
              area = '';
              subArea = '';
              location = '';
              country = '';
      }
      prevCategory = category;

      for (integer i = 0; i<pulledOptionList.size(); i++){
        optionList.add(new SelectOption(pulledOptionList[i], pulledOptionList[i]));
      }   
      return optionList;
    }

    /* Getter which generates the options for the Area selectList based on the current value of the selected category. If there is no value selected then only the null option should be returned. */ 
    public List<SelectOption> getSubAreas() {
      List<SelectOption> optionList = new List<SelectOption>();
      List<String> pulledOptionList = new List<String>();
      optionList.add(new SelectOption('', '- None -'));      /* Add a null option to force the user to make a selection. */
      
      if(area!= NULL) {                    /* If a category has been selected then query for the related values */
           if(area != prevArea && prevArea != null){
              subArea = '';
              location = '';
              country = '';
          }  

        /* Loop over the related feature records for the given category creating a selectOption with the value being the feature record ID and the label is the name of the feature. */
          string areaChoice = area+ ' Area';                //all category choices in the values object have their choice + category

          for (Perceptive_Config_Value__c subarea: [select value__c 
                                                        from Perceptive_Config_Value__c 
                                                        where Name = :areaChoice]){
          pulledOptionList.add(subarea.value__c);  
            pulledOptionList.sort();
        }
       } else{
            subArea = '';
            location = '';
            country = '';
      }
      prevArea = area;
      for (integer i = 0; i<pulledOptionList.size(); i++){
        optionList.add(new SelectOption(pulledOptionList[i], pulledOptionList[i]));
      }   
      return optionList;
    }
    /* Getter which generates the options for the SubArea selectList based on the current value of the selected category. If there is no value selected then only the null option should be returned. */ 
    public List<SelectOption> getLocations() {
      List<SelectOption> optionList = new List<SelectOption>();
      List<String> pulledOptionList = new List<String>();
      optionList.add(new SelectOption('', '- None -'));      /* Add a null option to force the user to make a selection. */
      
      if(subarea!= NULL) {                    /* If a category has been selected then query for the related values */
          If(subarea != prevSubArea && prevSubArea != null){
                location = '';
                country = '';
          }

        /* Loop over the related feature records for the given category creating a selectOption with the value being the feature record ID and the label is the name of the feature. */
          string subareaChoice = subarea+ ' Sub Area';                //all category choices in the values object have their choice + category

          for (Perceptive_Config_Value__c location: [select value__c from Perceptive_Config_Value__c where Name = :subareaChoice]){
            pulledOptionList.add(location.value__c);  
            pulledOptionList.sort();
          }   
      }else{
        location = '';
        country = '';
      } 
      prevSubArea = subarea;
      for (integer i = 0; i<pulledOptionList.size(); i++){
        optionList.add(new SelectOption(pulledOptionList[i], pulledOptionList[i]));
      } 
      return optionList;
    }
    
     /* Getter which generates the options for the country selectList based on the current value of the selected location. If there is no value selected then only the null option should be returned. */ 
    public List<SelectOption> getCountries() {
      List<SelectOption> optionList = new List<SelectOption>();
      List<String> pulledOptionList = new List<String>();
      optionList.add(new SelectOption('', '- None -'));      /* Add a null option to force the user to make a selection. */
      
      if(location!= NULL) {                    /* If a category has been selected then query for the related values */
          If(location != prevLocation && prevLocation != null){
                country = '';
          }

        /* Loop over the related feature records for the given category creating a selectOption with the value being the feature record ID and the label is the name of the feature. */
          string locationChoice = location+ ' Location';                //all category choices in the values object have their choice + category
            system.debug('locationChoice' + locationChoice);
          for (Perceptive_Config_Value__c country: [select value__c from Perceptive_Config_Value__c where Name = :locationChoice]){
            pulledOptionList.add(country.value__c);  
            pulledOptionList.sort();
          }   
      }else{
        country = '';
      } 
      prevLocation = location;
      for (integer i = 0; i<pulledOptionList.size(); i++){
        optionList.add(new SelectOption(pulledOptionList[i], pulledOptionList[i]));
      } 
      return optionList;
    }
   
    PageReference pageRef;
    public PageReference Save(){
                   
            coverageRec.Category__c = category;
            coverageRec.Area__c = area;
            coverageRec.Sub_Area__c = subarea;
            coverageRec.Location__c = location;
            coverageRec.Country__c = country;
                  system.debug('salesORg:' + SalesOrg);
            Try{
            
        
                upsert coverageRec;  
            
                pageRef= new ApexPages.StandardController(coverageRec).view();
                pageRef.setRedirect(true);
           }catch(DMLException ex){
              // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Country and Sales Organization are required to proceed.'));
           }

    return pageRef;
        }    
      
}