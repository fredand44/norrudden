<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="java.util.List"%>
<%@page import="se.norrudden.site.model.ContactMessage"%>
<%@page import="se.norrudden.site.model.SystemParameter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TimeZone"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%
String messageList = ""; 
try
{
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));
	
	String passwordMessageList = request.getParameter("passwordMessageList");
	
	String PASSWORD = HibernateUtil.getSystemParameter( SystemParameter.PASSWORD );
	
	if( PASSWORD.equals(passwordMessageList) )
	{
		String queryString = "SELECT c FROM ContactMessage c ORDER BY c.pubDate DESC";
		String[] parameterNames = {};
		Object[] parameterValues = {};
		List<Object> contactMessages = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
		
		StringBuffer stringBuffer = new StringBuffer( "<table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\">");
		stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
		stringBuffer.append( "<td colspan=\"2\" valign=\"top\" class=\"font_verdana_12_black\">");
		stringBuffer.append( "Obs! Det kan finnas fler meddelande på epostkontot som inte listas här.<br/>Här listas bara de meddelanden som postas via kontaktformuläret fån sidan &quot;Kontakt&quot;.<br/><br/>" );
		stringBuffer.append( "</td>" );
		stringBuffer.append( "</tr>" );
		
		if( contactMessages.size() > 0 )
		{
			for(int i = 0; i < contactMessages.size(); i++)
			{
				ContactMessage contactMessage = (ContactMessage)contactMessages.get(i);			
				stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
				stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
				stringBuffer.append( "<img style=\"border: 0;\" src=\"images/date.png\" alt=\"Datum\" />" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
				stringBuffer.append( sdf.format( contactMessage.getPubDate() ) );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
				
				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
				stringBuffer.append( "<img style=\"border: 0;\" src=\"images/sender.png\" alt=\"Avsändare\" />" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
				stringBuffer.append( contactMessage.getSender() );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
				

				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
				stringBuffer.append( "<img style=\"border: 0;\" src=\"images/email.png\" alt=\"Epost\" />" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
				stringBuffer.append( contactMessage.getEmail() );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
				
				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
				stringBuffer.append( "<img style=\"border: 0;\" src=\"images/telefon.png\" alt=\"Telefon\" />" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
				stringBuffer.append( contactMessage.getTelephone() );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
				
				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
				stringBuffer.append( "<img style=\"border: 0;\" src=\"images/memo.png\" alt=\"Meddelande\" />" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
				stringBuffer.append( contactMessage.getMessage() );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
				
				if( i < contactMessages.size()-1 )
				{
					stringBuffer.append( "<tr>" );
					stringBuffer.append( "<td colspan=\"2\">");
					stringBuffer.append( "<hr/>" );
					stringBuffer.append( "</td>" );
					stringBuffer.append( "</tr>" );
				}
			}
		}
		else
		{
			stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
			stringBuffer.append( "<td valign=\"top\">");
			stringBuffer.append( "<img style=\"border: 0;\" src=\"images/no_messages.png\" alt=\"Inga meddelande\" />");
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
		}
		stringBuffer.append( "</table>" );
		
		messageList = stringBuffer.toString();
		
	}
	else
	{
		messageList = "Felaktigt lösenord!";
	}
}
catch(Exception e)
{
	request.setAttribute("error", e);
	pageContext.forward("error.jsp");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
		<script type="text/javascript" src="js/norrudden.js"></script>
		<link rel="stylesheet" href="css/norrudden.css" type="text/css" media="screen" />
		<title>Norruddens vägförening - lista över meddelanden från medlemmar</title>
	</head>
	<body>
		<%=messageList%>
	</body>
</html>