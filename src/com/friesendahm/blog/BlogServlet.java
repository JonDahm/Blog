package com.friesendahm.blog;

import static com.googlecode.objectify.ObjectifyService.ofy; 
import com.googlecode.objectify.ObjectifyService;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.Date;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class BlogServlet extends HttpServlet {
	static {
        ObjectifyService.register(BlogPost.class);
 	}
    
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
			 resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
        } else {
            resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
        }
    }


}