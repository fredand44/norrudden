<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="java.util.List"%>
<%@page import="se.norrudden.site.model.Document"%>
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
	String queryString = "SELECT d FROM Document d ORDER BY d.pubDate DESC";
	String sortType = request.getParameter("sorttype") == null ? "5" : request.getParameter("sorttype");
	if("1".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.name DESC";
	}
	else if("2".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.name ASC";
	}
	else if("3".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.description DESC";
	}
	else if("4".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.description ASC";
	}
	else if("5".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.pubDate DESC";
	}
	else if("6".equals(sortType))
	{
		queryString = "SELECT d FROM Document d ORDER BY d.pubDate ASC";
	}
	else //Default
	{
		queryString = "SELECT d FROM Document d ORDER BY d.pubDate DESC";
	}
	
	String[] parameterNames = {};
	Object[] parameterValues = {};
	List<Object> documents = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
	
	StringBuffer stringBuffer = new StringBuffer( "<table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\">");
	stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
	stringBuffer.append( "<td colspan=\"2\" valign=\"top\" class=\"font_verdana_12_black\">");
	stringBuffer.append( "Här listas viktiga dokument som är uppladdade av styrelsen och som kan vara intressanta för medlemmar.<br/>För att spara utrymme så ligger filerna i zip-filer.<br/><br/>" );
	stringBuffer.append( "</td>" );
	stringBuffer.append( "</tr>" );
	if( documents.size() > 0 )
	{
		stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
		stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"left\">");
		if("1".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&uarr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=1\">&nbsp;&uarr;&nbsp;</a>" );
		}
		stringBuffer.append( "<b>Namn</b>" );
		if("2".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&darr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=2\">&nbsp;&darr;&nbsp;</a>" );
		}
		stringBuffer.append( "</td>" );
		stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"left\">");
		if("3".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&uarr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=3\">&nbsp;&uarr;&nbsp;</a>" );
		}
		stringBuffer.append( "<b>Beskrivning</b>" );
		if("4".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&darr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=4\">&nbsp;&darr;&nbsp;</a>" );
		}
		stringBuffer.append( "</td>" );
		stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"right\">");
		if("5".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&uarr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=5\">&nbsp;&uarr;&nbsp;</a>" );
		}
		stringBuffer.append( "<b>Publiceringsdatum</b>" );
		if("6".equals(sortType))
		{
			stringBuffer.append( "&nbsp;&darr;&nbsp;" );
		}
		else
		{
			stringBuffer.append( "<a href=\"/documentlist.jsp?sorttype=6\">&nbsp;&darr;&nbsp;</a>" );
		}
		stringBuffer.append( "</td>" );
		stringBuffer.append( "</tr>" );
		
		for(int i = 0; i < documents.size(); i++)
		{
			Document document = (Document)documents.get(i);			
			stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"left\">");
			stringBuffer.append( "<a href=\"/documentservlet?documentid=");
			stringBuffer.append( document.getId().intValue() );
			stringBuffer.append( "\" target=\"_blank\">");
			stringBuffer.append( document.getName() );			
			stringBuffer.append( "</a>" );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"left\">");
			stringBuffer.append( document.getDescription() == null ? "" : document.getDescription() );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" align=\"right\">");
			stringBuffer.append( sdf.format( document.getPubDate() ) );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			
			if( i < documents.size()-1 )
			{
				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td colspan=\"3\">");
				stringBuffer.append( "<hr/>" );
				stringBuffer.append( "</td>" );
				stringBuffer.append( "</tr>" );
			}
		}
	}
	else
	{
		stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
		stringBuffer.append( "<td>");
		stringBuffer.append( "<img style=\"border: 0;\" src=\"images/no_document.png\" alt=\"Inga dokument är uppladdade\" />");
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
		<title>Norruddens vägförening - lista över dokument</title>
	</head>
	<body>
		<%=message%>
	</body>
</html>