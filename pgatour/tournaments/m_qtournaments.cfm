
<cfquery datasource="golfap" name="qtournaments">
	SELECT DISTINCT(en.name), e.id, e.year, e.dates, e.course, e.dates
	FROM
	event_names en 
	INNER JOIN events e ON en.id = e.name_id
	INNER JOIN golfer_history gh ON gh.event_id = e.id
	ORDER BY e.start_date DESC
</cfquery>