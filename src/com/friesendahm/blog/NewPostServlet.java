package com.friesendahm.blog;

import static com.googlecode.objectify.ObjectifyService.ofy; 
import com.googlecode.objectify.ObjectifyService;


import com.friesendahm.blog.BlogPost;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.Date;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class NewPostServlet extends HttpServlet {
	static{
		ObjectifyService.register(BlogPost.class);
}
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

 

        // We have one entity group per Guestbook with all Greetings residing

        // in the same entity group as the Guestbook to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Greetings for a given Guestbook.  However, the write rate to each

        // Guestbook should be limited to ~1/second.
        
        String userName ="";
        if (user == null){
        	userName = "default";
        }else{
        	userName = user.getNickname();
        }


        String content = req.getParameter("content");

        Date date = new Date();


        
        ////Create a new post using the user and the content.
        BlogPost post = new BlogPost(user,content);
        ////Chuck the Greeting into Objectify using a synchronous call (see above).
        ofy().save().entities(post).now();
        ////Send the response (be sure to redirect the user to the ofyguestbook.jsp that you defined instead of guestbook.jsp).

       resp.sendRedirect("/");

    }

}