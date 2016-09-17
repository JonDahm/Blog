<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<title>Jon &amp; Jon's blog - New Post</title>
	</head>
	<body>
		<!---------------------------------------------------------------------
			Ensure that a user is logged in.
		---------------------------------------------------------------------->
		<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if( user == null ) {
		%>
			<p>You must be logged in in order to make a new blog post.</p>
	</body>
</html>
		<%
			return;
		}
		%>
		<!---------------------------------------------------------------------
			Otherwise, if the user is logged in, let them make a post.
		---------------------------------------------------------------------->
		<h2>New blog post:</h2>
		<form action="/submit" method="post">
			<div><textarea name="content" rows="40" cols="60"></textarea></div>
			<div>
				<input type="submit" value="Post"/>
				<a href="/"><input type="button" value="Cancel"/></a>
			</div>
		</form>
	</body>
</html>
