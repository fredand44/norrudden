<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="se.norrudden.site.model.SystemParameter"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.io.StringWriter"%>
<%@page import="java.io.PrintWriter"%>

<%!
	static final Logger logger = LogManager.getLogger("error.jsp");
%>

<%
	String EPOST = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_ADDRESS );
	Throwable error = request.getAttribute("error") == null ? new Exception("Felet uppstod p� servern!") : (Throwable)request.getAttribute("error");
	

	StringWriter sw = new StringWriter();
	PrintWriter pw = new PrintWriter(sw);
	error.printStackTrace(pw);
	String sStackTrace = sw.toString (); 
	
	
	try
	{
		logger.error(error.getMessage(), error);
	}
	catch(Exception e2)
	{
		logger.error(error.getMessage());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
		<script type="text/javascript" src="js/norrudden.js"></script>
		<link rel="stylesheet" href="css/norrudden.css" type="text/css" media="screen" />
		<title>Norruddens v�gf�rening - lista �ver �ldre meddelanden</title>
	</head>		
	<body>
		<table>
			<tr>
				<td class="font_verdana_12_black" valign="top">
					<b>Ett fel uppstod!</b>
					<br/>
					<br/>
					Fel:  
					<br/>
					<%=error%>
					<br/>
					<textarea rows="20" cols="100"><%=sStackTrace %></textarea>
					<br/>
					<br/>
					Har du m�jlighet f�r du g�rna rapportera detta fel till styrelsen p� epost:
					<br/>
					<br/>
					<%=EPOST%>			
				</td>						
			</tr>
		</table>
	</body>
</html>

