<!--- simple dropdown... produces tables based on Ajax request--->

<cfquery datasource="golfap" name="qtournaments">
	SELECT DISTINCT(en.name), e.id, e.year, e.dates, e.course
	FROM
	event_names en 
	INNER JOIN events e ON en.id = e.name_id
	INNER JOIN golfer_history gh ON gh.event_id = e.id
</cfquery>

<cfdump var="#qtournaments#">
	
<div id="container">
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


</script>
