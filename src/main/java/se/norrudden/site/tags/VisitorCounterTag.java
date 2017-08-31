package se.norrudden.site.tags;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import se.norrudden.site.hibernate.HibernateUtil;
import se.norrudden.site.model.VisitorCounter;

public class VisitorCounterTag extends SimpleTagSupport
{
	static final Logger logger = LogManager.getLogger(VisitorCounterTag.class.getName());

	private static final Integer COUNTER_ID = 1;

	public void doTag() throws JspException, IOException
	{
		try
		{
			getJspContext().getOut().write( getVisitorCount() );
    	}
		catch(Exception e)
		{
			getJspContext().getOut().write( e.getMessage() );
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

	private String getVisitorCount()
	{
		String retValue = "Besökare: ";

		PageContext pageContext = (PageContext) getJspContext();
		HttpServletRequest httpServletRequest = (HttpServletRequest) pageContext.getRequest();

		boolean serverBot = isServerBot(httpServletRequest);

		String ip = getRemoteIp(httpServletRequest);
		HttpSession httpSession = httpServletRequest.getSession(true);

		VisitorCounter visitorCounter = (VisitorCounter) httpSession.getAttribute("visitorCounter");

		if(serverBot == false)
		{
		    //First time for this session
			if ( visitorCounter == null)
		    {
		    	visitorCounter = count();
		    	logHeadersInfo(httpServletRequest);
		    	logger.info("Visitor: " + visitorCounter.getCounter() + " (" + ip + ", " + httpServletRequest.getHeader("referer") + ")");
		    }
			else
			{
				visitorCounter = justGet();
			}
		}
		else
		{
			visitorCounter = justGet();
		}

	    httpSession.setAttribute("visitorCounter", visitorCounter);
		retValue = retValue + visitorCounter.getCounter();

		return retValue;
	}

	private VisitorCounter count()
	{

		//PageContext pageContext = (PageContext) getJspContext();
		//HttpServletRequest httpServletRequest = (HttpServletRequest) pageContext.getRequest();
		//String ip = httpServletRequest.getRemoteAddr();

		//BotTrap botTrap = (BotTrap) HibernateUtil.selectForId(ip, BotTrap.class, true);

		VisitorCounter visitorCounter = justGet();

		// First visitor ever
		if (visitorCounter == null)
		{
			visitorCounter = new VisitorCounter();
			visitorCounter.setCounter(1l);
		}
		else
		{
			//if (botTrap != null)
			//{
			//	logger.info("Visitor seems to be a bot: " + ip);
			//}
			//else
			//{
				visitorCounter.setCounter(visitorCounter.getCounter() + 1l);
			//}
		}
		HibernateUtil.save(visitorCounter, COUNTER_ID, true);

		return visitorCounter;

	}

	private VisitorCounter justGet()
	{
		VisitorCounter visitorCounter = (VisitorCounter)HibernateUtil.selectForId(COUNTER_ID, VisitorCounter.class, true);
		return visitorCounter;
	}

	private void logHeadersInfo(HttpServletRequest httpServletRequest)
	{
		Enumeration<String> headerNames = httpServletRequest.getHeaderNames();

		while (headerNames.hasMoreElements())
		{
			StringBuffer stringBuffer = new StringBuffer();

			String key = (String) headerNames.nextElement();
			String value = httpServletRequest.getHeader(key);
			stringBuffer.append(key);
			stringBuffer.append(": ");
			stringBuffer.append(value);

			stringBuffer.toString().length();

			String logRow = stringBuffer.toString();
			if(logRow.length() > 100)
			{
				logRow = logRow.substring(0, 97) + "...";
			}

			logger.info(logRow);
		}
	 }

	private boolean isServerBot( HttpServletRequest httpServletRequest )
	{
		boolean serverBot = false;
		String accept =  httpServletRequest.getHeader("accept");
		String userAgent =  httpServletRequest.getHeader("user-agent");
		String ip =  httpServletRequest.getHeader("x-client-ip");

		if( "*/*".equals( accept ) && "Ruby".equals( userAgent ) )
		{
			serverBot = true;
			logger.info("ServerBot: " + ip + " (no visitor counting)");
		}

		return serverBot;
	}

	public static String getRemoteIp( HttpServletRequest httpServletRequest )
	{
		String ip = httpServletRequest.getRemoteAddr();
		String clientIp = httpServletRequest.getHeader("x-client-ip");
		if( clientIp != null  && !clientIp.equals(ip) )
		{
			ip = clientIp;
		}
		else
		{
			if(ip == null)
			{
				ip = "not set";
			}
		}
		return ip;
	}

}
