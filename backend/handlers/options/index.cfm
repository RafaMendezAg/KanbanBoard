<cfsetting enableCFoutputOnly=true>

<!--- URL por GET, FORM por POST --->
<cfparam name="url.q" default="">

<cfquery datasource="#dsn#" name="result" returntype="array">
    SELECT * FROM combo_options
        WHERE review LIKE <cfqueryparam value="#url.q#%" CFSQLType="CF_SQL_VARCHAR">
    ORDER BY position
</cfquery>

<cfset response = {
    "success": true,
    "count": #ArrayLen(result)#,
    "data": #result#
}>

<cfoutput>#SerializeJSON(response)#</cfoutput>