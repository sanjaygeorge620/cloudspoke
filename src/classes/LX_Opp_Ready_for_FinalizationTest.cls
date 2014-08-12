@isTest(seeAllData = true)
Public class LX_Opp_Ready_for_FinalizationTest{

public static testmethod void test1(){

try{

LX_Opp_Ready_for_Finalization.GetOpp('01pi0000002M4iA');
LX_Opp_Ready_for_Finalization.getPrimaryQuote();
LX_Opp_Ready_for_Finalization.uncheckFinalize('01pi0000002M4iA');
LX_Opp_Ready_for_Finalization.uncheckQuote();
}

catch(Exception e){}
}
}