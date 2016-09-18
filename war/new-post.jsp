<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	// Fetch the user:
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
%>
<html>
	<head>
		<title>Jon &amp; Jon's Blog - New Post</title>
		
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta http-equiv="x-ua-compatible" content="ie=edge">
		
		<!-- Font Awesome -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
		<!-- Bootstrap core CSS -->
		<link href="css/bootstrap.min.css" rel="stylesheet">
		<!-- Material Design Bootstrap -->
		<link href="css/mdb.min.css" rel="stylesheet">
		<!-- Custom styling -->
		<link href="css/style.css" rel="stylesheet">
	</head>
	<body>
		<header>
			<nav class="navbar navbar-fixed-top navbar-dark green darken-2">
				<!-- Collapse button-->
				<button class="navbar-toggler hidden-sm-up"
				        type="button"
				        data-toggle="collapse"
				        data-target="#collapseEx2">
					<i class="fa fa-bars"></i>
				</button>
				<div class="container">
					<div class="collapse navbar-toggleable-xs" id="collapseEx2">
						<a class="navbar-brand white-text" href="/">Jon &amp; Jon's Blog</a>
						<ul class="nav navbar-nav">
							<li class="nav-item">
								<a class="nav-link" href="/">Home</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="/all-posts.jsp">All Posts</a>
							</li>
							<li class="nav-item active">
								<a class="nav-link" href="/new-post.jsp">New Post</a>
							</li>
						</ul>
						<%
							if( user == null ) {
								pageContext.setAttribute(
									"loginURL",
									userService.createLoginURL(request.getRequestURI())
								);
						%>
								<a class="btn btn-dark-green pull-xs-right"
								   href="${loginURL}">Sign in</a>
						<%
							} else {
								pageContext.setAttribute("user", user);
								pageContext.setAttribute(
									"logoutURL",
									userService.createLogoutURL(request.getRequestURI())
								);
						%>
								<div class="pull-xs-right white-text">
									Howdy, ${fn:escapeXml(user.nickname)}!
									<a class="btn btn-dark-green" href="${logoutURL}">Sign out</a>
								</div>
						<%
							}
						%>
					</div>
				</div>
			</nav>
		</header>
		
		<main><div class="container">
			<h2 style="margin-bottom:2rem;">New blog post:</h2>
			<form action="/submit" method="post">
				<div class="md-form">
					<input type="text" class="form-control" id="post_title"
					       name="title"
					       placeholder="Enter a Title"/>
					<label for="post_title" class="">Title</label>
				</div>
				<div class="md-form">
					<textarea type="text" id="post_content" class="md-textarea"
					          name="content"
					          style="height:40rem; overflow:scroll; padding: 0.6rem 0;"></textarea>
					<label for="post_content">Post content</label>
				</div>
				<div>
					<button type="submit" class="btn btn-dark-green">Post</button>
					<a class="btn btn-dark-green" href="/">Cancel</a>
				</div>
			</form>
		</div></main>
		
		<!-- SCRIPTS -->
		
		<!-- JQuery -->
		<script type="text/javascript" src="js/jquery-2.2.3.min.js"></script>
		
		<!-- Bootstrap tooltips -->
		<script type="text/javascript" src="js/tether.min.js"></script>
		
		<!-- Bootstrap core JavaScript -->
		<script type="text/javascript" src="js/bootstrap.min.js"></script>
		
		<!-- MDB core JavaScript -->
		<script type="text/javascript" src="js/mdb.min.js"></script>
	</body>
</html>
