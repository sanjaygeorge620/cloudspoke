global class TestWebServiceEmail{

    
    WebService static void CallEmailClass(id recid)
    {
        
    string Sid='';
    Sid= recid;
    OfferEmail OffEmail = new OfferEmail();
    OffEmail.OfferQuoteEmail(Sid);
    }
}