<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="se.norrudden.site.model.FeedMessage"%>
<%@page import="se.norrudden.site.model.Feed"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TimeZone"%>


    
<%

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));

String message = ""; 

try
{
	String[] parameterNames = {};
	Object[] parameterValues = {};
	String queryString = "SELECT f FROM Feed f WHERE f.id IN (SELECT MAX(f2.id) FROM Feed f2)";
	java.util.List<Object> feedList = se.norrudden.site.hibernate.HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
	
	ArrayList<FeedMessage> feedMessages = new ArrayList<FeedMessage>();
	for(int i = 0; i < feedList.size(); i++)
	{
		Feed feed = (Feed)feedList.get(i);
		if( feed.getFeedMessages() != null )
		{
			for(int j = 0; j < feed.getFeedMessages().size(); j++)
			{
				feedMessages.add( feed.getFeedMessages().get(i) );
			}
		}
	}
	
	StringBuffer stringBuffer = new StringBuffer( "<table class=\"table_senaste_nytt\">");
	

	if( feedMessages.size() > 0 )
	{
		for(int i = 0; i < feedMessages.size(); i++)
		{
			FeedMessage feedMessage = feedMessages.get(i);
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
		}
	}
	else
	{
		stringBuffer.append( "<tr align=\"left\" valign=\"middle\">" );
		stringBuffer.append( "<td valign=\"top\">");
		stringBuffer.append( "<img style=\"border: 0;\" src=\"images/no_messages.png\" alt=\"Inga meddelande\">");
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
<%@ include file="header.jsp" %>
						<tr>
							<td>
								<table>
									<tr>
										<td >
											<img style="border: 0;" src="images/latest_news.png" alt="Senaste nytt" title="Senaste nytt" />
										</td>										
									</tr>
									<tr>
										<td align="left" >
											<%=message%>
										</td>										
									</tr>
								</table>					
							</td>
						</tr>
						<tr>
							<td>
								<table>
									<tr>
										<td width="80%">
											<img style="border: 0;" src="images/old_messages.png" alt="Äldre meddelanden" />
										</td>
										<td width="20%" align="right">
											<img style="border: 0;" src="images/images.png" alt="Bilder" />
										</td>										
									</tr>
									<tr>
										<td align="center" width="80%">
											<iframe width="560" height="300" scrolling="auto" frameborder="1" src="newslist.jsp">
											  <p>Your browser does not support iframes.</p>
											</iframe>
										</td>
										<td align="center" width="20%">
											<iframe width="200" height="300" scrolling="auto" frameborder="1" src="imagelist.jsp">
											  <p>Your browser does not support iframes.</p>
											</iframe>
										</td>										
									</tr>
								</table>					
							</td>						
						</tr>
					</table>
				</td>
			</tr>
<%@ include file="footer.jsp" %>
		</table>
	</body>
</html>
