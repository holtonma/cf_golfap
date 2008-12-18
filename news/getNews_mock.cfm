<cfset REQUEST.DSN = "golfap">

<cfset qGetNews = QueryNew("categoryID, categoryName, storyID, link, title, summary", "Integer, VarChar, Integer, VarChar, VarChar, VarChar")>  
<!--- Make 2 rows in the mock recordset --->
<cfset newRow = QueryAddRow(qGetNews, 2)> 
<!--- Set the values of the cells in the query --->
<cfset temp = QuerySetCell(qGetNews, "categoryID", 1, 1)>
<cfset temp = QuerySetCell(qGetNews, "categoryName", "tournament", 1)>
<cfset temp = QuerySetCell(qGetNews, "storyID", "12", 1)>
<cfset temp = QuerySetCell(qGetNews, "link", "http://ukpress.google.com/article/ALeqM5i4V4iE7OVIBClHSr2swu5ICQoSpg", 1)>
<cfset temp = QuerySetCell(qGetNews, "title", "This is the title of a news article link", 1)>
<cfset temp = QuerySetCell(qGetNews, "summary", "TIGER Woods shrugged off three bogeys and an early challenge from Jim Furyk to win the Target World Challenge by a record seven shots on Sunday for his eighth victory of the year...", 1)>

<cfset temp = QuerySetCell(qGetNews, "categoryID", 2, 2)>
<cfset temp = QuerySetCell(qGetNews, "categoryName", "travel", 2)>
<cfset temp = QuerySetCell(qGetNews, "storyID", "22", 2)>
<cfset temp = QuerySetCell(qGetNews, "link", "http://www.theage.com.au/news/golf/woods-wins-fourth-world-challenge/2007/12/17/1197740182173.html", 2)>
<cfset temp = QuerySetCell(qGetNews, "title", "This is the 2nd article", 2)>
<cfset temp = QuerySetCell(qGetNews, "summary", "Tiger Woods carded a final round four-under-par 68 to win the Target World Challenge by seven strokes from Zach Johnson...", 2)>

<cfset aNews = ArrayNew(1)>
<cfoutput query="qGetNews"> <!--- loop through and create struct--->
<!--- Append a new element to the array.  This element is a new structure. --->
	<cfset temp = arrayAppend(aNews, structNew())>
	<cfset thisStoryIndex = #ArrayLen(aNews)#> <!--- array length is same value as next item in array --->
	<!--- <cfset aNews[thisFeedIndex].name = qGetNews.GroupID> --->
	<cfset aNews[thisStoryIndex].category = qGetNews.categoryID>
	<cfset aNews[thisStoryIndex].categoryName = qGetNews.categoryName>
	<cfset aNews[thisStoryIndex].storyID = qGetNews.storyID>
	<cfset aNews[thisStoryIndex].link = qGetNews.link>
	<cfset aNews[thisStoryIndex].title = qGetNews.title>
	<cfset aNews[thisStoryIndex].descrip = qGetNews.summary>
</cfoutput>

<!--- convert structure to JSON --->
<cfinvoke component="json" method="encode" data="#aNews#" returnvariable="JSONresult" /> 

<cfoutput>#JSONresult#</cfoutput>