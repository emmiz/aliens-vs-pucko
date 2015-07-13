<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=latin1" />
    <title>RasUpdate (php) | PUCKO</title>
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
            <h1>V�lj ras att hemligst�mpla</h1>
            <form method="post">
                <?php
                    echo '<select size="1" name="ras">';
                    echo '<option value="" selected="selected">V�lj en ras</option>';
                    foreach($pdo->query( 'SELECT namn FROM ras;' ) as $row){
                        
                        if($row['namn']!='Hemligst�mplad'){ //S�kerst�ller att man inte kan ta bort rasen Hemligst�mplad.
                            echo '<option value="'.$row['namn'].'">';
                            echo $row['namn'];			
                            echo '</option>';
                        }
                    }
                    echo '</select>';
                ?>
                <input type="submit" value="Hemligst�mpla" />
            </form>
            
            <?php
            
                if(isset($_POST['ras'])){ //Om anv�ndaren valt en ras att hemligst�mpla
                    $namn=$_POST['ras']; //Sparas rasnamnet i variabeln $namn
                    foreach($pdo->query( "SELECT nr FROM ras WHERE namn='$namn';" ) as $row){ //Sedan plockas kodnr f�r namnet fram o sparas i $nr.
                        $nr=$row['nr'];
                    }
                    $pdo->query( "CALL hemligstamplaRas('$nr');" ); //Tillsist k�rs proceduren hemligstamplaRas p� det kodnr som tagits fram.
                    reload();
                    // P� ngt s�tt borde en bekr�ftelse skrivas ut s�h�r: echo $namn.' har hemligst�mplats i databasen!';			
                }
                //debug($_POST);
            ?>
		</div>
    </div>
</body>
</html>