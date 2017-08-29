<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="se.norrudden.site.model.SystemParameter"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>

<%!
	static final Logger logger = LogManager.getLogger("error.jsp");
%>

<%
	String EPOST = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_ADDRESS );
	Exception error = request.getAttribute("error") == null ? new Exception("Felet uppstod på servern!") : (Exception)request.getAttribute("error");
	
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
		<title>Norruddens vägförening - lista över äldre meddelanden</title>
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
					<br/>
					Har du möjlighet får du gärna rapportera detta fel till styrelsen på epost:
					<br/>
					<br/>
					<%=EPOST%>			
				</td>						
			</tr>
		</table>
	</body>
</html>

