using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Start : System.Web.UI.Page{
		
		//En funktion som gör det möjligt att refresha sidan.
		protected void RefreshCode(Object sender, EventArgs e){
			HttpRuntime.UnloadAppDomain();
		}
}

