<cfsetting enableCFoutputOnly=true>

<cfparam name="url.columnId" default="1">

<cfset response={}>

<cfset fields = {
    title: 'string',
    content: 'string',
    id: 'number',
    column_id: 'number',
    active: 'boolean',
    position: 'number',
    icon: 'string'
}>

<cfswitch expression="#CGI.request_method#">
    <cfcase value="POST">
        <cfset requestData=#GetHttpRequestData()#>
		<cfset values=#deserializeJson(requestData.content)#>
        <cfif NOT isNumeric(values.columnId) or NOT isNumeric(values.id)>
            <cfset response={
                "success": false
            }>
        <cfelse>
            <cfquery datasource="#dsn#" name="saveColumn">
                UPDATE kanban_blocks SET
                    column_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#values.columnId#">
                WHERE
                    id=<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#values.id#">
            </cfquery>
            <cfset response={
                "success": true,
                "column": #values.columnId#,
                "id": #values.id#
            }>
        </cfif>
    </cfcase>
    <cfdefaultcase>
        <!--- PROCESS SORT --->
            <cfset sortArray=[{ "property": "position", "direction": "ASC"}]>
            <cfif isDefined('url.sort')>
                <cftry>
                    <cfset sortArray=deserializeJSON(url.sort)>
                    <cfcatch type="any"></cfcatch>
                </cftry>
            </cfif>
        <!--- PROCESS FILTER --->
            <cfset filterArray=[]>
            <cfif isDefined('url.filter')>
                <cftry>
                    <cfset filterArray=deserializeJSON(url.filter)>
                    <cfcatch type="any"></cfcatch>
                </cftry>
            </cfif>
        <cfquery datasource="#dsn#" name="getColumns" returntype="array">
            SELECT * 
            FROM kanban_blocks
            WHERE
                1=1
                <cfloop index="i" from="1" to="#ArrayLen(filterArray)#">
                    <cfset el=filterArray[i]>
                    <cfif fields[el.property] IS 'string'>
                        AND #el.property# LIKE <cfqueryparam value="#el.value#%" CFSQLTYPE="CF_SQL_VARCHAR">
                    <cfelseif fields[el.property] IS 'boolean'>
                        <cfset value=el.value ? 1 : 0>
                        AND #el.property# = '#value#'
                    <cfelse>
                        AND #el.property# #getOperator(el.operator)# <cfqueryparam value="#el.value#" CFSQLTYPE="CF_SQL_VARCHAR">
                    </cfif>
                </cfloop>
            ORDER BY 
            <cfloop index="i" from="1" to="#ArrayLen(sortArray)#">
                <cfset el=sortArray[i]>
                #el.property# #el.direction# <cfif i LT ArrayLen(sortArray)>,</cfif>
            </cfloop>
        </cfquery>

        <cfset response = {
            "success": true,
            "count": #ArrayLen(getColumns)#,
            "data": #getColumns#
        }>
    </cfdefaultcase>
</cfswitch>


<cfoutput>#SerializeJSON(response)#</cfoutput>