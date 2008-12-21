<cfinclude template="header.cfm">

<body id="bNews">      
  <!--- <h1>Golf News Daily</h1> --->
  <div id="googleads">
	<script type="text/javascript"><!--
	google_ad_client = "pub-3488777663690401";
	//728x90, created 12/28/07
	google_ad_slot = "2762915219";
	google_ad_width = 728;
	google_ad_height = 90;
	//--></script>
	<script type="text/javascript"
	src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
	</script>
  </div>
<div align="center">
	Golf news articles for today, 
	<b><cfoutput>#DateFormat(Now(), "Long")#</cfoutput></b> : 
	currently aggregating 14 golf news feeds :
	send feedback to <b>holtonma(at)gmail(dot)com</b>
</div>
<div id="failure"></div>
<div id="page">
      <div id="widget_col_0"></div>
      <div id="widget_col_1"></div>
      <div id="widget_col_2"></div>
 </div>    
 <div id="control_buttons" style="display:none">
   <a href="#" id="edit_button"></a>
   <a href="#" id="delete_button"></a> <!--- onclick="removeWidget(this); return false;"  --->
 </div>
 <script type="text/javascript" src="prototype.js"></script>   
 <!--- <script type="text/javascript" src="combined.js"></script>  ---> 
 <script type="text/javascript" src="effects.js"></script> 
 <script type="text/javascript" src="builder.js"></script> 
 <script type="text/javascript" src="dragdrop.js"></script> 
 <script type="text/javascript" src="portal.js"></script>
 <script type="text/javascript" src="firebug.js"></script>  
 <script type="text/javascript" src="gnd.js"></script>
 <script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
 </script>
 <script type="text/javascript">
  var pageTracker = _gat._getTracker("UA-254105-3");
  pageTracker._initData();
  pageTracker._trackPageview();
 </script>
</body>
</html>
