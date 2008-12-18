
<cfoutput>
 
<h1>Separated Requests</h1>
Use this section to add user logins to this application.<br /><br />

<script type="text/javascript" src="prototype.js"></script> 
  
<!--- Form --->
<cfset numBoxes = 5>
<cfif isdefined("txtNumBoxes")><cfset numBoxes = numBoxes + txtNumBoxes></cfif>

<table cellpadding="0" cellspacing="0" class="tabSpaceMed">
	<tr>
		<td>&nbsp;</td>
		<td><strong>Existing Login:</strong></td>
		<td><input type="text" name="txtUserLogin" id="II" value="" class="W100" disabled="disabled"/></td>
		<!--- <td><input type="text" name="tya" id="II" value="" class="W100"/></td> --->
	</tr>
	<cfloop index="ii" from="1" to="#numBoxes#">
	<tr>
		<td>&nbsp;</td>
		<td><strong>Login #ii#:</strong></td>
		<td><input type="text" name="txtUserLogin" id="II" value="" class="W100"/></td>
		<!--- <td><input type="text" name="tya" id="II" value="" class="W100"/></td> --->
	</tr>
	</cfloop>
	<tr>
		<td>&nbsp;</td>
		<td><strong>Output:</strong></td>
		<td><input type="text" id="cdl_output" value="" size="40" disabled></td>
	</tr>
	<tr>
		<td colspan="3"><button id="btnProcess">Process</button></td>
	</tr>
</table>

<br />
<cfloop index="bb" from="1" to="30">
	<br />
</cfloop>
<input type=submit value="OK">
<input type=button value="cancel" onClick="self.close();">
</cfoutput>

<script type="text/javascript">
  function process(){
    console.log("all form elems: ", $$('.W100'));
	cdl_list = ""
	$$('.W100').each(function(f){
	  //if f.value.length
	  if (f.value.length == 6 && f.value != ""){
	  	console.log("form value: ", f.value);
		cdl_list += f.value + ", ";
	  }else{
	  	console.log("invalid");
	  };
	});
	$('cdl_output').value = cdl_list;
  }
</script>
	
</body>
</html>