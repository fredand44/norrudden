<%@page import="se.norrudden.site.utils.MailUtil"%>
<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="se.norrudden.site.model.ContactMessage"%>
<%@page import="se.norrudden.site.model.SystemParameter"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%!
String sender = null;
String email = "";
String telephone = "";
String message = null;
String submitMeddelande = null;

static final Logger logger = LogManager.getLogger("contact.jsp");
%>
    
<%
	StringBuffer errorMessage = new StringBuffer();
	String successMessage = "";
	
	try
	{
		submitMeddelande = request.getParameter("submitMeddelande");
		if( submitMeddelande != null)
		{
			sender =  request.getParameter("sender") == null ? "" : request.getParameter("sender");
			email =  request.getParameter("email") == null ? "" : request.getParameter("email");
			telephone =  request.getParameter("telephone") == null ? "" : request.getParameter("telephone");
			message =  request.getParameter("message") == null ? "" : request.getParameter("message");
			
			//successMessage = "Knapp tryckt!";
					
			errorMessage = checkForErrors();
			
			if(errorMessage.toString().equals(""))
			{	
				Timestamp pubdate = new Timestamp( System.currentTimeMillis());
				ContactMessage contactMessage = new ContactMessage(sender, email, telephone, message, pubdate);
				HibernateUtil.save(contactMessage, null, true);	
				
				logger.info("Nytt contactmessage sparat med id: " + contactMessage.getId());
				
				StringBuffer stringBuffer = new StringBuffer("Avsändare: ");
				stringBuffer.append( sender );
				stringBuffer.append( "\nEmail: " );
				stringBuffer.append( email );
				stringBuffer.append( "\nTelefon: " );
				stringBuffer.append( telephone );
				stringBuffer.append( "\nMeddelande:\n" );
				stringBuffer.append( message );
				
				String to =  HibernateUtil.getSystemParameter( SystemParameter.EMAIL_ADDRESS ) ;
				//MailUtil.sendGmailNoSSL(to, "Meddelande från hemsidan", stringBuffer.toString());
			
				sender = "";
				email = "";
				telephone = "";
				message = "";
				successMessage = "Meddelande sparat samt skickat till: " + to ;
			}
		}
		else
		{
			sender = "";
			email = "";
			telephone = "";
			message = "";
			
			//successMessage = "Knapp inte tryckt!";
		}
	}
	catch(Exception e)
	{
		sender = null;
		email = "";
		telephone = "";
		message = null;
		submitMeddelande = null;
		
		request.setAttribute("error", e);
		pageContext.forward("error.jsp");
	}
	catch(Error e)
	{
		sender = null;
		email = "";
		telephone = "";
		message = null;
		submitMeddelande = null;
		
		request.setAttribute("error", e);
		pageContext.forward("error.jsp");
	}	
%>

<%!
	private StringBuffer checkForErrors()
	{
		StringBuffer stringBuffer = new StringBuffer();
		
		if( submitMeddelande != null )
		{
			if( sender == null || sender.trim().equals("") )
			{
				stringBuffer.append("Avsändare måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( sender != null && sender.trim().length() > 128 )
			{
				stringBuffer.append("Avsändare får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(sender.trim().length());
				return stringBuffer;
			}
			
			if( email == null || email.trim().equals("") )
			{
				stringBuffer.append("Epostadress måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( email != null && email.trim().length() > 128 )
			{
				stringBuffer.append("Epostadress får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(email.trim().length());
				return stringBuffer;
			}
			
			if( telephone == null || telephone.trim().equals("") )
			{
				stringBuffer.append("Telefon måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( telephone != null && telephone.trim().length() > 128 )
			{
				stringBuffer.append("Telefon får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(telephone.trim().length());
				return stringBuffer;
			}
			
			if( message == null || message.trim().equals("") )
			{
				stringBuffer.append("Meddelande måste vara ifylld, men max vara 1024 tecken lång.");
				return stringBuffer;
			}
			
			if( message != null && message.trim().length() > 1024 )
			{
				stringBuffer.append("Meddelande får vara max vara 1024 tecken lång. Din är: ");
				stringBuffer.append(message.trim().length());
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
	<title>Norruddens vägförening - kontakt</title>
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
				<form action="contact.jsp" method="post" id="kontakt" name="kontakt" >
					<table class="rounded_gray_small_box">
						<tr>
							<td colspan="2">
								<img alt="Meddelanden" src="images/memo_to_the_board.png" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Meddelanden till styrelsen kommer styrelsen läsa i mån av tid.
								<br/>
								Målet är att minst gå igenom dem vid varje styrelselemöte.
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Avsändare:
							</td>
							<td>
								<input type="text" name="sender" value="<%=sender%>" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Epostadress:
							</td>
							<td>
								<input type="text" name="email" value="<%=email%>" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Telefon:
							</td>
							<td>
								<input type="text" name="telephone" value="<%=telephone%>" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black" valign="top">
								Meddelande:
							</td>
							<td>
								<textarea rows="5" cols="40" name="message"><%=message%></textarea>
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td>
								<input type="submit" name="submitMeddelande" id="submitMeddelande" value="Skicka meddelande"/>
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
		<tr>
			<td>
				<table class="rounded_gray_small_box">
					<tr>
						<td colspan="2" align="left"><img alt="Meddelanden"
							src="images/board.png" /></td>
					</tr>
					<tr>
						<td>
							<table>

								<tr>
									<td class="font_verdana_12_black" align="right">
										<b>Ordförande</b>
									</td>
									<td class="font_verdana_12_black" align="left">
										Leif Moqvist
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="right">
										<b>Kassör</b>
									</td>
									<td class="font_verdana_12_black" align="left">
										Katarina Johansson
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" >
							<hr/>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="right">
										<b>Sekreterare</b>
									</td>
									<td class="font_verdana_12_black" align="left">Camilla Fagerlind
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="right">
										<b>Vattenman/ledamot</b></td>
									<td class="font_verdana_12_black" align="left">Leif
										Strömberg</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" >
							<hr/>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="right">
										<b>Vattenman/ledamot</b></td>
									<td class="font_verdana_12_black" align="left">Jonas Bernhardsson</td>
								</tr>
							</table>
						</td>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="left"><b>Suppleant</b></td>
									<td class="font_verdana_12_black" align="left">Kenneth
										Ademyr</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" >
							<hr/>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td class="font_verdana_12_black" align="left"><b>Suppleant</b></td>
									<td class="font_verdana_12_black" align="left">Oscar
										Maklin</td>
								</tr>
							</table>
						</td>
						<td>
							
						</td>
					</tr>								
				</table>
			</td>
		</tr>
	</table>
		
</body>
</html>
<%
	sender = null;
	email = "";
	telephone = "";
	message = null;
	submitMeddelande = null;
%>