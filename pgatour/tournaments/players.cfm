<cfinclude template="header.cfm">

<body id="bTour">      
  <!--- <h1>Golf News Daily</h1> --->
  <div id="googleads"></div>

<cfparam name="URL.ID" default="1">
<!--- simple dropdown... produces tables based on Ajax request--->

<cfquery datasource="golfap" name="qPlayers">
	SELECT g.fname, g.lname, g.id
	FROM
	golfer g 
	ORDER BY g.lname ASC
</cfquery>

<!--- <cfdump var="#qtournaments#"> --->
	
<div id="container" style="padding:8px;">
	<span align="left">Select Player:</span>
	<span align="left">
		<select id="players">
			<cfoutput query="qPlayers">
				<option value="#ID#" <cfif URL.ID eq ID>selected</cfif> >#Lname#, #Fname#</option>
			</cfoutput>
		</select>
	</span>
	
	<div id="player_results">
	</div>
</div>


<script type="text/javascript">
// connect change event to select box "tournaments"
// load via ajax call... table from back end
// tourney data  -- stuff into "div#tourney_results"
function grab_players(){
	elem = $('player_results');    
	var url = "ajax_getPlayerData.cfm";
	var pars = "FORM.playerid=" + $('players').value;
	new Ajax.Updater('player_results', url, 
	{
	 method: 'Post',
	 asynchronous: true,
	 parameters: pars
	});
} //grab_tourney fn


function init() {      
	var elem = $('player_results');     
	var url = "ajax_getPlayerData.cfm";
	var pars = "FORM.playerid=" + $('players').value;
	new Ajax.Updater('player_results', url, 
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
	Event.observe('players', "change", grab_players);
});
</script>
 
 
 
</body>
</html>
