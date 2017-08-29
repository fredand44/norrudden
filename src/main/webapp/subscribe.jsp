<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="se.norrudden.site.utils.MailUtil"%>
<%@page import="se.norrudden.site.model.Subscriber"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%!
String name = "";
String emailRegistration = "";
String emailUnregistration = "";
String submitRegistration = null;
String submitUnregistration = null;

static final Logger logger = LogManager.getLogger("subscribe.jsp");
%>
    
    
<%
     	StringBuffer errorMessage = new StringBuffer();
     	String successMessage = "";
     	
     	try
     	{
	     	submitRegistration = request.getParameter("submitRegistration");
	     	submitUnregistration = request.getParameter("submitUnregistration");
	     	
	     	if( submitRegistration != null && submitRegistration.equals("Anmäl"))
	     	{
	     		name =  request.getParameter("name") == null ? "" : request.getParameter("name");
	     		emailRegistration =  request.getParameter("emailRegistration") == null ? "" : request.getParameter("emailRegistration");
	     				
	     		errorMessage = checkForErrors();
	     		
	     		if(errorMessage.toString().equals(""))
	     		{	
			     	Subscriber subscriber = new Subscriber(name, emailRegistration);
			     	
			     	boolean sendOK = false;
			     	try
			     	{
			     		MailUtil.sendGmailNoSSL(emailRegistration, "Ett testmeddelande från Norruddens vägförening", "Hej " + name + "!\n\nDin epostadress är nu registrerad på norruddens lista över epostadresser som notifieras då det finns ny information att läsa på hemsidan." + MailUtil.ending);
			     		sendOK = true;
			     	}
			     	catch(Exception e)
			     	{
			     		sendOK = false;
			     		errorMessage.append("Epostadressen du angav fungerar inte pga: ");
			     		errorMessage.append(e.getMessage());
						try
						{
							logger.error(e);
						}
						catch(Exception e2)
						{
							logger.error(e.getMessage());
						}
			     	}
			     	
			     	if(sendOK)
			     	{
			     		HibernateUtil.save(subscriber, null, true);
			     		logger.info("Prenumerant sparad: " + emailRegistration);
			     	
			     		successMessage = "Prenumerant sparad och ett testmeddelande är sänt till:<br/>"+emailRegistration;
			     		name = "";
			     		emailRegistration = "";
			     		emailUnregistration = "";
			     	}
	     		}
	     	}
	     	else if( submitUnregistration != null && submitUnregistration.equals("Avanmäl"))
	     	{
	     		emailUnregistration =  request.getParameter("emailUnregistration") == null ? "" : request.getParameter("emailUnregistration");
	     				
	     		errorMessage = checkForErrors();
	     		
	     		if(errorMessage.toString().equals(""))
	     		{			     	
			     	String[] parameterNames = {"email"};
			     	Object[] parameterValues = {emailUnregistration};
			     	String queryString = "SELECT s FROM Subscriber s WHERE s.email = :email";
			     	java.util.List<Object> subscribers = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
			     	if( subscribers != null && subscribers.size() == 1 )
			     	{
			     		HibernateUtil.delete(subscribers.get(0), true);
			     		logger.info("Prenumerant borttagen: " + emailUnregistration);
			     		successMessage = "Epostadressen: " + emailUnregistration + " är nu avanmäld!";
			     	}
			     	else
			     	{
			     		errorMessage.append( "Epostadressen: " );
			     		errorMessage.append( emailUnregistration );
			     		errorMessage.append( " finns inte!" );
			     	}
			     	
			     	name = "";
			     	emailUnregistration = "";
			    }
	     	}
	     	else
	     	{
	     		name = "";
	     		emailRegistration = "";
	     		emailUnregistration = "";		
	     	}
     	}
     	catch(Exception e)
     	{
     		name = "";
     		emailRegistration = "";
     		emailUnregistration = "";
     		submitRegistration = null;
     		submitUnregistration = null;
     		
    		request.setAttribute("error", e);
    		pageContext.forward("error.jsp");
     	}
%>

<%!
	private StringBuffer checkForErrors()
	{
		StringBuffer stringBuffer = new StringBuffer();
		
		if( submitRegistration != null )
		{
			if( name == null || name.trim().equals("") )
			{
				stringBuffer.append("Namn måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( name != null && name.trim().length() > 128 )
			{
				stringBuffer.append("Namn får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(name.trim().length());
				return stringBuffer;
			}
			
			if( emailRegistration == null || emailRegistration.trim().equals("") )
			{
				stringBuffer.append("Epostadress måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( emailRegistration != null && emailRegistration.trim().length() > 128 )
			{
				stringBuffer.append("Epostadress får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(emailRegistration.trim().length());
				return stringBuffer;
			}
			else
			{
				String[] parameterNames = {"email"};
				Object[] parameterValues = {emailRegistration};
				String queryString = "SELECT s FROM Subscriber s WHERE s.email = :email";
				java.util.List<Object> subscribers = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
				if( subscribers.size() > 0 )
				{
					stringBuffer.append("Epostadressen finns redan anmäld.");
					return stringBuffer;
				}
			}	
		}
		
		if( submitUnregistration != null )
		{
			if( emailUnregistration == null || emailUnregistration.trim().equals("") )
			{
				stringBuffer.append("Epostadress måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( emailUnregistration != null && emailUnregistration.trim().length() > 128 )
			{
				stringBuffer.append("Epostadress får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(emailUnregistration.trim().length());
				return stringBuffer;
			}				
		}
		
		return stringBuffer;	
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<script type="text/javascript" src="js/norrudden.js"></script>
	<link rel="stylesheet" href="css/norrudden.css" type="text/css" media="screen" />
	<title>Norruddens vägfÃ¶rening - kontakt</title>
</head>
<body>
	<table>
		<tr>
			<td colspan="2" class="font_verdana_12_black">
				<font color="red"><b><%=errorMessage.toString() %></b></font>
			</td>
		</tr>
		<tr>
			<td valign="top" align="left">
				<form action="subscribe.jsp" method="post" id="registration" name="registration" >
					<table class="rounded_gray_small_box">
						<tr>
							<td colspan="2" align="left">
								<img style="border: 0;" src="images/register.png" alt="Anmäl epost" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Här kan du registrera din epostadress, så får du notifieringar om viktiga meddelanden från styrelsen.
								<br/>
								(Om du inte vill ha email så kan du även prenumerar på notifieringar via RSS med en RSS-klient)
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black" align="right">
								Namn:
							</td>
							<td align="left">
								<input type="text" name="name" value="<%=name%>" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black" align="right">
								Epostadress:
							</td>
							<td align="left">
								<input type="text" name="emailRegistration" value="<%=emailRegistration%>" />
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td align="left">
								<input type="submit" name="submitRegistration" id="submitRegistration" value="Anmäl"/>
							</td>
						</tr>		
					</table>
				</form>
			</td>
		</tr>
		<tr>
			<td valign="top" align="left">
				<form action="subscribe.jsp" method="post" id="unregistration" name="unregistration" >
					<table class="rounded_gray_small_box">
						<tr>
							<td colspan="2" align="left">
								<img style="border: 0;" src="images/unregister.png" alt="Avanmäl epost" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Här kan du avregistrera din epostadress, så du <b>inte</b> får notifieringar om viktiga meddelanden från styrelsen.
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black" align="right">
								Epostadress:
							</td>
							<td align="left">
								<input type="text" name="emailUnregistration" value="<%=emailUnregistration%>" />
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td align="left">
								<input type="submit" name="submitUnregistration" id="submitUnregistration" value="Avanmäl"/>
							</td>
						</tr>		
					</table>
				</form>
			</td>
		</tr>
		<tr>
			<td class="font_verdana_12_black">
				Status: <font color="green"><b><%=successMessage%></b></font>
			</td>
		</tr>
	</table>
		
</body>
</html>
<%
	name = "";
	emailRegistration = "";
	emailUnregistration = "";
	submitRegistration = null;
	submitUnregistration = null;
%>