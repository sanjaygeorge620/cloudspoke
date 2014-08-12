@RestResource(urlMapping='/ServerTimestamp')

 global with sharing class getServerTimestamp
 {

global class ResponseWrapper
{
    public String currentServerTime;
}

@HttpGet
global static ResponseWrapper returnCurrentServerTime()
{
    dateTime newDate=system.now();      
    String dateInFormat = newDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSZ');
    ResponseWrapper resWrap=new ResponseWrapper();
    resWrap.currentServerTime=dateInFormat;

    system.debug('getServerTime:'+dateInFormat);
    return resWrap;
}

static testMethod void testgetserverTime()
{
ResponseWrapper resWrap = returnCurrentServerTime();
}
}