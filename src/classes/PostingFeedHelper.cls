/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingFeedHelper {
	public Posting__Feed feed {get; set;}
	public String localtime {get; set;}
	
	public PostingFeedHelper(Posting__Feed f, Datetime l) {
		feed=f;
		localtime=l.format(PostingHelper.DATE_FORMAT);
	}
	
	public List<CommentHelper> getComments() {
		List<CommentHelper> mylist = new List<CommentHelper>();
		for (FeedComment c : feed.feedcomments) {
			mylist.add(new CommentHelper(c, c.createddate));
		}
		return mylist;
	}
	
	public boolean getHasComments() {
		return feed.feedcomments.size() > 0;
	}
	
	public String getCommentClass() {
		if (getHasComments()) {
			return '';
		}
		return 'hidden';
	}
	
	public class CommentHelper {
		public FeedComment comment {get; set;}
		public String localtime {get; set;}
	
		public CommentHelper (FeedComment c, Datetime l) {
			comment=c;
			localtime=l.format(PostingHelper.DATE_FORMAT);
		}
		
	}
	
}