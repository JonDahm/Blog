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
						<a class="navbar-brand white-text">Jon &amp; Jon's Blog</a>
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
						<img class="img-circle" src="/img/jondahm.jpg"/>
					</a>
					<div class="media-body">
						<p>
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eu tortor
						augue. Etiam fermentum enim diam, in finibus lorem vehicula vitae.
						Donec eu vestibulum purus. Vivamus ac leo lorem. Sed vel magna ut
						massa ornare luctus. Sed sagittis, lectus ac gravida pellentesque,
						nulla dolor vehicula enim, sit amet dignissim est tellus sed diam.
						Curabitur vitae tortor dictum, posuere ex ac, hendrerit ex. Cras neque
						massa, tristique et mattis sit amet, fringilla non diam.
						</p>
						<p>
						Sed hendrerit et odio at accumsan. Nunc laoreet semper elit non
						fermentum. Donec nisi enim, facilisis a massa et, hendrerit faucibus
						nibh. In interdum, felis id tempor vulputate, augue ligula suscipit
						dolor, quis ornare orci massa non nisi. Quisque rutrum diam vel diam
						euismod, sed hendrerit ex iaculis. Praesent molestie quam risus, et
						ornare enim hendrerit quis. Aenean vitae lectus aliquam, dapibus enim
						in, feugiat erat. Donec rutrum lacus libero, vel faucibus neque
						suscipit non. Ut urna lacus, tincidunt id cursus at, maximus in tellus.
						Integer est sapien, gravida ut turpis nec, luctus hendrerit mi.
						Vestibulum eu sem sagittis, eleifend dolor at, facilisis massa.
						</p>
						<p>
						Proin hendrerit odio convallis porta sagittis. Ut mi dui, venenatis
						eget enim vel, consequat consectetur magna. Interdum et malesuada
						fames ac ante ipsum primis in faucibus. Morbi ultricies turpis vel
						justo faucibus, quis ultricies ante laoreet. Curabitur sagittis
						sollicitudin felis, vel consequat eros scelerisque quis. Ut a tortor
						aliquam, convallis magna ut, faucibus metus. Aliquam risus felis,
						consectetur vel vehicula gravida, tempor sed nunc. Praesent in
						vulputate sapien. Nulla luctus consectetur bibendum. Phasellus id
						efficitur turpis. Duis elementum orci lacus, sit amet interdum libero
						efficitur vel. Sed ac nisl mi. Donec neque orci, accumsan quis urna
						et, ornare dapibus nisl.
						</p>
					</div>
					<a class="media-right">
						<img class="img-circle" src="/img/jonfriesen.jpg"/>
					</a>
				</div>
			</div>
			<hr/>
			<!-----------------------------------------------------------------------
				Show previous blog posts.
			------------------------------------------------------------------------>
			<%
			//subscriber options
			if(user!=null){
				ObjectifyService.register(Subscriber.class);
				List<Subscriber> users = ObjectifyService.ofy().load()
			 		.type(Subscriber.class).list();
				ListIterator<Subscriber> UserIt = users.listIterator();
				Subscriber jimmy = new Subscriber("jimmy");
				boolean subscriber_check = false;
				while(UserIt.hasNext()){
					jimmy.setEmail(UserIt.next().getEmail());
					if(jimmy.getEmail().equals(user.getEmail())){
						subscriber_check = true;
					}
				}
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
						<blockquote>${fn:escapeXml(post)}</blockquote>
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
