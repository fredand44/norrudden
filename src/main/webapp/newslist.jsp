<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="java.util.List"%>
<%@page import="se.norrudden.site.model.FeedMessage"%>
<%@page import="se.norrudden.site.model.Feed"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TimeZone"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));

String message = ""; 

//create the rss feed
try
{
	String queryString = "SELECT f FROM FeedMessage f ORDER BY f.pubDate DESC";
	String[] parameterNames = {};
	Object[] parameterValues = {};
	List<Object> feedMessages = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
	
	//Only take older feeds, not latest.
	if( feedMessages.size() > 0)
	{
		feedMessages.remove(0);
	}
	
	StringBuffer stringBuffer = new StringBuffer( "<table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\">");

	if( feedMessages.size() > 0 )
	{
		for(int i = 0; i < feedMessages.size(); i++)
		{
			FeedMessage feedMessage = (FeedMessage)feedMessages.get(i);
			stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
			stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
			stringBuffer.append( "<img style=\"border: 0;\" src=\"images/date.png\" alt=\"Datum\" />" );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
			stringBuffer.append( sdf.format( feedMessage.getPubDate() ) );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			stringBuffer.append( "<tr>" );
			stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
			stringBuffer.append( "<img style=\"border: 0;\" src=\"images/title.png\" alt=\"Titel\" />" );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
			stringBuffer.append( feedMessage.getTitle() );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			stringBuffer.append( "<tr>" );
			stringBuffer.append( "<td width=\"20%\" valign=\"top\">");
			stringBuffer.append( "<img style=\"border: 0;\" src=\"images/memo.png\" alt=\"Meddelande\" />" );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" width=\"80%\" valign=\"top\">");
			stringBuffer.append( feedMessage.getDescription() );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			
			if( i < feedMessages.size()-1 )
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
		stringBuffer.append( "<img style=\"border: 0;\" src=\"images/no_old_messages.png\" alt=\"Inga gamla meddelanden\" />");
		stringBuffer.append( "</td>" );
		stringBuffer.append( "</tr>" );
	}
	stringBuffer.append( "</table>" );
	
	message = stringBuffer.toString();
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
		<title>Norruddens vägförening - lista över äldre meddelanden</title>
	</head>		
	<body>
		<%=message%>
	</body>
</html>