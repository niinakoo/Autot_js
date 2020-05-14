<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Auton muutos</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="3" id="ilmo"></th>
				<th colspan="2" class="oikealle"><a href="listaaautot.jsp" id="takaisin">Takaisin listaukseen</a></th>
			</tr>		
			<tr>
				<th>RekNo</th>
				<th>Merkki</th>
				<th>Malli</th>
				<th>Vuosi</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="rekNo" id="rekNo"></td>
				<td><input type="text" name="merkki" id="merkki"></td>
				<td><input type="text" name="malli" id="malli"></td>
				<td><input type="text" name="vuosi" id="vuosi"></td> 
				<td><input type="button" id="tallenna" value="Hyv�ksy" onclick="vieTiedot()"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="vanharekno" id="vanharekno">	
</form>
<span id="ilmo"></span>
</body>
<script>

function tutkiKeyX(event){
	if(event.keyCode==13){//Enter
		vieTiedot();
	}		
}

var tutkiKey = (event) => {
	if(event.keyCode==13){//Enter
		vieTiedot();
	}	
}

document.getElementById("rekNo").focus();//vied��n kursori rekno-kentt��n sivun latauksen yhteydess�

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja v�litet��n kutsun mukana muutettavan tiedon id
//GET /asiakkaat/haeyksi/id
var rekno = requestURLParam("rekno"); //Funktio l�ytyy scripts/main.js 
fetch("autot/haeyksi/" + rekno,{//L�hetet��n kutsu backendiin
      method: 'GET'	      
    })
.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�	
	console.log(responseJson);
	document.getElementById("rekNo").value = responseJson.rekno;		
	document.getElementById("merkki").value = responseJson.merkki;	
	document.getElementById("malli").value = responseJson.malli;	
	document.getElementById("vuosi").value = responseJson.vuosi;	
	document.getElementById("vanharekno").value = responseJson.rekno;	
});	

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja v�litet��n kutsun mukana muutetut tiedot json-stringin�.
//PUT /autot/
function vieTiedot(){	
	var ilmo="";
	var d = new Date();
	if(document.getElementById("rekNo").value.length<3){
		ilmo="Rekisterinumero ei kelpaa!";		
	}else if(document.getElementById("merkki").value.length<2){
		ilmo="Merkki ei kelpaa!";		
	}else if(document.getElementById("malli").value.length<1){
		ilmo="Malli ei kelpaa!";		
	}else if(document.getElementById("vuosi").value*1!=document.getElementById("vuosi").value){
		ilmo="Vuosi ei ole luku!";		
	}else if(document.getElementById("vuosi").value<1900 || document.getElementById("vuosi").value>d.getFullYear()+1){
		ilmo="Vuosi ei kelpaa!";		
	}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("rekNo").value=siivoa(document.getElementById("rekNo").value);
	document.getElementById("merkki").value=siivoa(document.getElementById("merkki").value);
	document.getElementById("malli").value=siivoa(document.getElementById("malli").value);
	document.getElementById("vuosi").value=siivoa(document.getElementById("vuosi").value);	
	
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	//L�het��n muutetut tiedot backendiin
	fetch("autot",{//L�hetet��n kutsu backendiin
	      method: 'PUT',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Tietojen p�ivitys ep�onnistui";
        }else if(vastaus==1){	        	
        	document.getElementById("ilmo").innerHTML= "Tietojen p�ivitys onnistui";			      	
		}	
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennet��n tiedot -lomake
}
</script>
</html>