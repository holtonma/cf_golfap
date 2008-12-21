<cfinclude template="header.cfm">
 <script type="text/javascript" src="../../prototype.js"></script>   
 <!--- <script type="text/javascript" src="combined.js"></script>  ---> 
 <script type="text/javascript" src="../../effects.js"></script> 
 <script type="text/javascript" src="../../builder.js"></script> 
 <script type="text/javascript" src="../../dragdrop.js"></script> 
 <script type="text/javascript" src="../../portal.js"></script>
 <script type="text/javascript" src="../../firebug.js"></script>

<body id="bTour">      
  <!--- <h1>Golf News Daily</h1> --->
  <div id="googleads"></div>

<div align="center">
	PGATour Golf Results.   
	<b><cfoutput>#DateFormat(Now(), "Long")#</cfoutput></b> : send feedback to <b>holtonma(at)gmail(dot)com</b>
</div>

<!--- simple dropdown... produces tables based on Ajax request--->

<cfquery datasource="golfap" name="qtournaments">
	SELECT DISTINCT(en.name), e.id, e.year, e.dates, e.course
	FROM
	event_names en 
	INNER JOIN events e ON en.id = e.name_id
	INNER JOIN golfer_history gh ON gh.event_id = e.id
</cfquery>

<!--- <cfdump var="#qtournaments#"> --->
	
<div id="container">
	<div align="center">Select Tournament:</div>
	<div align="center">
		<select id="tournaments">
			<cfoutput query="qtournaments">
				<option value="#ID#">#Year# #Name#</option>
			</cfoutput>
		</select>
	</div>
	
	<div id="tourney_results">
	</div>
</div>


<script type="text/javascript">
// connect change event to select box "tournaments"
// load via ajax call... table from back end
// tourney data  -- stuff into "div#tourney_results"
</script>
 
 
 
</body>
</html>
