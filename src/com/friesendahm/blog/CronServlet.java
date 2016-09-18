package com.friesendahm.blog;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import com.googlecode.objectify.ObjectifyService;
import java.util.Date;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;


@SuppressWarnings("serial")
public class CronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws UnsupportedEncodingException{

		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		Date current_time = new Date();
		ObjectifyService.register(BlogPost.class);
		String blog_review = new String();//collect a string of all recent blog posts
		List<BlogPost> posts = ObjectifyService.ofy().load()
		 		.type(BlogPost.class).list();
		if(posts==null){
			blog_review = "There have been no new posts in the last 24 hours!";
		}else{
			for(BlogPost post : posts){
				long temp_date = current_time.getTime();
				long previous_date= temp_date-86400000;
				Date previous_time = new Date(previous_date);
				if(post.date.after(previous_time)){
					String date = new SimpleDateFormat("EEEE MMMM d 'at' hh:mm").format(post.date);
					String title = "";
					if(post.title==null){
					}else{
						title = post.title;
					}
					blog_review = blog_review + "\n<h2>" +title+"</h2>\nWritten by:<b>"+post.user.getNickname()
									+"</b> on <b>"+date+"</b>\n<blockquote>"+post.content+"</blockquote>\n<hr/>\n";
				}else{
					// ...
				}
			}
		}
		try {
			_logger.info("Cron Job has been executed");
	        Message message = new MimeMessage(session);
	        message.setFrom(new InternetAddress("bot@blog-test2-143821.appspotmail.com","Subscriber BlogBot"));
	        ObjectifyService.register(Subscriber.class);
			List<Subscriber> users = ObjectifyService.ofy().load()
		 		.type(Subscriber.class).list();
			if(users==null){
				return;
			}
			for(Subscriber subscriber : users){
				message.addRecipient(Message.RecipientType.TO, new InternetAddress(subscriber.email));
			}
	         message.setSubject("Here's the blog posts from the last 24 hours!");
	         message.setContent(blog_review, "text/html");
	         Transport.send(message);
		} catch (AddressException e) {
			// ...
		} catch (MessagingException e) {
			// ...
		} catch (NullPointerException e){
			// ...
		}
		
	}
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
}