<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=latin1" />
    <title>SkeppInsert (php) | PUCKO</title>
    <link href="layout/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<?php $pdo = new PDO('mysql:dbname=a11emmjo;host=localhost;charset=latin1', 'dbsk', 'Tomten2009'); //Sparar db-länken i variabeln pdo. ?>
    <?php include("funktioner.php"); //Importerar det dokument som innehåller mina funktioner. ?>
    <?php $pdo->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING ); ?>
    
    <div id="wrapper">
        <div id="header">
        	<img src="layout/pucko.jpg" alt="P.U.C.K.O" class="center"/>
        </div>
        <div id="menu">
            <button onclick="location.href='dotnet.aspx'">ASP .NET</button>
            <button onclick="location.href='aliensearch.php'">PHP: S&ouml;k efter alien</button>
            <button onclick="location.href='rasupdate.php'">PHP: Hemligst&auml;mpla ras</button>
            <button onclick="location.href='skeppinsert.php'">PHP: Mata in nytt skepp</button>
        </div>
        <div id="content">
            <h1>Mata in nytt skepp</h1>
            
            <form action="skeppinsert.php" method="post">
                <table border="0">
                    <tr>
                        <td>
                            Skeppets ID: 
                        </td>
                        <td>
                            <input size="25" type="text" value="4 siffror" name="id"
                                onblur="if (this.value == '') {this.value = '4 siffror';}" 
                                onfocus="if (this.value == '4 siffror') {this.value = '';}" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Antal sittplatser: 
                        </td>
                        <td>
                            <input size="25" type="text" value="1-5000" name="sittplatser"
                                onblur="if (this.value == '') {this.value = '1-5000';}" 
                                onfocus="if (this.value == '1-5000') {this.value = '';}" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Tillverkningsplanet: 
                        </td>
                        <td>
                            <?php
                                
                                echo '<select size="1" name="tillverkningsplanet">';
                                echo '<option value="" selected="selected">Välj en planet'.nbsp(20).'</option>';
                                foreach($pdo->query( 'SELECT namn FROM planet ORDER BY namn;' ) as $row){
                                    echo '<option value="'.$row['namn'].'">';
                                    echo $row['namn'];			
                                    echo '</option>';
                                }
                                echo '</select>';
                                
                            ?>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            Kännetecken:<br />
                            (Håll in Ctrl för att markera<br />flera alternativ samtidigt)
                        </td>
                        <td>
                            <?php												// Denna behöver en ny tabell i databsaen!!!
                            
                                    echo '<select size="4" multiple="multiple" name="signs">';
                                    foreach($pdo->query( 'SELECT tecken FROM skeppKannetecken ORDER BY tecken;' ) as $row){
                                        echo '<option value="'.$row['tecken'].'">';
                                        echo $row['tecken'];			
                                        echo '</option>';
                                    }
                                    echo '</select>';
                            ?>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="submit" value="Infoga"/>
                        </td>
                    </tr>
                </table>
            </form>
            
            <?php
                if(isset($_POST['id'])){
                    $id=$_POST['id'];
                    if(ctype_digit ($id) and strlen($id)==4){ //Om inmatning på skeppsid består av 4 siffror går man vidare.
                    
                        if($_POST['sittplatser']=='1-5000'){ //Om antal sittplatser ej är ifyllt sätts variabeln till defaultl, dvs. 1...
                            $sittplatser='1';
                        }
                        else if($_POST['sittplatser']>=1 || $_POST['sittplatser']>=5000){
                            $sittplatser=$_POST['sittplatser']; //...om ett inmatat värde är tillåtet sätts variabeln till det...
                        }
                        else{ //...i annat fall skrivs ett felmeddelande ut.
                            echo '<br />Antal sittplatser i ett skepp kan vara som mest 5000. Försök igen.';
                        }
                        
                        if(!empty($_POST['tillverkningsplanet'])){
                            $planet=$_POST['tillverkningsplanet'];
                            foreach($pdo->query( "SELECT nr FROM planet WHERE namn='$planet';" ) as $row){ //Sedan plockas nr för det namnet fram.
                                $planetnr=$row['nr'];
                            }
                            
                            $querystring='INSERT INTO skepp(skeppID,sittPlatser,tillverkningsPlanet) VALUES(:SKEPPID,:SITTPLATSER,:PLANET);';
        
                            $stmt = $pdo->prepare($querystring);
                            $stmt->bindParam(':SKEPPID', $id);
                            $stmt->bindParam(':SITTPLATSER', $sittplatser);
                            $stmt->bindParam(':PLANET', $planetnr);
                            $stmt->execute();
                                    
                            echo '<br /><p>Följande information har registrerats i databasen:</p>';
                            echo '<table border="1">';
                            echo '<tr><th>SkeppsID</th><th>Antal sittplatser</th><th>Tillverkningsplanet</th></tr>';
                            
                            foreach($pdo->query( "SELECT * FROM skepp WHERE skeppID='$id';" ) as $row){
                                echo '<tr>';
                                echo '<td>'.$row['skeppID'].'</td>';
                                echo '<td>'.$row['sittPlatser'].'</td>';
                                $p=$row['tillverkningsPlanet'];
                                echo '<td>';
                                foreach($pdo->query( "SELECT namn FROM planet WHERE nr='$p';" ) as $row){
                                    echo $row['namn'];
                                }
                                echo '</td>';
                                echo '</tr>';
                            }
                            
                            echo '</table>';
                            // debug($_POST);
                            
                        }
                        else{
                            echo '<p>Du måste välja en tillverkningsplanet. Försök igen.</p>';
                        }
                    }
                    else{
                        echo '<p>Skeppets ID måste bestå av 4 siffror. Försök igen.</p>';	
                    }
                    
                }
            ?>
    	</div>
    </div>
</body>
</html>