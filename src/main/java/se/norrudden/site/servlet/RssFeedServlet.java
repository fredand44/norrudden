package se.norrudden.site.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import se.norrudden.rss.write.RSSFeedWriter;
import se.norrudden.site.hibernate.HibernateUtil;
import se.norrudden.site.model.Feed;
import se.norrudden.site.model.FeedAccessCounter;
import se.norrudden.site.tags.VisitorCounterTag;

public class RssFeedServlet extends HttpServlet
{
	private static final long serialVersionUID = 6504597573577386800L;
	
	static final Logger logger = LogManager.getLogger(RssFeedServlet.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		logger.debug("Börjar returnerar RSS");
		
		PrintWriter out = response.getWriter();
			
		try 
		{	
			String[] parameterNames = {};
			Object[] parameterValues = {};
			String queryString = "SELECT f FROM Feed f WHERE f.id IN (SELECT MAX(f2.id) FROM Feed f2)";
			java.util.List<Object> feedList = HibernateUtil.executeQuery(queryString, parameterNames, parameterValues, true);
			if(feedList.size() == 1)
			{
				response.setContentType("application/rss+xml");
				Feed feed = (Feed)feedList.get(0);
				
				FeedAccessCounter feedAccessCounter = (FeedAccessCounter)HibernateUtil.selectForId(feed.getId(), FeedAccessCounter.class, true);
				if(feedAccessCounter == null)
				{
					feedAccessCounter = new FeedAccessCounter(feed.getId(), 1l, feed);
				}
				else
				{
					feedAccessCounter.setCounter( feedAccessCounter.getCounter() + 1l );
				}
				
				HibernateUtil.save(feedAccessCounter, feedAccessCounter.getId(), true);
				
				RSSFeedWriter writer = new RSSFeedWriter(feed, out);
			    writer.write();
			}
			else
			{
				response.setContentType("text/html");
				String message = "No feeds exist!";			
				out.println(message);
			}
			
			String ip = VisitorCounterTag.getRemoteIp(request);
			logger.info("Returnerar RSS till ip: " + ip);
		}
		catch(Exception e)
		{
			response.setContentType("text/html");
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			String message = sw.toString();			
			out.println(message);
			
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
}
