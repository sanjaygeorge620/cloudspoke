/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public class Pair {
    public String label {get; set;}
    public String value {get; set;}
    
    public Pair(String l, String v) {
        this.label=l;
        this.value=v;
    }
    
    static testmethod void testPair() {
    	Pair p = new Pair('a','b');
    	System.assertEquals('a', p.label);
    	System.assertEquals('b', p.value);
    }
}