<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="java.util.List"%>
<%@page import="se.norrudden.site.model.Thumb"%>
<%@page import="se.norrudden.site.model.Image"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TimeZone"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));

String message = ""; 

try
{
	String queryString = "SELECT t FROM Thumb t ORDER BY t.pubDate DESC";
	String[] parameterNames = {};
	Object[] parameterValues = {};
	List<Object> thumbs = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
	
	StringBuffer stringBuffer = new StringBuffer( "<table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\">");
	
	if( thumbs.size() > 0 )
	{
		for(int i = 0; i < thumbs.size(); i++)
		{
			Thumb thumb = (Thumb)thumbs.get(i);
			stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
			stringBuffer.append( "<td class=\"font_verdana_12_black\" >");
			stringBuffer.append( sdf.format( thumb.getPubDate() ) );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			stringBuffer.append( "<tr>" );
			stringBuffer.append( "<td>");
			stringBuffer.append( "<a href=\"/imageservlet?imageid=");
			stringBuffer.append( thumb.getId().intValue() );
			stringBuffer.append( "\" target=\"_blank\"><img style=\"border: 0;\" src=\"/thumbservlet?thumbid=");
			stringBuffer.append( thumb.getId().intValue() );
			stringBuffer.append( "\" alt=\"");
			stringBuffer.append( thumb.getDescription() );
			stringBuffer.append( "\" title=\"");
			stringBuffer.append( thumb.getDescription() );			
			stringBuffer.append( "\" /></a>" );
			stringBuffer.append( "</td>" );
			stringBuffer.append( "</tr>" );
			
			if( i < thumbs.size()-1 )
			{
				stringBuffer.append( "<tr>" );
				stringBuffer.append( "<td>");
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
		stringBuffer.append( "<img style=\"border: 0;\" src=\"images/no_images.png\" alt=\"Inga bilder är uppladdade\" />");
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
		<title>Norruddens vägförening - lista över bilder</title>
	</head>
	<body>
		<%=message%>
	</body>
</html>