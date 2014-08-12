@isTest 
public class DateTimeUtilitytest {
    static testMethod void DateTimetest() {
         Map<String, String> locale_map = new Map<String, String>(); 
         locale_map  = DateTimeUtility.LocaleToTimeFormatMap();
        System.assertEquals(locale_map.IsEmpty(),False); 


    } 
}