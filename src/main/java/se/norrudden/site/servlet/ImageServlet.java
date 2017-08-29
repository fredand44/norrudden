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
import se.norrudden.site.model.Image;
import se.norrudden.site.tags.VisitorCounterTag;

public class ImageServlet extends HttpServlet
{
	private static final long serialVersionUID = 3033846602203547829L;

	static final Logger logger = LogManager.getLogger(ImageServlet.class.getName());
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException 
	{
		logger.debug("Börjar returnerar bild");
		try
		{
			String imageId = request.getParameter("imageid");
			Image image = (Image)HibernateUtil.selectForId(new Integer(imageId), Image.class, true);
			
			if(image != null)
			{
				response.setContentType("image/jpg");
				response.setContentLength( image.getFile().length );
				OutputStream out = response.getOutputStream();
			    out.write(image.getFile(), 0, image.getFile().length);
			    out.close();
			}
			
			String ip = VisitorCounterTag.getRemoteIp(request);
			logger.info("Returnerar bild: " + imageId + " till ip: " + ip);
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
			
			logger.error(e);
		}
	}
}
