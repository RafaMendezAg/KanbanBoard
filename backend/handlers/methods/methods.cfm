


<cffunction name="serializeData">
	<cfargument name="params" type="struct" required="yes">
		
	<cfset success = isDefined('params.success') ? params.success : true>
	<cfset structDelete(params,'SUCCESS')>
	<cfset params['success']=success> <!--- THIS WILL MAKE SURE IT IS LOWERCASE --->
	<cfset newParams=SerializeJSON(params)>
	<cfreturn newParams>
</cffunction>


<cffunction name="getOperator">
	<cfargument name="operator" type="string" required="yes">
	<cfset op="=">
	<cfswitch expression="#operator#">
		<cfcase value="LT"><cfset op="<"></cfcase>
		<cfcase value="LTE"><cfset op="<="></cfcase>
		<cfcase value="GT"><cfset op=">"></cfcase>
		<cfcase value="GTE"><cfset op=">="></cfcase>
		<cfcase value="EQ"><cfset op="="></cfcase>
		<cfcase value="IS"><cfset op="="></cfcase>
	</cfswitch>
	<cfreturn op>
</cffunction>

<cffunction name="getParams">
	<cfargument name="params" type="array" required="yes">
	<cfset requestData=#GetHttpRequestData()#>

	<cfset validParams={
		"success": true,
		"message": "Ok",
		"params": #deserializeJson(requestData.content)#
	}>
	<cfloop index="i" from="1" to="#ArrayLen(params)#">
		<cfset validation=params[i]>
		<cfif NOT isDefined('validParams.params.#validation.name#')>
			<!--- PARAM NOT AVAILABLE --->
				<cfif isDefined('validation.default')>
					<cfset validParams.params[validation.name] = validation.default>
				<cfelseif isDefined('validation.required')>
					<cfset validParams.success=false>
					<cfset validParams.message="Parametro #encodeforhtml(validation.name)# no encontrado">
				<cfelseif isDefined('validation.type')>
					<cfset validParam=validParams.params[validation.name]>
					<cfswitch expression="#validation.type#">
						<cfcase value="number">
							<cfif NOT isNumeric(validParam)>
								<cfset validParams.success=false>
								<cfset validParams.message="Parametro #encodeforhtml(validation.name)# no es numérico">
							</cfif>
						</cfcase>
						<cfcase value="boolean">
							<cfif validParam NEQ true AND validParam NEQ false>
								<cfset validParams.success=false>
								<cfset validParams.message="Parametro #encodeforhtml(validation.name)# no es booleano">
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>	
		</cfif>
		
	</cfloop>

	<cfreturn validParams>
</cffunction>