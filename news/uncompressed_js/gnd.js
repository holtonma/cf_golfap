var portal;     


     
	 function processFeeds(feed_data, categoryID){
	   feed_html = "";
	   feed_data.each(function(feed){ 
	     if (feed.CATEGORY == categoryID){
		   //var descrip_text = removeHTML(feed.DESCRIP);
		   var stripped_descrip = feed.DESCRIP.unescapeHTML().strip();
		   //console.log("stripped_descrip: ", stripped_descrip);
		   var articleTemplate = new Template("<div class='article_title'><a href='#{LINK}' target='_blank'>#{TITLE}</a></div><div>" + stripped_descrip + "</div>"); 
		   // rating: <div id='rating_one' class='rating_container'><a class='rating_on' href='' style='cursor: default;'></a><a class='rating_off' href='' style='cursor: default;'/></a></div>
		   // <div class='rating'>rate this article!:</div>
		   // <div class='comments'><a href=''>comments...</a></div>
		   feed_html += articleTemplate.evaluate(feed);
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
       $('failure').setStyle({borderColor: '#006600'});
       $('failure').show();
       $('failure').innerHTML = "loading all news stories...";
       // ************************** data
       var url = "getNews.cfm";
       var pars = "";
       new Ajax.Request(url, 
       {
         method: 'Post',
         asynchronous: true,
         parameters: pars,
         onFailure: function(){
           $('failure').show();
           $('failure').setStyle({borderColor: '#EE0000'});
           $('failure').innerHTML = "Please click your browser's refresh button again, the stories did not load.";
           init();
         },
         onComplete: function(transport){
           //console.log(transport);
		   var json_news = transport.responseText.evalJSON(true);
		   //console.log("json_news ", json_news);
		   var feed_data = json_news; //should be array of feed data
		   portal = new Xilinus.Portal("#page div", {onOverWidget: onOverWidget, onOutWidget: onOutWidget, onChange: onChange, removeEffect: Effect.SwitchOff}); 
           // widgets
           var category = 1; 
	       portal.add(new Xilinus.Widget().setTitle("Tour News").setContent(processFeeds(feed_data, category)), 0);
           var category = 3;   
           portal.add(new Xilinus.Widget().setTitle("Courses and Travel").setContent(processFeeds(feed_data, category)), 2);
           var category = 6;   
           portal.add(new Xilinus.Widget().setTitle("The Masters").setContent(processFeeds(feed_data, category)), 1);      
           var category = 5;   
           portal.add(new Xilinus.Widget().setTitle("USGA").setContent(processFeeds(feed_data, category)), 1);      
           var category = 4;   
           portal.add(new Xilinus.Widget().setTitle("Instruction").setContent(processFeeds(feed_data, category)), 1);      
           var category = 2;   
           portal.add(new Xilinus.Widget().setTitle("Equipment").setContent(processFeeds(feed_data, category)), 2);      
           // Add controls buttons
           portal.addWidgetControls("control_buttons");
		 },
		 onSuccess: function(){
		   $('failure').hide();
		   $('failure').innerHTML = "";
		 }
        });
     }; // init fn
     Event.observe(window, "load", init);