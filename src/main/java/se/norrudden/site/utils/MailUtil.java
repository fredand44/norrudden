package se.norrudden.site.utils;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import se.norrudden.site.hibernate.HibernateUtil;
import se.norrudden.site.model.SystemParameter;

public class MailUtil
{
	static final Logger logger = LogManager.getLogger(MailUtil.class.getName());
	public static final String ending = "\nOBS! Önskar du kontakt med styrelsen vid icke brådskande ärenden, använd då kontaktformuläret på hemsidan.\nhttp://jbossas-norrudden.rhcloud.com/\nMålet är att styrelsen läser dessa inkomna meddelanden och mail åtminstone vid varje styrelsemöte.\n\nVi har valt att inte lägga ut telefonnummer till medlemmarna i styrelsen på hemsidan då de allt för enkelt kan läsas av utomstående. Telefonnummer till styrelsen finns att läsa vid brevlådorna.\n\nMvh Styrelsen";
	
	public static void sendGmailNoSSL(String to, String subject, String text) throws AddressException, MessagingException
	{	
		final boolean send = Boolean.parseBoolean( HibernateUtil.getSystemParameter( SystemParameter.EMAIL_SEND ) );
		
		if(send)
		{
			final String SMTP_HOST = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_SMTP_HOST );
			final String SMTP_PORT = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_SMTP_PORT );
			
			final String GMAIL_USERNAME = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_ADDRESS);
			final String GMAIL_PASSWORD = HibernateUtil.getSystemParameter( SystemParameter.EMAIL_PASSWORD);
	
			Properties prop = System.getProperties();
			prop.setProperty("mail.smtp.starttls.enable", "true");
			prop.setProperty("mail.smtp.host", SMTP_HOST);
			prop.setProperty("mail.smtp.user", GMAIL_USERNAME);
			prop.setProperty("mail.smtp.password", GMAIL_PASSWORD);
			prop.setProperty("mail.smtp.port", SMTP_PORT);
			prop.setProperty("mail.smtp.auth", "true");
	
			Session session = Session.getInstance(prop, new Authenticator()
			{
				protected PasswordAuthentication getPasswordAuthentication()
				{
					return new PasswordAuthentication(GMAIL_USERNAME,
							GMAIL_PASSWORD);
				}
			});
			session.setDebug(false);
	
	
			MimeMessage message = new MimeMessage(session);
	
			message.setFrom(new InternetAddress(GMAIL_USERNAME));
			message.addRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
			message.setSubject(subject);
			message.setText(text);
			message.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to));
			Transport transport = session.getTransport("smtp");
			transport.connect(SMTP_HOST, GMAIL_USERNAME, GMAIL_PASSWORD);
			transport.sendMessage(message, message.getAllRecipients());
			
			String logRow = "Epost skickat till: " + to + " subject: " + subject;
			if(logRow.length() > 100)
			{
				logRow = logRow.substring(0, 97) + "...";
			}
				
			logger.info(logRow);
		}
		else
		{
			logger.info("Epost avstängd: " + to);
		}
	}
}