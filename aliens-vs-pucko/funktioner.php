<?php

// Function to debug 
function debug($o){
	echo '<pre>';
	print_r($o);
	echo '</pre>';
}

// debug($row);
		
//Funktion som laddar om sidan
function reload(){
	$path=$_SERVER['REQUEST_URI']; //Sidans adress sparas i variabeln $path.
	$file=basename($path); //Filnamnet och extensionen sparas i variabeln $file.
	header("Location: ".$file); //Sidan laddas om.
}

//Funktion som skriver ut nonbreaking spaces
function nbsp($i){
	$text='&nbsp;';
	while($i>0){
		$text=$text.'&nbsp;';
		$i--;	
	}
	return $text;	
}

?>