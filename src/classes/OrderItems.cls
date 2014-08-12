/////used for activity History     
    public class OrderItems {

    /* Properties of the class */
    public ID lineItemID{ get; private set; }
    public String ProductName{ get; private set; }
    public Decimal Quantity{ get; private set; }
    public String QuantityFormated{ get; private set; }
    
    
    /* Class constructor */
    public OrderItems (id i,string s, decimal cs, string FormatedCS ) {
        
        Decimal dollars;
         Decimal cents;
              dollars = cs.intValue();
              cents = cs - cs.intValue();
              cents = cents.setScale(2);  // it is possible to store repeating decimals in sfdc currency fields…I found out the hard way.
              String AmtText = dollars.format() + cents.toPlainString().substring(1);
    
    
    
        lineItemID= i;
        ProductName= s;
        Quantity = cs;
        QuantityFormated = AmtText;
       
    }
    
}