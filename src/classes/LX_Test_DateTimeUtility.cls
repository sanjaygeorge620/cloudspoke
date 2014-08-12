@isTest
public class LX_Test_DateTimeUtility{

    static testMethod void DateTime() 
    {
       Map<String, String> locale_map = new Map<String, String>(); 
       locale_map = DateTimeUtility.LocaleToTimeFormatMap();
       System.Assertequals(Locale_Map.isEmpty(),false);
        
    }
}