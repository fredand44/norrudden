package se.norrudden.site.servlet;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import se.norrudden.site.file.FileUtil;
import se.norrudden.site.hibernate.HibernateUtil;
import se.norrudden.site.model.Document;
import se.norrudden.site.tags.VisitorCounterTag;

public class WordDocumentServlet extends HttpServlet
{
	private static final long serialVersionUID = 7156955794191296982L;
	
	static final Logger logger = LogManager.getLogger(PdfDocumentServlet.class.getName());

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException 
	{
		logger.debug("Börjar returnerar word-dokument");
		try
		{
			String documentId = request.getParameter("documentid");
			Document document = (Document)HibernateUtil.selectForId(new Integer(documentId), Document.class, true);
			
			if(document != null)
			{
				response.setContentType("application/msword"); 
				response.setHeader("Content-Disposition","inline; filename=" + document.getName() + ";");
	            
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				byte[] zipToBytes = FileUtil.zipToBytes( document.getFile() );
				byteArrayOutputStream.write(zipToBytes, 0, zipToBytes.length);
				
				response.setContentLength( byteArrayOutputStream.size() );
				OutputStream out = response.getOutputStream();
				byteArrayOutputStream.writeTo(out);
				byteArrayOutputStream.flush();
				byteArrayOutputStream.close();
				out.flush();
			    out.close(); 
			}
			
			String ip = VisitorCounterTag.getRemoteIp(request);
			logger.info("Returnerar word-dokument: " + documentId + " till ip: " + ip);
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
