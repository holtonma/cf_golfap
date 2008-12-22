<!--- grab the tourney table based on the param passed in --->
<cfset tourney_id = Val(FORM.playerid)>

<cfoutput>
<cfquery datasource="golfap" name="qPlayerInfo">
select e.name, e.id, g.fname, g.lname, e.dates, gh.to_par, gh.thru, gh.r1, gh.r2, gh.r3, gh.r4, gh.total, gh.today, gh.pos, gh.madecut
	from
	golfer_history gh 
	INNER JOIN golfer g ON g.id = gh.golfer_id
	INNER JOIN events e ON e.id = gh.event_id
	where g.id = #tourney_id#
	order by e.start_date DESC, e.id DESC, gh.thru DESC, gh.madecut DESC, gh.total ASC
</cfquery>
</cfoutput>

<cfsavecontent variable="tourney">
	<table id="tournament">
		<tr>
			<th>Name</th><th>Tournament</th><th>Dates</th><th>Made Cut?</th><th>Finish</th><th>Sunday</th>
			<th>Thru</th><th>R1</th><th>R2</th><th>R3</th><th>R4</th><th>Total</th>
		</tr>
		<cfset oddeven = 0>
		<cfoutput query="qPlayerInfo">
		<cfset oddeven = oddeven + 1>
		<cfif (oddeven mod 2) eq 1>
			<cfset tdclass = "odd">
		<cfelse>
			<cfset tdclass = "even">
		</cfif>
			
		<tr style="border:1px solid silver;">
			<td class="#tdclass#">#lname#, #fname#</td>
			<td class="#tdclass#"><b>#name#</b></td>
			<td><div style="font-size:9px;">#dates#</div></td>
			<td class="#tdclass#" align="center">
				<cfif madecut gte 0>
					<span style="font-size:11px;color:green;font-weight:bold;">✓</span>
				<cfelse>
					<span style="font-size:10px;color:red;font-weight:bold;">cut</span>
				</cfif>
			</td>
			<td class="#tdclass#" align="center">#pos#</td>
			<td class="#tdclass#" align="center">#today#</td>
			<td class="#tdclass#" align="center">#thru#</td>
			<td class="#tdclass#" align="center">#r1#</td>
			<td class="#tdclass#" align="center">#r2#</td>
			<td class="#tdclass#" align="center">#r3#</td>
			<td class="#tdclass#" align="center">#r4#</td>
			<td class="#tdclass#" align="center">#Total#</td>
		</tr>
		</cfoutput>
		
	</table>
</cfsavecontent>
	
<cfoutput>
	#tourney#
</cfoutput>
	
