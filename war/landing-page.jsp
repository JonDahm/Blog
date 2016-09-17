<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.friesendahm.blog.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<title>Jon &amp; Jon's blog</title>
	</head>
	<body>
		<h1>Welcome to Jon Dahm and Jonathan Friesen's blog!</h1>
		<!---------------------------------------------------------------------
			Greet the user and present a sign-in/sign-out link
		---------------------------------------------------------------------->
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if( user != null ) {
			pageContext.setAttribute("user", user);
			pageContext.setAttribute(
				"logoutURL",
				userService.createLogoutURL(request.getRequestURI())
			);
		%>
			<p>
				Hello, ${fn:escapeXml(user.nickname)}!
				(<a href="${logoutURL}">Sign Out</a>)
			</p>
			<p>
				<a href="new-post.jsp">Make a new blog post.</a>
			</p>
		<%
		}
		else {
			pageContext.setAttribute(
				"loginURL",
				userService.createLoginURL(request.getRequestURI())
			);
		%>
			<p>
				Please <a href="${loginURL}">sign in</a>
				if you wish to write a blog post. 
			</p>
		<%
		}
		%>
		
		<!---------------------------------------------------------------------
			Show previous blog posts.
		---------------------------------------------------------------------->
		<%
		// Get the list of posts.
		ObjectifyService.register(BlogPost.class);
		List<BlogPost> posts = ObjectifyService.ofy().load()
			.type(BlogPost.class).list();
		Collections.sort(posts);
		posts = posts.subList(0, Math.min(5, posts.size()));
		
		// Display them or the lack of them.
		if( posts.isEmpty() ) {
		%>
			<h2>There are no blog posts.</h2>
		<%
		}
		else {
		%>
			<h2><u>Recent blog posts</u></h2>
		<%
			for( BlogPost post : posts ) {
				// Format the message:
				String username = post.user.getNickname();
				String date = new SimpleDateFormat("EEEE MMMM d 'at' hh:mm")
					.format(post.date);
				pageContext.setAttribute("title", post.title);
				pageContext.setAttribute("date", date);
				pageContext.setAttribute("username", username);
				pageContext.setAttribute("post", post.content);
		%>
				<div class="post">
					<h3><u>${fn:escapeXml(title)}</u></h3>
					<p>Written by <b>${fn:escapeXml(username)} on ${fn:escapeXml(date)}</b>
					<blockquote>${fn:escapeXml(post)}</blockquote>
				</div>
		<%
			}
		}
		%>
	</body>
</html>
