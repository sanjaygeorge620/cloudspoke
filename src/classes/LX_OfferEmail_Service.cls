global class LX_OfferEmail_Service{

     WebService static void CallEmailClass(id recid)
    {
        
    string Sid='';
    Sid= recid;
    LX_OfferEmail OffEmail = new LX_OfferEmail();
    OffEmail.OfferQuoteEmail(Sid);
    }
    
}