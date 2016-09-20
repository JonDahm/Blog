<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.friesendahm.blog.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	// Fetch the user:
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
%>
<html>
	<head>
		<title>Jon &amp; Jon's Blog</title>
		
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
							<li class="nav-item active">
								<a class="nav-link" href="/">Home</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="/all-posts.jsp">All Posts</a>
							</li>
							<li class="nav-item">
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
			<!-----------------------------------------------------------------------
				Display a small blurb about us.
			------------------------------------------------------------------------>
			<div class="jumbotron">
				<div class="media">
					<a class="media-left">
						<img class="img-circle" src="/img/jondahm.jpg" style="margin:0.75rem;"/>
					</a>
					<div class="media-body">
						<h1>About Us</h1>
						<p>
							We are Jon Dahm and Jonathan Friesen, two Electrical Engineering
							students at the University of Texas. This blog was created for an
							assignment in our software engineering class.
						</p>
					</div>
					<a class="media-right">
						<img class="img-circle" src="/img/jonfriesen.jpg" style="margin:0.75rem;"/>
					</a>
				</div>
			</div>
			<hr/>
			<!-----------------------------------------------------------------------
				Show previous blog posts.
			------------------------------------------------------------------------>
			<%
			// Subscriber options
			if( user!=null ) {
				// Check if the user is already subscribed to our blog:
				ObjectifyService.register(Subscriber.class);
				List<Subscriber> subscribers = ObjectifyService.ofy().load()
					.type(Subscriber.class).list();
				boolean subscriber_check = false;
				for( Subscriber subscriber : subscribers ) {
					if( subscriber.getEmail().equals(user.getEmail()) ){
						subscriber_check = true;
						break;
					}
				}
				// Display the appropriate button for the user:
				if(subscriber_check){
					%>
						<a class="btn btn-dark-green pull-xs-right" href="/unsubscribe">Unsubscribe</a>
					<%
				}else{
					%>
						<a class="btn btn-dark-green pull-xs-right" href="/subscribe">Subscribe</a>
					<%
				}
			}
			
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
				<h2>Recent blog posts</h2><br/>
			<%
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
					<div class="jumbotron">
						<h2>${fn:escapeXml(title)}</h2>
						<p class="lead">
							Written by <b>${fn:escapeXml(username)}</b> on <b>${fn:escapeXml(date)}</b>
						</p>
						<hr class="m-y-2"/>
						<blockquote>${post}</blockquote>
					</div>
			<%
				}
			}
			%>
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
