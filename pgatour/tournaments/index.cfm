<cfinclude template="header.cfm">

<cfparam name="URL.ID" default="91"> <!--- change this code to TOP 1, order by start_date DESC--->
	
<body id="bTour">      
  <!--- <h1>Golf News Daily</h1> --->
  <div id="googleads"></div>

	<!--- initial grab of all tourneys--->
	<cfinclude template="m_qtournaments.cfm"> <!--- <cfdump var="#qtournaments#"> --->

	<div id="container" style="padding:8px;">
		<span align="left">Select Tournament:</span>
		<span align="left">
			<select id="tournaments">
				<cfoutput query="qtournaments">
					<option value="#ID#" <cfif ID eq URL.ID>SELECTED</cfif>>#Year# #Name#</option>
				</cfoutput>
			</select>
		</span>
	
		<div id="tourney_results"></div>
	</div>


<script type="text/javascript">
// connect change event to select box "tournaments"
// load via ajax call... table from back end
// tourney data  -- stuff into "div#tourney_results"
function grab_tourney(){
	elem = $('tourney_results');    
	var url = "ajax_getTourney.cfm";
	var pars = "FORM.tourneyid=" + $('tournaments').value;
	new Ajax.Updater('tourney_results', url, 
	{
	 method: 'Post',
	 asynchronous: true,
	 parameters: pars
	});
} //grab_tourney fn


function init() {      
	var elem = $('tourney_results');     
	var url = "ajax_getTourney.cfm";
	var pars = "FORM.tourneyid=" + $('tournaments').value;
	new Ajax.Updater('tourney_results', url, 
	{
	 method: 'Post',
	 asynchronous: true,
	 parameters: pars,
	 onFailure: function(){
	   elem.show();
	   //elem.setStyle({borderColor: '#EE0000'});
	   elem.innerHTML = "Please click your browser's refresh button again, the tournaments did not load.";
	   //init();
	 }
	});
} // init fn


Event.observe(window, "load", function(){
	init();
	Event.observe('tournaments', "change", grab_tourney);
});
</script>
 
 
 
</body>
</html>
