<cfset REQUEST.DSN = "golfap">

<cfquery name="qGetNews" datasource="#REQUEST.DSN#" username="golfap" password="Aviaryv1">
	SELECT
		tF.categoryID, 
		tC.categoryName,
		tS.storyID, tS.link, tS.title, tS.summary
	FROM
		tStories tS LEFT OUTER JOIN tFeeds tF ON tS.feedID = tF.feedID
		LEFT OUTER JOIN tCategories tC ON tF.categoryID = tC.categoryID
	ORDER BY tS.storyID DESC
</cfquery>


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
		<!---
		<cfset aArticles = ArrayNew(1)>
		<cfquery name="qGetNews" datasource="#REQUEST.DSN#">
			SELECT
				tS.link, tS.title, tS.descrip, tS.rating
			FROM
				tStories tS
			WHERE tS.feedID = #qGetNews.feedID#
			LIMIT 10
		</cfquery>
		<cfset aArticles = ArrayNew(1)>
		<cfoutput query="qGetArticles">
			<cfset article_temp = arrayAppend(aArticles, structNew())>
			<cfset thisArticleIndex = #ArrayLen(aArticles)#>
			<cfset aArticles[thisArticleIndex].link = qGetArticles.link>
			<cfset aArticles[thisFeedIndex].title = qGetArticles.title>
			<cfset aArticles[thisFeedIndex].descrip = qGetArticles.descrip>
			<cfset aArticles[thisFeedIndex].id = qGetArticles.id>
		</cfoutput>
		<cfset aNews[thisFeedIndex].articles = aArticles>
		--->
</cfoutput>

<!--- convert structure to JSON --->
<cfinvoke component="json" method="encode" data="#aNews#" returnvariable="JSONresult" /> 

<cfoutput>#JSONresult#</cfoutput>
