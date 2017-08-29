package se.norrudden.site.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import se.norrudden.site.hibernate.HibernateUtil;
import se.norrudden.site.model.Thumb;

public class ThumbServlet extends HttpServlet
{
	private static final long serialVersionUID = 1741137875916705456L;
	
	static final Logger logger = LogManager.getLogger(ThumbServlet.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException 
	{
		try
		{
			String imageId = request.getParameter("thumbid");
			Thumb thumb = (Thumb)HibernateUtil.selectForId(new Integer(imageId), Thumb.class, true);
			
			if(thumb != null)
			{
				response.setContentType("image/jpg");
				response.setContentLength( thumb.getFile().length );
				OutputStream out = response.getOutputStream();
			    out.write(thumb.getFile(), 0, thumb.getFile().length);
			    out.close();
			}
		}
		catch(Exception e)
		{
			PrintWriter out = response.getWriter();
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
