/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
 
public class PostingCategoryMapping {
	
	// When customizing your org's list of categories, make sure to update this list accordingly.
	private static String[] priceCats = new String[] {'Antiques', 'Baby and Kids', 'Bikes', 'Books, Music, and Movies', 'Cars, Trucks, and Motorcycles',
		 'Computers', 'Electronics', 'Everything Else', 'Furniture', 'Lost and Found', 'Real Estate', 'Rentals', 'Tickets', 'Toys and Games', 'Vacation Rentals'};
	
	public static boolean hasPrice(String cat) {
		for (String c : priceCats) {
			if (c==cat) {
				return true;
			}
		}
		return false;
	}
	
	static testmethod void testHasPrice() {
		System.assert(hasPrice('Tickets'));
		System.assert(!hasPrice('Free'));
	}
}