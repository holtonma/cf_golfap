<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

<head>
  <title>Golf News Daily</title>
  <link rel="stylesheet" href="page.css" type="text/css" media="screen" charset="utf-8" />
  <link rel="stylesheet" href="default.css" type="text/css" media="screen" charset="utf-8" />
  <script type="text/javascript" src="prototype.js"></script> 
  <script type="text/javascript" src="effects.js"></script> 
  <script type="text/javascript" src="builder.js"></script> 
  <script type="text/javascript" src="dragdrop.js"></script> 
  <script type="text/javascript" src="portal.js"></script> 
  
</head>

<body>      
  <h1>Golf News Daily</h1>
  <div id="googleads">[ads will go here]
  </div>
  <div id="page">
      <div id="widget_col_0"></div>
      <div id="widget_col_1"></div>
      <div id="widget_col_2"></div>
 </div>    
 <div id="control_buttons" style="display:none">
   <a href="#" id="edit_button"></a>
   <a href="#" id="delete_button"></a> 
 </div>

  <script type="text/javascript">
     var portal;     
     
	 function processFeeds(feed_data, categoryID){
	   // creates output HTML based on structure of JSON feed_data
	   feed_html = "";
	   feed_data.each(function(feed){ //cycle through each feed
	     // check that it is of the correct categoryID:
		 if (feed.category == categoryID){
		   //var feedTemplate = new Template("<div class='feed_title'>#{name}</div>"); // the template (our formatting expression)
		   //feed_html += feedTemplate.evaluate(feed); 
		   feed.articles.each(function(article){
		 	 var articleTemplate = new Template("<div class='article_title'><a href='#{link}'>#{title}</a></div><div>#{descrip}</div>"); 
			 //rating: <div id='rating_one' class='rating_container'><a class='rating_on' href='' style='cursor: default;'></a><a class='rating_off' href='' style='cursor: default;'/></a></div>
			 feed_html += articleTemplate.evaluate(article)
		   });
		 }
	   });
	   
	   return feed_html;
	 }
	 
	 
     function onOverWidget(portal, widget) {
       widget.getElement().insertBefore($('control_buttons'), widget.getElement().firstChild);
       $('control_buttons').show(); 
     } 
   
     function onOutWidget(portal, widget) {
       $('control_buttons').hide();      
     } 
   
     function removeWidget(element) {
       var widget = $(element).up(".widget").widget;
     
       if (confirm('Are sure to remove this widget?')) { 
         document.body.appendChild($('control_buttons').hide())
         portal.remove(widget);
       }
     }                                
                                                                                                                                                           
     function onChange() {
     }
	
     function init() {             
       // ************************** data
	   //REPLACE THIS WITH AN AJAX call to server (or a Gears call to local cache):
	   //experimental data structure from server
	   var feed_data = [];
	   var articles = [];
	   article = {'title': 'This is the title of a news article link', 'link': 'http://ukpress.google.com/article/ALeqM5i4V4iE7OVIBClHSr2swu5ICQoSpg', 'descrip': 'Tiger Woods carded a final round four-under-par 68 to win the Target World Challenge by seven strokes from Zach Johnson...',};
	   second_article = {'title': 'This is a second article', 'link': 'http://www.theage.com.au/news/golf/woods-wins-fourth-world-challenge/2007/12/17/1197740182173.html', 'descrip': 'TIGER Woods shrugged off three bogeys and an early challenge from Jim Furyk to win the Target World Challenge by a record seven shots on Sunday for his eighth victory of the year...',};
	   third_article = {'title': 'This is a third article', 'link': 'http://www.theage.com.au/news/golf/woods-wins-fourth-world-challenge/2007/12/17/1197740182173.html', 'descrip': 'TIGER Woods shrugged off three bogeys and an early challenge from Jim Furyk to win the Target World Challenge by a record seven shots on Sunday for his eighth victory of the year...',};
	   //articles.push(Object.toJSON(article));
	   //articles.push(Object.toJSON(second_article));
	   articles.push(article);
	   articles.push(second_article);
	   articles.push(third_article);
	   feed = {'name': 'Golf.com', 'category': 1, 'articles': articles};
	   feed2 = {'name': 'Golfweek.com', 'category': 2, 'articles': articles};
	   //feed_data.push(Object.toJSON(feed));
	   feed_data.push(feed);
	   feed_data.push(feed2);
	   // **********************
	   
	   portal = new Xilinus.Portal("#page div", {onOverWidget: onOverWidget, onOutWidget: onOutWidget, onChange: onChange, removeEffect: Effect.SwitchOff}); 
       // widgets
       var category = 1; 
	   portal.add(new Xilinus.Widget().setTitle("Tournaments and News").setContent(processFeeds(feed_data, category)), 0);
       var category = 2;   
       portal.add(new Xilinus.Widget().setTitle("Courses and Travel").setContent(processFeeds(feed_data, category)), 1);
       var category = 3;   
	   portal.add(new Xilinus.Widget().setTitle("Instruction").setContent(processFeeds(feed_data, category)), 2);      
       var category = 4;   
	   portal.add(new Xilinus.Widget().setTitle("Equipment").setContent(processFeeds(feed_data, category)), 2);      
       
       // Add controls buttons
       portal.addWidgetControls("control_buttons");
     }
     Event.observe(window, "load", init);
  </script>
</body>
</html>
