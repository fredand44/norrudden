<%@ taglib uri="WEB-INF/taglib/norrudden.tld" prefix="norrudden" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<script type="text/javascript" src="js/norrudden.js"></script>
	<link rel="stylesheet" href="css/norrudden.css" type="text/css" media="screen" />
	<title>Norruddens vägförening - welcome+</title>
	
</head>
	<body>
		<table align="center">
			<tr>
				<td >
					<table class="rounded_red_box">
						<tr>
							<td align="center" valign="middle">
								<table>
									<tr>
										<td align="center" valign="middle" width="85%" rowspan="2">
												<a href="index.jsp"><img style="border: 0;" src="images/logo.png" alt="Logo Norruddens vägförening" /></a>
										</td>
										<td align="left" valign="middle" class="font_verdana_10_black_underline" width="15%">
											<norrudden:VisitorCounterTag/> 
										</td>
									</tr>
									<tr>
										<td align="left" valign="middle" width="15%">
											<a href="http://jbossas-norrudden.rhcloud.com/norrudden.xml">
												<img style="border: 0; width: 36px; height: 14px" src="http://www.w3schools.com/xml/pic_rss.gif" alt="Prenumerera på information från Norruddens vägförening med RSS" />
											</a>
										</td>
									</tr>
									<tr>
										<td align="center" valign="middle" width="15%">
											<table>
											<tr>
												<td><a
													href="subscribeholder.jsp">
														<img style="border: 0"
														src="images/email_subscribe_small.png"
														alt="Prenumerera på nyheter via epost" />
													</a>
												</td>
												<td><a
													href="documentlistholder.jsp">
														<img style="border: 0"
														src="images/document_small.png"
														alt="Dokumentlista" />
													</a>
												</td>
												<td><a
													href="contactholder.jsp">
														<img style="border: 0"
														src="images/contact_small.png"
														alt="Kontaktuppgifter" />
													</a>
												</td>
												<td><a
													href="adminholder.jsp">
														<img style="border: 0"
														src="images/admin_small.png"
														alt="Admingränssnitt" />
													</a>
												</td>
											</tr>
										</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
