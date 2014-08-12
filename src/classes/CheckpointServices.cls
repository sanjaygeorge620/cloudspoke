Public with sharing Class CheckpointServices{
    public class cpException extends Exception {}
    public static final string Username = Settings.get('checkpoint.username');
    public static final string Password = Settings.get('checkpoint.password');
    public static final string Max_Results = Settings.get('checkpoint.max_results');
    public static final string BaseURL =  Settings.get('checkpoint.endpoint') ;
    //===========================================================================================================================
    // Service Callout
    //===========================================================================================================================
      public static HTTPResponse docallout(string un, string pw, string end_point){
          system.debug('username / password: ' + un + ' / ' + pw);
          
          if(un==null) throw new cpException('Username is required: ' + un);
          if(pw==null) throw new cpException('Password is required: ' + pw);
          if(end_point==null) throw new cpException('End Point is required: ' + end_point);
          
          Blob headerValue = Blob.valueOf(un + ':' + pw);
          String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

          HttpRequest req = new HttpRequest();
                      req.setEndpoint(end_point);
                      req.setMethod('POST');
                      req.setHeader('Authorization', authorizationHeader); //Simple Login
                      req.setTimeout(10000);
          
          system.debug('req: ' + req);

          Http http = new Http();
          HTTPResponse res;
          if(Test.isRunningTest()){
              res = new HttpResponse();
              res.setHeader('Content-Type', 'application/xml');
              res.setBody('<?xml version="1.0"?><feed xmlns="http://www.w3.org/2005/Atom" xmlns:openSearch="http://a9.com/-/spec/ pensearch/1.1/" xmlns:i="http://ISOdxSolutions.com/ns/2011/"><openSearch:totalResults>26</openSearch:totalResults>  <openSearch:startIndex>1</openSearch:startIndex><openSearch:itemsPerPage>1</openSearch:itemsPerPage><entry><content><i:data><i:organization>Travelport Limited (6DF4C9)</i:organization><i:servername>trvinmt01</i:servername><i:lgid></i:lgid><i:servertype></i:servertype><i:platform>Microsoft Windows Server 2003 R2</i:platform><i:platformver>Service Pack 2</i:platformver><i:release></i:release><i:databasetype></i:databasetype><i:databasever></i:databasever><i:qid>https://172.21.156.55/service/device/92</i:qid><i:import_date>2014-03-27 06:58:13-05</i:import_date><i:snapshot_date>2014-03-25 01:03:29-05</i:snapshot_date><i:id>468</i:id><i:modified>2014-04-02 00:00:47.746815-05</i:modified></i:data></content></entry></feed>');
              res.setStatusCode(200);
          }else{
              res = http.send(req);
          }  
          
          
          System.debug('Calling Out Now: ' + system.now() + ' \n Status:' + res.getStatusCode()); // + ' \n Body: ' + res.getBody());

          if(res.getStatusCode() != 200) //Ensure Valid Response
             throw new cpException('Invalid Response: ' + res.getStatusCode());

          return res;
      }

    //===========================================================================================================================
    // Service Metadata
    //===========================================================================================================================
      public static Service doReturnServiceMetadata(){
              HTTPResponse res = docallout(Username, Password, BaseURL + '?max-results=' + Max_Results);
              
              //Parse XML   
              XmlStreamReader reader = new XmlStreamReader(res.getBody()); 
              //Parse and return Service Metadata
              Service s = parseService(reader);
              System.debug(s);
             return s;
      }

       public static Service parseService(XmlStreamReader reader) {
          Service Service = new Service();
          String Local_Name = '';
          while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'data' == reader.getLocalName()) {
              break;
            } else if (reader.getEventType() == XmlTag.END_ELEMENT){
               Local_Name = ''; //reset everytime
            } else if (reader.getEventType() == XmlTag.START_ELEMENT ){
               Local_Name= reader.getLocalName();
            } else if(Local_Name=='itemsPerPage' && reader.getEventType() == XmlTag.CHARACTERS){
                Service.itemsPerPage = reader.getText();    
            } else if(Local_Name=='startIndex' && reader.getEventType() == XmlTag.CHARACTERS){
                  Service.startIndex = reader.getText();    
            } else if(Local_Name=='totalResults' && reader.getEventType() == XmlTag.CHARACTERS){
                  Service.totalResults = reader.getText();    
            }
            reader.next();
          }

         return Service;
      }

      //Wrapper
      public class Service{
          public string itemsPerPage{get;set;}
          public string startIndex{get;set;}
          public string totalResults{get;set;}
      }

    //===========================================================================================================================
    // Server List
    //===========================================================================================================================
      public static list<server> doReturnServers(integer PageOffset){
              integer Pg = 1; 
              if(PageOffset>0){
                Pg = integer.valueof(Max_Results) * (PageOffset);
              }
    
              string EndPoint = BaseURL + '?max-results=' + Max_Results + '&start-index=' + pg;  
    
              system.debug('PageOffset: ' + PageOffset);
              system.debug('EndPoint: ' + EndPoint);
    
              //Pass Service Info
              HTTPResponse res = docallout(Username, Password, EndPoint);
              
              //Parse XML    
              XmlStreamReader reader = new XmlStreamReader(res.getBody()); 
               //Parse and return Servers
              list<Server> s = parseObjects(reader);
              System.debug(s);
             return s;
          
      }
      

      public static list<Server> parseObjects(XmlStreamReader reader) {
        list<Server> Servers = new Server[0];
        while(reader.hasNext()) {
           //  Start at the beginning of the object and make sure that it is a object
         if (reader.getEventType() == XmlTag.START_ELEMENT) {
          if ('data' == reader.getLocalName()) {
              //  Pass the object to the parseObject method (below) 
              Server Server = parseObject(reader);
              Servers.add(Server);
          }
      }
      reader.next();
      }
      return Servers;
      }


      public static Server parseObject(XmlStreamReader reader) {
         Server Server = new Server();
         String Local_Name = '';
         while(reader.hasNext()) {
             if (reader.getEventType() == XmlTag.END_ELEMENT && 'data' == reader.getLocalName()) {
              break;
             }else if (reader.getEventType() == XmlTag.END_ELEMENT){
                 Local_Name = ''; //reset everytime
             }else if (reader.getEventType() == XmlTag.START_ELEMENT ){
                 Local_Name= reader.getLocalName();
             }else if( Local_Name=='organization' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.organization = reader.getText();
             }else if( Local_Name=='servername' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.servername= reader.getText();
             }else if( Local_Name=='lgid' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.lgid= reader.getText();                        
             }else if( Local_Name=='servertype' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.servertype= reader.getText();
             }else if( Local_Name=='platform' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.platform= reader.getText();
             }else if( Local_Name=='platformver' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.platformver= reader.getText();
             }else if( Local_Name=='release' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.release= reader.getText();
             }else if( Local_Name=='databasetype' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.databasetype= reader.getText();
             }else if( Local_Name=='databasever' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.databasever= reader.getText();
             }else if( Local_Name=='qid' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.qid= reader.getText(); 
             }else if( Local_Name=='date' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.createddate= reader.getText();                    
             }else if( Local_Name=='id' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.id= reader.getText();                    
             }else if( Local_Name=='modified' && reader.getEventType() == XmlTag.CHARACTERS){
                 server.modifieddatetime= reader.getText();                              
             }
             reader.next();
         }
         return server;
      }

    
     //Wrapper
      public class Server{
         public integer index{get;set;}
         public string Organization{
            get { return Organization; }
            set { Organization = value; 
                  //Need to parse the organization to get the company number Example: "Stormont-Vail Healthcare (155C13)"
                  if(value.contains('(') && value.contains(')')){
                      integer start = value.indexOf('(');
                      integer stop = value.indexOf(')');
                      if(start<stop){//Asserts something is not wrong
                          companynumber= value.substring(start +1,stop);
                      }    
                  }
                }
         }
         
         public string companynumber{get;set;}
         public string servername{get;set;}
         public string lgid{get;set;}
         public string servertype{get;set;}
         public string platform{get;set;}
         public string platformver{get;set;}
         public string release{get;set;}
         public string databasetype{get;set;}
         public string databasever{get;set;}
         public string qid{get;set;}
         public string createddate{get;set;}
         public string id{get;set;}
         public string modifieddatetime{get;set;}
      }


       //Grab Environment Variables from Custom Settings to dynamically change
        private static map<string,string> Settings{ 
            get{
                if(settings==null){
                    map<string,Environment_Variable__c> s = Environment_Variable__c.getAll();
                    //Need to iterate to make values lowercase
                    settings = new map<string,string>();
                    for(string x: s.keySet()){
                        settings.put(x.tolowercase(),s.get(x).Value__c);
                    }
                } 
                return settings;
             } 
             set;
        }
}