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

import org.apache.commons.lang3.StringEscapeUtils;
import com.github.rjeschke.txtmark.Processor;

@SuppressWarnings("serial")
public class NewPostServlet extends HttpServlet {
	static{
		ObjectifyService.register(BlogPost.class);
	}
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String userName ="";
        if (user == null){
        	userName = "default";
        }else{
        	userName = user.getNickname();
        }
        // Get the content, escape anything remotely HTML-like, then process
        // the resulting markdown. We'll store the result in the datastore.
        String content = req.getParameter("content");
        content = StringEscapeUtils.escapeHtml4(content);
        content = Processor.process(content);
        
        String title = req.getParameter("title");
        Date date = new Date();
        
        BlogPost post = new BlogPost(user, title, content);//Create a new post using the user and the content.
        ofy().save().entities(post).now();//Chuck the BlogPost into Objectify using a synchronous call
        resp.sendRedirect("/");//Send the response 
    }
}