<%@page import="se.norrudden.site.model.SystemParameter"%>
<%@page import="se.norrudden.site.hibernate.HibernateUtil"%>
<%@page import="se.norrudden.site.utils.MailUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="se.norrudden.site.model.FeedMessage"%>
<%@page import="se.norrudden.site.model.Feed"%>
<%@page import="se.norrudden.site.model.Thumb"%>
<%@page import="se.norrudden.site.model.Image"%>
<%@page import="se.norrudden.site.model.Document"%>
<%@page import="se.norrudden.site.model.Subscriber"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.io.InputStream"%>
<%@page import="se.norrudden.site.file.FileUtil"%>
<%@page import="java.io.IOException"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%!
String passwordRss = null;
String titleRss = "";
String descriptionRss = "";
String submitMeddelande = null;

String passwordImage = null;
InputStream inputStreamImage = null;
String descriptionImage = "";
String submitBild = null;

String passwordDocument = null;
InputStream inputStreamDocument = null;
String fileNameDocument = null;
String fileDescriptionDocument = null;
String submitDokument = null;
int DOCUMENT_MAXSIZE = 0;
int IMAGE_MAXSIZE = 0;
String PASSWORD = "";

static final Logger logger = LogManager.getLogger("admin.jsp");
%>
    
<%
	
	DOCUMENT_MAXSIZE = Integer.parseInt( HibernateUtil.getSystemParameter( SystemParameter.DOCUMENT_MAXSIZE ) );
	IMAGE_MAXSIZE = Integer.parseInt( HibernateUtil.getSystemParameter( SystemParameter.IMAGE_MAXSIZE ) );
	PASSWORD = HibernateUtil.getSystemParameter( SystemParameter.PASSWORD );
	
	boolean firstTime = false;
	StringBuffer progressMessage = new StringBuffer();
	StringBuffer errorMessage = new StringBuffer();
	String successMessage = "";
	
	try
	{
		submitMeddelande = request.getParameter("submitMeddelande");
		if( submitMeddelande != null)
		{
			passwordRss =  request.getParameter("passwordRss") == null ? "" : request.getParameter("passwordRss");
			titleRss = request.getParameter("titleRss") == null ? "" : request.getParameter("titleRss");
			descriptionRss = request.getParameter("descriptionRss") == null ? "" : request.getParameter("descriptionRss");
			progressMessage.append("submitMeddelande<br>");
		}
		else 
		{
			try
			{
				HashMap<String, Object> parameters = FileUtil.readForm(request);
				progressMessage.append( "parameters: " + parameters.size() + "<br>");
				progressMessage.append( FileUtil.printMap( parameters ) );
				
				submitBild = (String)parameters.get("submitBild");
				submitDokument = (String)parameters.get("submitDokument");
				if( submitBild != null )
				{
					passwordImage = (String)parameters.get("passwordImage") == null ? "" : (String)parameters.get("passwordImage");
					descriptionImage = (String)parameters.get("descriptionImage") == null ? "" : (String)parameters.get("descriptionImage");
					inputStreamImage = (InputStream)parameters.get("fileImage");
				}
				else if( submitDokument != null )
				{
					passwordDocument = (String)parameters.get("passwordDocument") == null ? "" : (String)parameters.get("passwordDocument");
					inputStreamDocument = (InputStream)parameters.get("fileDocument");
					fileNameDocument = (String)parameters.get("filename") == null ? "" : (String)parameters.get("filename");
					fileDescriptionDocument = (String)parameters.get("filedescription") == null ? "" : (String)parameters.get("filedescription");
				}
			}
			catch(Exception e)
			{
				progressMessage.append("<br>");
				progressMessage.append(e.getMessage());
				progressMessage.append("<br>");
				firstTime = true;	
			}	
		}
		
		
		if(!firstTime)
		{
			errorMessage = checkForErrors();
			successMessage = "";
			
			if(errorMessage.toString().equals(""))
			{
				progressMessage.append("no errors<br>");
				
				if(submitMeddelande != null)
				{
					progressMessage.append("going for message<br>");
							
					Timestamp pubdate = new Timestamp( System.currentTimeMillis());	
							
					String title = "Information från Norruddens vägförening";
					String description = "Via denna kanal sänder styrelsen för föreningen ut meddelanden som berör medlemarna, t ex om något händer med vattnet.";
					String link = "http://jbossas-norrudden.rhcloud.com";		
			
					Feed feed = new Feed(title, link, description);
					HibernateUtil.save(feed, null, true);
					
					logger.info("Ny feed sparad med id: " + feed.getId());
					
					FeedMessage feedMessage = new FeedMessage();
					feedMessage.setTitle( request.getParameter("titleRss"));
					feedMessage.setDescription( request.getParameter("descriptionRss") );
					feedMessage.setGuid(""+System.currentTimeMillis());
					feedMessage.setLink("http://jbossas-norrudden.rhcloud.com");
					feedMessage.setPubDate( pubdate );
					
					feed.getFeedMessages().add(feedMessage);
					feedMessage.setFeed(feed);
					HibernateUtil.save(feedMessage, null, true);
					
					logger.info("Nytt feedmessage sparad med id: " + feedMessage.getId());
					
					String[] parameterNames = {};
					Object[] parameterValues = {};
					String queryString = "SELECT s FROM Subscriber s";
					java.util.List<Object> subscribers = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
					for(int i = 0; i < subscribers.size(); i++)
					{
						Subscriber subscriber = (Subscriber)subscribers.get(i);
						boolean sendOK = false;
						try
						{
							MailUtil.sendGmailNoSSL(subscriber.getEmail(), "Nu finns ny information från Norruddens vägförening", "Hej " + subscriber.getName() + "!\n\nNu finns ny information att läsa på hemsidan." + MailUtil.ending);
							sendOK = true;
						}
						catch(Exception e)
						{
							sendOK = false;
							errorMessage.append("<br/>Epostadressen: ");
							errorMessage.append( subscriber.getEmail() );
							errorMessage.append(" fungerar inte pga: ");
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
					}
					
					titleRss = "";
					descriptionRss = "";
					successMessage = "Meddelande sparat!";
				}
				else if(submitBild != null)
				{
					progressMessage.append("going for image<br>");
					
					try
					{
						byte[] bytes = FileUtil.read( inputStreamImage );
						
						//Resize original to 800*600
						BufferedImage bufferedImage  = FileUtil.bytesToImage(bytes);
						bufferedImage = FileUtil.resizeImage(bufferedImage);
						bytes = FileUtil.imageToBytes(bufferedImage);
						
						//Save original
						Image image = new Image();
						image.setFile( bytes );
						HibernateUtil.save(image, null, true);
						
						logger.info("Ny image sparad med id: " + image.getId());
						
						//Resize image to thumb
						bufferedImage  = FileUtil.bytesToImage(bytes);
						bufferedImage = FileUtil.resizeImageToThumb(bufferedImage);
						bytes = FileUtil.imageToBytes(bufferedImage);
						
						//Save thumb
						Thumb thumb = new Thumb();
						thumb.setId( image.getId() );
						thumb.setDescription( descriptionImage );
						Timestamp pubdate = new Timestamp( System.currentTimeMillis());
						thumb.setPubDate( pubdate );
						thumb.setImage(image);
						thumb.setFile(  bytes );
						HibernateUtil.save(thumb, null, true);
						
						logger.info("Ny thumb sparad med id: " + thumb.getId());
						
						descriptionImage = "";
						successMessage = "Bild sparad! (" + bytes.length + " bytes)";
					}
					catch(IOException ioe)
					{
						errorMessage.append( ioe.getMessage() );
					}
				}
				else if(submitDokument != null)
				{
					progressMessage.append("going for document<br>");
					try
					{
						Document document = new Document();
						byte[] bytes = FileUtil.read( inputStreamDocument );
						bytes = FileUtil.bytesToZip(bytes, fileNameDocument);
						
						document.setName( fileNameDocument );
						document.setDescription( fileDescriptionDocument );
						document.setFile( bytes );
						Timestamp pubdate = new Timestamp( System.currentTimeMillis());
						document.setPubDate(pubdate);
						HibernateUtil.save(document, null, true);
						
						logger.info("Nytt document sparat med id: " + document.getId());
						
						successMessage = "Dokument sparat! (" + bytes.length + " bytes)";
					}
					catch(IOException ioe)
					{
						errorMessage.append( ioe.getMessage() );
					}					
				}
				else
				{
					progressMessage.append("no submit selected????<br>");
				}
			}
			else
			{
				progressMessage.append("errors exists<br>");
			}
		}
		else
		{
			progressMessage.append("just display form<br>");
		}
		
		submitMeddelande = null;
		submitDokument = null;
		submitBild = null;
		
	 	//successMessage = successMessage + " " + progressMessage.toString();
	}
	catch(Exception e)
	{
		passwordRss = null;
		titleRss = "";
		descriptionRss = "";
		submitMeddelande = null;

		passwordImage = null;
		inputStreamImage = null;
		descriptionImage = "";
		submitBild = null;

		passwordDocument = null;
		inputStreamDocument = null;
		fileNameDocument = null;
		fileDescriptionDocument = null;
		submitDokument = null;
		DOCUMENT_MAXSIZE = 0;
		IMAGE_MAXSIZE = 0;
		PASSWORD = "";
		
		request.setAttribute("error", e);
		pageContext.forward("error.jsp");
	}
%>

<%!
	private StringBuffer checkForErrors()
	{
		StringBuffer stringBuffer = new StringBuffer();
		
		if(submitMeddelande != null && submitMeddelande.equals("Spara meddelande"))
		{
			if( titleRss == null || titleRss.trim().equals("") )
			{
				stringBuffer.append("Titel måste vara ifylld, men max vara 128 tecken lång.");
				return stringBuffer;
			}
			
			if( titleRss != null && titleRss.trim().length() > 128 )
			{
				stringBuffer.append("Titel får vara max vara 128 tecken lång. Din är: ");
				stringBuffer.append(titleRss.trim().length());
				return stringBuffer;
			}
			
			if( descriptionRss == null || descriptionRss.trim().equals("") )
			{
				stringBuffer.append("Meddelande måste vara ifylld, men max vara 500 tecken lång.");
				return stringBuffer;
			}
			
			if( descriptionRss != null && descriptionRss.trim().length() > 500 )
			{
				stringBuffer.append("Meddelande får vara max vara 500 tecken lång. Din är: ");
				stringBuffer.append(descriptionRss.trim().length());
				return stringBuffer;
			}
			
			if( passwordRss == null || !passwordRss.trim().equals( PASSWORD ) )
			{
				stringBuffer.append("Felaktigt lösenord.");
				return stringBuffer;
			}
		}
		else if(submitBild != null && submitBild.equals("Spara bild"))
		{
			if( descriptionImage == null || descriptionImage.trim().equals("") )
			{
				stringBuffer.append("Beskrivning måste vara ifylld, men max vara 256 tecken lång.");
				return stringBuffer;
			}
			
			if( descriptionImage != null && descriptionImage.trim().length() > 256 )
			{
				stringBuffer.append("Beskrivning får vara max vara 256 tecken lång. Din är: ");
				stringBuffer.append(descriptionImage.trim().length());
				return stringBuffer;
			}
			
			if( inputStreamImage != null )
			{
				try
				{
					if( inputStreamImage.available() > IMAGE_MAXSIZE )
					{
						stringBuffer.append("Bild får max vara " + (IMAGE_MAXSIZE/1000000) + " MB stor. Din är: ");
						stringBuffer.append( inputStreamImage.available() );
						return stringBuffer;
					}
					else if( inputStreamImage.available() < 1 )
					{
						stringBuffer.append("Bild måste vara angiven.");
						return stringBuffer;
					}
				}
				catch( IOException ioe)
				{
					throw new RuntimeException(ioe);
				}
			}
			
			if( inputStreamImage == null )
			{
				stringBuffer.append("Bild måste vara angiven.");
				return stringBuffer;
			}
			
			if( passwordImage == null || !passwordImage.trim().equals( PASSWORD ) )
			{
				stringBuffer.append("Felaktigt lösenord.");
				return stringBuffer;
			}
		}
		else if(submitDokument != null && submitDokument.equals("Spara dokument"))
		{
			if( inputStreamDocument != null )
			{
				try
				{
					if( inputStreamDocument.available() > DOCUMENT_MAXSIZE )
					{
						stringBuffer.append("Dokumentet får max vara " + (DOCUMENT_MAXSIZE/1000000) +" MB stor. Ditt är: ");
						stringBuffer.append( inputStreamDocument.available() );
						return stringBuffer;
					}
					else if( inputStreamDocument.available() < 1 )
					{
						stringBuffer.append("Dokument måste vara angiven.");
						return stringBuffer;
					}
				}
				catch( IOException ioe)
				{
					throw new RuntimeException(ioe);
				}
			}
			
			if( inputStreamDocument == null )
			{
				stringBuffer.append("Dokument måste vara angiven.");
				return stringBuffer;
			}
			
			if( fileDescriptionDocument != null && fileDescriptionDocument.trim().length() > 32 )
			{
				stringBuffer.append("Beskrivning får vara max vara 32 tecken lång. Din är: ");
				stringBuffer.append(fileDescriptionDocument.trim().length());
				return stringBuffer;
			}
			
			if( passwordDocument == null || !passwordDocument.trim().equals( PASSWORD ) )
			{
				stringBuffer.append("Felaktigt lösenord.");
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
	<title>Norruddens vägförening - admin</title>
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
				<form action="admin.jsp" method="post" id="meddelande" name="meddelande" >
					<table class="rounded_red_small_box">
						<tr>
							<td colspan="2">
								<img alt="Meddelanden" src="images/memo_2.png" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Information som läggs upp under
								<br/>
								&quot;Senaste nytt&quot; på startsidan.
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Lösenord:
							</td>
							<td>
								<input type="password" name="passwordRss" value="" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Titel:
							</td>
							<td>
								<input type="text" name="titleRss" value="<%=titleRss%>" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black" valign="top">
								Meddelande:
							</td>
							<td>
								<textarea rows="4" cols="28" name="descriptionRss"><%=descriptionRss%></textarea>
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td>
								<input type="submit" name="submitMeddelande" id="submitMeddelande" value="Spara meddelande" />
							</td>
						</tr>		
					</table>
				</form>
			</td>
			<td valign="top" align="left">
				<form action="admin.jsp" method="post" id="bild" name="bild" enctype="multipart/form-data">
					<table class="rounded_red_small_box">
						<tr>
							<td colspan="2">
								<img alt="Bilder" src="images/images_2.png" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Bilder som läggs upp under
								<br/>
								&quot;Bilder&quot; på startsidan.
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Lösenord:
							</td>
							<td>
								<input type="password" name="passwordImage" value="" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Bild:
							</td>
							<td>
								<input type="file" name="fileImage" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Beskrivning:
							</td>
							<td>
								<textarea rows="4" cols="28" name="descriptionImage"><%=descriptionImage%></textarea>
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td>
								<input type="submit" name="submitBild" id="submitBild" value="Spara bild" />
							</td>
						</tr>			
					</table>
				</form>
			</td>			
		</tr>
		<tr>
			<td valign="top" align="left">
				<form action="admin.jsp" method="post" id="dokument" name="dokument" enctype="multipart/form-data">
					<table class="rounded_red_small_box">
						<tr>
							<td colspan="2">
								<img alt="Dokument" src="images/document_2.png" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Dokument som läggs upp under sidan
								<br/>
								&quot;Dokument&quot;.
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Lösenord:
							</td>
							<td>
								<input type="password" name="passwordDocument" value="" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Dokument:
							</td>
							<td>
								<input type="file" name="fileDocument" />
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Beskrivning:
							</td>
							<td>
								<input type="text" name="filedescription" value="" />
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td>
								<input type="submit" name="submitDokument" id="submitDokument" value="Spara dokument" />
							</td>
						</tr>			
					</table>
				</form>	
			</td>
			<td valign="top" align="left">
				<form action="messagelist.jsp" target="_blank" method="post" id="messagelist" name="messagelist" >
					<table class="rounded_red_small_box">
						<tr>
							<td colspan="2">
								<img alt="Meddelandelista" src="images/messagelist.png" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="font_verdana_12_black">
								Läs inkomna meddelanden från medlemmar,
								<br/>
								postade från kontaktformuläret här på hemsidan.
								<br/>
								<b>Obs det kan finnas meddelande på epostkontot 
								<br/>
								som inte listas här.</b>
							</td>
						</tr>
						<tr>
							<td class="font_verdana_12_black">
								Lösenord:
							</td>
							<td>
								<input type="password" name="passwordMessageList" value="" />
							</td>
						</tr>
						<tr>
							<td>
							</td>
							<td>
								<input type="submit" name="submitMessageList" id="submitMessageList" value="Visa lista" />
							</td>
						</tr>			
					</table>
				</form>	
			</td>			
		</tr>
		<tr>
			<td colspan="2" class="font_verdana_12_black">
				Status: <font color="green"><b><%=successMessage%></b></font>
			</td>
		</tr>
	</table>
		
	
	
</body>
</html>

<%
	passwordRss = null;
	titleRss = "";
	descriptionRss = "";
	submitMeddelande = null;
	
	passwordImage = null;
	inputStreamImage = null;
	descriptionImage = "";
	submitBild = null;
	
	passwordDocument = null;
	inputStreamDocument = null;
	fileNameDocument = null;
	fileDescriptionDocument = null;
	submitDokument = null;
	DOCUMENT_MAXSIZE = 0;
	IMAGE_MAXSIZE = 0;
	PASSWORD = "";
%>