package com.friesendahm.blog;

import static com.googlecode.objectify.ObjectifyService.ofy; 
import com.googlecode.objectify.ObjectifyService;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



@SuppressWarnings("serial")
public class UnsubscribeServlet extends HttpServlet {
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
		ObjectifyService.register(Subscriber.class);
		List<Subscriber> users = ObjectifyService.ofy().load()
		 	.type(Subscriber.class).list();
		ListIterator<Subscriber> UserIt = users.listIterator();
		while(UserIt.hasNext()){		
			Subscriber jimmy = UserIt.next();
			if(jimmy.getEmail().equals(user.getEmail())){
				ofy().delete().entity(jimmy);
				resp.sendRedirect("/");
			}
		}
     resp.sendRedirect("/");

 }

}