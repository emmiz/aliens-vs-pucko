<%@ Page Language="C#" ContentType="text/html" CodeFile="start.aspx.cs" Inherits="Start" AutoEventWireup="true" ResponseEncoding="iso-8859-1" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset="iso-8859-1" />
    <title>.net | PUCKO</title>
    <link href="layout/style.css" rel="stylesheet" type="text/css" />
	<script runat="server">
		//En global variabel som kan återanvändas.
		string connectionString = "Server=localhost;Database=a11emmjo;User ID=dbsk;Password=Tomten2009;Pooling=false;Character Set=latin1;";

		//En funktion som styr vad som händer när sidan laddas:
		private void Page_Load(Object sender, EventArgs e){
			welcomePanel.Visible=true;
			alienFormPanel.Visible=false;
			alienPanel.Visible=false;
			planetFormPanel.Visible=false;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=false;
			vapenPanel.Visible=false;
		}
		
		//En funktion som gör formuläret för alienraderingen synlig.
		private void alienFormFunktion(Object sender, EventArgs e){
			welcomePanel.Visible=true;
			alienFormPanel.Visible=true;
			alienPanel.Visible=false;
			planetFormPanel.Visible=false;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=false;
			vapenPanel.Visible=false;
		}
		
		//En funktion som används för att mata in en ny planet i databasen.
		private void DeleteAlien(Object sender, EventArgs e){
			MySqlConnection dbcon = new MySqlConnection(connectionString);
			
			dbcon.Open();
			
				string strInsert="CALL raderaAlien(@alienid);"; 
		
				MySqlCommand sqlCmd=new MySqlCommand(strInsert, dbcon);
		
				sqlCmd.Parameters.Add("@alienid", alienid.Text); 
		
				sqlCmd.ExecuteNonQuery();
				
				MySqlDataAdapter adapter = new MySqlDataAdapter("SELECT * FROM alltOmEnAlien", dbcon);
				DataSet ds = new DataSet();
				adapter.Fill(ds, "result");
				
				alienCustomerGrid.DataSource = ds.Tables["result"];
				alienCustomerGrid.DataBind();
	
			dbcon.Close();
				
			welcomePanel.Visible=true;
			alienFormPanel.Visible=true;
			alienPanel.Visible=true;
			planetFormPanel.Visible=false;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=false;
			vapenPanel.Visible=false;
		}
		
		//En funktion som gör formuläret för planetinserten synlig.
		private void planetFormFunktion(Object sender, EventArgs e){
			welcomePanel.Visible=true;
			alienFormPanel.Visible=false;
			alienPanel.Visible=false;
			planetFormPanel.Visible=true;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=false;
			vapenPanel.Visible=false;
		}
		
		//En funktion som används för att mata in en ny planet i databasen.
		private void InsertPlanet(Object sender, EventArgs e){
			MySqlConnection dbcon = new MySqlConnection(connectionString);
			
			dbcon.Open();
			
				string strInsert="INSERT INTO planet (namn) VALUES(@namn);"; 
		
				MySqlCommand sqlCmd=new MySqlCommand(strInsert, dbcon);
		
				sqlCmd.Parameters.Add("@namn", planetnamn.Text); 
		
				sqlCmd.ExecuteNonQuery();
				
				MySqlDataAdapter adapter = new MySqlDataAdapter("SELECT * FROM planet", dbcon);
				DataSet ds = new DataSet();
				adapter.Fill(ds, "result");
		
				planetCustomerGrid.DataSource = ds.Tables["result"];
				planetCustomerGrid.DataBind();
	
			dbcon.Close();
			
			welcomePanel.Visible=true;
			alienFormPanel.Visible=false;
			alienPanel.Visible=false;
			planetFormPanel.Visible=true;
			planetPanel.Visible=true;
			vapenFormPanel.Visible=false;
			vapenPanel.Visible=false;
		}
		
		//En funktion som gör formuläret för vapensöken synlig.
		private void vapenFormFunktion(Object sender, EventArgs e){
			welcomePanel.Visible=true;
			alienFormPanel.Visible=false;
			alienPanel.Visible=false;
			planetFormPanel.Visible=false;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=true;
			vapenPanel.Visible=false;
		}
		
		//En funktion som används för att söka efter information om ett vapen.
		private void SearchWeapon(Object sender, EventArgs e){
			MySqlConnection dbcon = new MySqlConnection(connectionString);
			
			dbcon.Open();
				
				MySqlDataAdapter adapter = new MySqlDataAdapter("SELECT * FROM alltOmEttVapen WHERE vapenID=@vapenid", dbcon);
				adapter.SelectCommand.Parameters.Add("@vapenid", vapenid.Text);
				DataSet ds = new DataSet();
				adapter.Fill(ds, "result");
		
				vapenCustomerGrid.DataSource = ds.Tables["result"];
				vapenCustomerGrid.DataBind();
	
			dbcon.Close();
			
			welcomePanel.Visible=true;
			alienFormPanel.Visible=false;
			alienPanel.Visible=false;
			planetFormPanel.Visible=false;
			planetPanel.Visible=false;
			vapenFormPanel.Visible=true;
			vapenPanel.Visible=true;
		}
	</script>
</head>
<body>
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
	<asp:Panel id="welcomePanel" runat="server">
    	<h1>V&auml;lkommen till .NET-sidan!</h1>
        <p>Vad vill du g&ouml;ra?</p>
        <form id="toDoForm" runat="server">
        	<asp:Button ID="toDoAlien" runat="server" onclick="alienFormFunktion" Text="Radera alien" />&nbsp;
        	<asp:Button ID="toDoPlanet" runat="server" onclick="planetFormFunktion" Text="Mata in ny planet" />&nbsp;
            <asp:Button ID="toDoVapen" runat="server" onclick="vapenFormFunktion" Text="S&ouml;ka efter vapen" />&nbsp;
            <asp:Button ID="RefreshButton" runat="server" onclick="RefreshCode" Text="Ladda om sidan" /><br/>
        </form>
    </asp:Panel>
    
    <asp:Panel id="alienFormPanel" runat="server">
    	<br />
    	<p>Mata in ID-nr p&aring; den alien du vill radera</p>
        <form id="alienForm" runat="server">
            ID-nr:&nbsp;<asp:TextBox ID="alienid" runat="server"/>
            <asp:Button ID="alienButton" runat="server" onclick="DeleteAlien" Text="Radera" /><br/>
    	</form>
    </asp:Panel>
    <asp:Panel id="alienPanel" runat="server">
    	<br />
    	<p>F&ouml;ljande aliens finns kvar i registret:</p>
    	<asp:DataGrid ShowHeader="true" AutoGenerateColumns="false" runat="server" id="alienCustomerGrid">
        	<Headerstyle CssClass="header"></Headerstyle>
			<Columns>	
				<asp:BoundColumn DataField="idKod" HeaderText="<div id='headfont'>Kod</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="pNr" HeaderText="<div id='headfont'>Pnr</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="namn" HeaderText="<div id='headfont'>Namn</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="Ras" HeaderText="<div id='headfont'>Ras</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="tecken" HeaderText="<div id='headfont'>K&auml;nnetecken</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="Planet" HeaderText="<div id='headfont'>Planet</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="typ" HeaderText="<div id='headfont'>Farlighet</div>" ReadOnly="True" />
            </Columns>
		</asp:DataGrid>
    </asp:Panel>
    
    
    <asp:Panel id="planetFormPanel" runat="server">
    	<br />
    	<p>Mata in ny planet</p>
    	<form id="planetForm" runat="server">
            Namn:&nbsp;<asp:TextBox ID="planetnamn" runat="server"/>
            <asp:Button ID="planetButton" runat="server" onclick="InsertPlanet" Text="Skicka" /><br/>
    	</form>
    </asp:Panel>
    <asp:Panel id="planetPanel" runat="server">
    	<br />
    	<p>F&ouml;ljande planeter finns nu i registret:</p>
		<asp:DataGrid ShowHeader="true" AutoGenerateColumns="false" runat="server" id="planetCustomerGrid">
			<Headerstyle CssClass="header"></Headerstyle>
			<Columns>
				<asp:BoundColumn DataField="nr" HeaderText="<div id='headfont'>Nr</div>" ReadOnly="True" />
				<asp:BoundColumn DataField="namn" HeaderText="<div id='headfont'>Namn</div>" ReadOnly="True" />
			</Columns>
		</asp:DataGrid>
	</asp:Panel>
    
    <asp:Panel id="vapenFormPanel" runat="server">
    	<br />
    	<p>Mata in ID-nr p&aring; det vapen du vill s&ouml;ka information om</p>
    	<form id="vapenForm" runat="server">
            ID-nr:&nbsp;<asp:TextBox ID="vapenid" runat="server"/>
            <asp:Button ID="vapenButton" runat="server" onclick="SearchWeapon" Text="S&ouml;k" /><br/>
    	</form>
    </asp:Panel>
    <asp:Panel id="vapenPanel" runat="server">
    	<br />
    	<p>Detta &auml;r all information som gick att hitta om det valda vapnet i registret:</p>
		<asp:DataGrid ShowHeader="true" AutoGenerateColumns="false" runat="server" id="vapenCustomerGrid">
			<Headerstyle CssClass="header"></Headerstyle>
			<Columns>
				<asp:BoundColumn DataField="vapenID" HeaderText="<div id='headfont'>ID</div>" ReadOnly="True" />
				<asp:BoundColumn DataField="planetnamn" HeaderText="<div id='headfont'>Produceras p&aring;</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="namn" HeaderText="<div id='headfont'>Ink&ouml;psbutik</div>" ReadOnly="True" />
                <asp:BoundColumn DataField="typ" HeaderText="<div id='headfont'>Farlighet</div>" ReadOnly="True" />
			</Columns>
		</asp:DataGrid>
	</asp:Panel>
</div>
</body>
</html>
