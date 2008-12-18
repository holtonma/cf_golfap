
<cfset groupnamecleaned = TRIM(LCase(FORM.GroupName))>
<cfset creatorcuidpar = TRIM(LCase(FORM.CreatorCUID))>
<cfset creatorfnamepar = "spWill_grab_FName_via_CUID">
<cfset creatorlnamepar = "spWill_grab_LName_via_CUID">
<cfset datecreatedpar = CreateODBCDateTime(Now())>  

<!--- mock query for now simulates entire database  --->
	<!--- Create a new two-column query, specifying the column data types --->
	<cfset qMock = QueryNew("GroupID, GroupName, CreatorCUID, CreatorFName, CreatorLName, DateCreated", "Integer, VarChar, VarChar, VarChar, VarChar, VarChar")>  
	<!--- Make 2 rows in the mock recordset --->
	<cfset newRow = QueryAddRow(qMock, 2)> 
	<!--- Set the values of the cells in the query --->
	<cfset temp = QuerySetCell(qMock, "GroupID", 1, 1)>
	<cfset temp = QuerySetCell(qMock, "GroupName", "magical", 1)>
	<cfset temp = QuerySetCell(qMock, "CreatorCUID", "mh1234", 1)>
	<cfset temp = QuerySetCell(qMock, "CreatorFName", "Mark", 1)>
	<cfset temp = QuerySetCell(qMock, "CreatorLName", "Holton", 1)>
	<cfset temp = QuerySetCell(qMock, "DateCreated", "05/01/1975", 1)>
	
	<cfset temp = QuerySetCell(qMock, "GroupID", 2, 2)>
	<cfset temp = QuerySetCell(qMock, "GroupName", "albatross", 2)>
	<cfset temp = QuerySetCell(qMock, "CreatorCUID", "zz7654", 2)>
	<cfset temp = QuerySetCell(qMock, "CreatorFName", "Jim", 2)>
	<cfset temp = QuerySetCell(qMock, "CreatorLName", "Johnson", 2)>
	<cfset temp = QuerySetCell(qMock, "DateCreated", "06/01/1985", 2)>

<!--- when mocking recordset, just call the groupid = 3; this will be an auto-increment in database --->
	<cfset newRow = QueryAddRow(qMock, 1)> <!--- add 1 new row --->
	
	<cfset temp = QuerySetCell(qMock, "GroupID", 3, 3)>
	<cfset temp = QuerySetCell(qMock, "GroupName", #groupnamecleaned#, 3)>
	<cfset temp = QuerySetCell(qMock, "CreatorCUID", #creatorcuidpar#, 3)>
	<cfset temp = QuerySetCell(qMock, "CreatorFName", #creatorfnamepar#, 3)>
	<cfset temp = QuerySetCell(qMock, "CreatorLName", #creatorlnamepar#, 3)>
	<cfset temp = QuerySetCell(qMock, "DateCreated", #datecreatedpar#, 3)>

	<!--- the following query of the above recordset will mock the query passed to the stored proc. --->
	<cfoutput>
		<cfquery name="qGetThisGroup" dbtype="query">
			SELECT 
				GroupID, GroupName, CreatorCUID, CreatorFName, CreatorLName, DateCreated
			FROM
				qMock
			WHERE
				qMock.GroupName = '#groupnamecleaned#'
		</cfquery>
	</cfoutput> 
	
	<!--- <cfdump var="#qMock#">
	<cfdump var="#qGetMatching#"> --->
	
	<cfif qGetThisGroup.RecordCount eq 1>
		<cfset groupAdded = 1>
	<cfelse>
		<cfset groupAdded = 0>
	</cfif> 
	
	<!--- create structure that will be converted into JavaScript Object Notation: holding elems added to database --->
	<cfscript>
    	sGroupAdded = StructNew();
    	sGroupAdded["validAdd"] = #groupAdded#;
    	sGroupAdded["GroupID"] = #qGetThisGroup.GroupID#;
    	sGroupAdded["GroupName"] = #qGetThisGroup.GroupName#;
    	sGroupAdded["CreatorCUID"] = #qGetThisGroup.CreatorCUID#;
    	sGroupAdded["CreatorFName"] = #qGetThisGroup.CreatorFName#;
    	sGroupAdded["CreatorLName"] = #qGetThisGroup.CreatorLName#;
    	sGroupAdded["DateCreated"] = #DateFormat(qGetThisGroup.DateCreated, "short")#;
    </cfscript>
	
	

<!--- 4. convert structure to JSON --->
<cfinvoke component="json" method="encode" data="#sGroupAdded#" returnvariable="JSONresult" /> 

<cfoutput>#JSONresult#</cfoutput>
<!--- <cfdump var="#result#"> ---> 


