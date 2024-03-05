<cfsetting enableCFoutputOnly=true>

<cfinclude template="../../repositories/kanbanRepo.cfm">
	
<cfset response={}>



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
    <cfcase value="PUT">
        <cfset validParams=getParams([
            { "name": "id", "type": "numeric", "required": "1" },
            { "name": "column_id", "type": "numeric", "default": "1" },
            { "name": "title", "type": "text", "default": "" },
            { "name": "content", "type": "text", "default": "" },
            { "name": "icon", "type": "text", "default": "" },
            { "name": "position", "type": "numeric", "default": "1" },
            { "name": "active", "type": "boolean", "default": "1" }
        ])>
			
		<cfset response=kanban_update(validParams)>
        
    </cfcase>
    <cfdefaultcase>
		<cfparam name="url.columnId" default="0">
			
		<cfset response=kanban_select(url.columnId)>
    </cfdefaultcase>
</cfswitch>




<cfoutput>#SerializeJSON(response)#</cfoutput>

