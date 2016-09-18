package com.friesendahm.blog;

import static com.googlecode.objectify.ObjectifyService.ofy; 
import com.googlecode.objectify.ObjectifyService;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



@SuppressWarnings("serial")
public class SubscribeServlet extends HttpServlet {
	static{
		ObjectifyService.register(BlogPost.class);
		ObjectifyService.register(Subscriber.class);
}

	public void doGet(HttpServletRequest request,HttpServletResponse response) 
			throws IOException,ServletException{
	    	this.doPost(request,response);
		}

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Subscriber subscriber = new Subscriber(user.getEmail());
		ofy().save().entities(subscriber).now();
		resp.sendRedirect("/");
	}
}