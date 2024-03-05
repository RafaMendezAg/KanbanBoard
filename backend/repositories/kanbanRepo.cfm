

<!--- SELECT --->
	<cffunction name="kanban_select">
		<cfargument name="columnId" required="yes">

		<cfquery datasource="#dsn#" name="getColumns" returntype="array">
            SELECT * 
            FROM kanban_blocks
			<cfif columnId NEQ 0>
				WHERE column_id=<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#columnId#">
				  AND active=1
			</cfif>
        </cfquery>

        <cfreturn {
            "success": true,
            "count": #ArrayLen(getColumns)#,
            "data": #getColumns#,
			   "other": "x"
        }>
	</cffunction>

<!--- INSERT --->
	<cffunction name="kanban_insert">
		<cfargument name="validParams" required="yes">
		<cfquery datasource="#dsn#" name="updateInfo">
			INSERT INTO kanban_blocks
			(column_id,position,title,content,icon,active)
			VALUES
			(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#validParams.column_id#">,
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#validParams.position#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.title#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.content#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.icon#">,
				<cfqueryparam CFSQLType="CF_SQL_TINYINT" value="#validParams.active#">
			)
		</cfquery>

		<cfreturn {
			"success": validParams.success,
			"message": validParams.message,
			"id": #validParams.params.id#
		}>
	</cffunction>
					
					
<!--- UPDATE --->
	<cffunction name="kanban_update">
		<cfargument name="validParams" required="yes">
		<cfquery datasource="#dsn#" name="updateInfo">
			UPDATE kanban_blocks SET
				column_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#validParams.column_id#">,
				position = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#validParams.position#">,
				title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.title#">,
				content = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.content#">,
				icon = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#validParams.icon#">,
				active = <cfqueryparam CFSQLType="CF_SQL_TINYINT" value="#validParams.active#">
			WHERE
				id=<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#position.id#"> 
		</cfquery>

		<cfreturn {
			"success": validParams.success,
			"message": validParams.message,
			"id": #validParams.params.id#
		}>
	</cffunction>

