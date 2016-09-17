package com.friesendahm.blog;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class BlogPost implements Comparable<BlogPost> {
	/**
	 * The ID of the blog post.
	 */
	@Id public Long id;
	
	/**
	 * The user who made the blog post.
	 */
	public User user;
	
	/**
	 * The title of the blog post.
	 */
	public String title;
	
	/**
	 * The content of the blog post.
	 */
	public String content;
	
	/**
	 * The date the blog post was made.
	 */
	public Date date;
	
	/**
	 * Private, parameterless constructor used by the Objectify interface.
	 */
	private BlogPost() {
	}
	
	/**
	 * Creates a new blog post made by the given user with the given content.
	 * The date written is set to be "now".
	 * @param user  The user who wrote the blog post.
	 * @param content  The content of the blog post. 
	 */
	public BlogPost(User user, String title, String content) {
		this.user = user;
		this.title = title;
		this.content = content;
		this.date = new Date();
	}
	
	/**
	 * Compares this blog post to another blog post by the date they were written.
	 * @param other  The blog post to compare to. Must not be null.
	 */
	@Override
	public int compareTo(BlogPost other) {
		if( date.after(other.date) ) {
			return 1;
		}
		if( date.before(other.date) ) {
			return -1;
		}
		return 0;
	}
}
