/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingHelper {
	public Posting__c posting {get; set;}
	public String localtime {get; set;}
	
	public static final String DATE_FORMAT = 'EEEE, MMMM d, h:mm a';
	
	public PostingHelper(Posting__c p, Datetime l) {
		posting=p;
		localtime=l.format(DATE_FORMAT);
	}
}