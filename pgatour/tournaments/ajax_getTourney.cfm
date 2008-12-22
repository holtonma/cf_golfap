<!--- grab the tourney table based on the param passed in --->
<cfset tourney_id = Val(FORM.tourneyid)>

<cfoutput>
<cfquery datasource="golfap" name="qThisTourney">
	SELECT e.name, g.fname, g.lname, gh.to_par, gh.thru, gh.r1, gh.r2, gh.r3, gh.r4, gh.total, gh.today, gh.pos
	FROM golfer_history gh 
	INNER JOIN golfer g ON g.id = gh.golfer_id
	INNER JOIN events e ON e.id = gh.event_id
	WHERE e.id = #tourney_id#
	ORDER BY gh.madecut DESC, gh.total ASC, e.id DESC, gh.thru DESC 
</cfquery>
</cfoutput>

<cfsavecontent variable="tourney">
	<table id="tournament">
		<tr>
			<th>Pos</th><th>Name</th><th>Today</th><th>Thru</th><th>R1</th><th>R2</th><th>R3</th><th>R4</th><th>Total</th><th>To Par</th>
		</tr>
		<cfset oddeven = 0>
		<cfoutput query="qThisTourney">
		<cfset oddeven = oddeven + 1>
		<cfif (oddeven mod 2) eq 1>
			<cfset tdclass = "odd">
		<cfelse>
			<cfset tdclass = "even">
		</cfif>
			
		<tr style="border:1px solid silver;">
			<td class="#tdclass#">#pos#</td>
			<td class="#tdclass#">#lname#, #fname#</td>
			<td class="#tdclass#" align="center">#today#</td>
			<td class="#tdclass#" align="center">#thru#</td>
			<td class="#tdclass#" align="center">#r1#</td>
			<td class="#tdclass#" align="center">#r2#</td>
			<td class="#tdclass#" align="center">#r3#</td>
			<td class="#tdclass#" align="center">#r4#</td>
			<td class="#tdclass#" align="center">#Total#</td>
			<td class="#tdclass#" align="center">#to_par#</td>
		</tr>
		</cfoutput>
		
	</table>
</cfsavecontent>
	
<cfoutput>
	#tourney#
</cfoutput>
	
