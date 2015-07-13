<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=latin1" />
    <title>AlienS�k (php) | PUCKO</title>
    <link href="layout/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<?php $pdo = new PDO('mysql:dbname=a11emmjo;host=localhost;charset=latin1', 'dbsk', 'Tomten2009'); //Sparar db-l�nken i variabeln pdo. ?>
    <?php include("funktioner.php"); //Importerar det dokument som inneh�ller mina funktioner. ?>
    
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
            <h1>S�k efter Alien</h1>
            <p>Mata in idnr(12 siffror), pnr(10 siffror) eller v�lj ett eller flera k�nnetecken att s�ka p�:</p>
            <form action="aliensearch.php" method="post">
                <table border="0">
                    <tr>
                        <td>
                            <input size="25" type="text" value="Skriv in idnr eller pnr h�r" name="nr"
                             onblur="if (this.value == '') {this.value = 'Skriv in idnr eller pnr h�r';}" 
                             onfocus="if (this.value == 'Skriv in idnr eller pnr h�r') {this.value = '';}" />
                             <?php
                                $i=1;
                                do{ // Skickar en fr�ga till databasen och sparar alternativen i en optionbox
                                    echo '&nbsp;<select size="1" name="sign'.$i++.'">';
                                    echo '<option value="" selected="selected">V�lj ett k�nnetecken</option>';
                                    foreach($pdo->query( 'SELECT tecken FROM alienKannetecken ORDER BY tecken;' ) as $row){
                                        echo '<option value="'.$row['tecken'].'">';
                                        echo $row['tecken'];			
                                        echo '</option>';
                                    }
                                    echo '</select>';
                                }while($i<=3)
                            ?>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="centered">
                            <input type="submit" value="S�k" />
                        </td>
                    </tr>
                </table>
            </form>
            
            <?php
                if(isset($_POST['nr'])){ //Om anv�ndaren matat in ngt i textboxen g� vidare.
                
                    //Skapar ett antal variabler som h�ller ordning p� anv�ndarens input.
                    $nr=$_POST['nr'];
                    $sign1=$_POST['sign1'];
                    $sign2=$_POST['sign2'];
                    $sign3=$_POST['sign3'];
                
                    if(ctype_digit ($nr) and strlen($nr)==12){ //Om inmatningen best�r av enbart siffror och �r 12 tecken l�ngt.
                    
                        $idnr=implode('-',str_split($nr,6)); //Stoppar in ett bindestreck efter 6 tecken i str�ngen.
                        
                        echo '<table border="1px">';
                        foreach($pdo->query( "SELECT * FROM alltOmEnAlien WHERE idKod='$idnr';" ) as $row){
                            echo '<tr><th>ID:</th>';
							echo '<td>'.$row['alienID'].'</td>';
							echo '</tr><tr><th>ID-kod:</th>';
                            echo '<td>'.$row['idKod'].'</td>';
							echo '</tr><tr><th>P-nr:</th>';
                            echo '<td>'.$row['pNr'].'</td>';
							echo '</tr><tr><th>Namn:</th>';
							echo '<td>'.$row['namn'].'</td>';
							echo '</tr><tr><th>Ras:</th>';
                            echo '<td>'.$row['Ras'].'</td>';
							echo '</tr><tr><th>K�nnetecken:</th>';
                            echo '<td>'.$row['tecken'].'</td>';
							echo '</tr><tr><th>Ursprungsplanet:</th>';
                            echo '<td>'.$row['Planet'].'</td>';
							echo '</tr><tr><th>Risk:</th>';
                            echo '<td>'.$row['typ'].'</td>';
                            echo '</tr>';
                        }
                        echo '<table>';
                    }
                    else if(ctype_digit ($nr) and strlen($nr)==10){ //Om inmatningen best�r av enbart siffror och �r 10 tecken l�ngt.
                    
                        $pnr=implode('-',str_split($nr,6)); //Stoppar in ett bindestreck efter 6 tecken i str�ngen.
                        
                        echo '<table border="1">';
                        foreach($pdo->query( "SELECT * FROM alltOmEnAlien WHERE pNr='$pnr';" ) as $row){
                            echo '<tr>';
                            echo '<td>'.$row['namn'].'</td>';
                            echo '<td>'.$row['alienID'].'</td>';
                            echo '<td>'.$row['idKod'].'</td>';
                            echo '<td>'.$row['pNr'].'</td>';
                            echo '<td>'.$row['Ras'].'</td>';
                            echo '<td>'.$row['tecken'].'</td>';
                            echo '<td>'.$row['Planet'].'</td>';
                            echo '<td>'.$row['typ'].'</td>';
                            echo '</tr>';
                        }
                        echo '<table>';
                    }
                    else{
                        echo '<p>Idnr eller pnr �r inte korrekt! Ett idnr best�r av enbart 12 siffror medans ett pnr best�r av enbart 10 siffror.</p>';
                    }
                }
            ?>
		</div>
    </div>
</body>
</html>