<!--- 
Mock data that will populate group dropdown with GroupID, GroupName
 --->

<!--- mock query for now simulates entire database  --->
	<!--- Create a new two-column query, specifying the column data types --->
	<cfset qMock = QueryNew("GroupID, GroupName, CreatorCUID, CreatorFName, CreatorLName, DateCreated", "Integer, VarChar, VarChar, VarChar, VarChar, VarChar")>  
	<!--- Make 2 rows in the mock recordset --->
	<cfset newRow = QueryAddRow(qMock, 3)> 
	<!--- Set the values of the cells in the query --->
	<cfset temp = QuerySetCell(qMock, "GroupID", 1, 1)>
	<cfset temp = QuerySetCell(qMock, "GroupName", "magical", 1)>
	
	<cfset temp = QuerySetCell(qMock, "GroupID", 2, 2)>
	<cfset temp = QuerySetCell(qMock, "GroupName", "albatross", 2)>
	
	<cfset temp = QuerySetCell(qMock, "GroupID", 3, 3)>
	<cfset temp = QuerySetCell(qMock, "GroupName", "ubuntu", 3)>
	
	<!--- the following query of the above recordset will mock the query passed to the stored proc. --->
	<cfoutput>
		<cfquery name="qGetAllGroups" dbtype="query">
			SELECT 
				GroupID, GroupName
			FROM
				qMock
		</cfquery>
	</cfoutput> 

<!--- 3. turn this recordset into an Array of structures 
(structure = Associative Array; name-value pairs that will be turned into JSON) --->

<cfset aResult = ArrayNew(1)>

<!--- loop through matching recordset and store in array of structures: --->	
	<cfoutput query="qGetAllGroups">
		<!--- Append a new element to the array.  This element is a new structure. --->
		<cfset temp = arrayAppend(aResult, structNew())>
		<!--- Set up a variable to hold the array position that we're inserting into. --->
		<cfset thisRSItem = #ArrayLen(aResult)#> <!--- array length is same value as next item in array --->
		<!--- Populate the new structure with the item information passed from the form. --->
		<cfset aResult[thisRSItem].GroupID = qGetAllGroups.GroupID>
		<cfset aResult[thisRSItem].GroupName = qGetAllGroups.GroupName>
	</cfoutput>  

<!--- 4. convert structure to JSON --->
<cfinvoke component="json" method="encode" data="#aResult#" returnvariable="JSONresult" /> 

<cfoutput>#JSONresult#</cfoutput>
<!--- <cfdump var="#result#"> ---> 


