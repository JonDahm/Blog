<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.friesendahm.blog.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<h1>All blog posts</h1>
	</head>
	<body>
		<p>
			<a href="landing-page.jsp">Back to home page.</a>
		</p>
				<%
		// Get the list of posts.
		ObjectifyService.register(BlogPost.class);
		List<BlogPost> posts = ObjectifyService.ofy().load()
			.type(BlogPost.class).list();
		Collections.sort(posts);
		//posts = posts.subList(0, Math.min(5, posts.size()));
		
		// Display them or the lack of them.
		if( posts.isEmpty() ) {
		%>
			<h2>There are no blog posts.</h2>
		<%
		}
		else {
			for( BlogPost post : posts ) {
				// Format the message:
				String username = post.user.getNickname();
				String date = new SimpleDateFormat("EEEE MMMM d 'at' hh:mm")
					.format(post.date);
				String title = post.title;
				if( title == null || title.equals("") ) {
					title = "Untitled";
				}
				pageContext.setAttribute("title", title);
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

