package se.norrudden.site.file;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

public class FileUtil
{
	public static byte[] read(InputStream inputStream) throws IOException
	{
	    byte []buffer = new byte[(int) inputStream.available()];
	    try 
	    {
	        if ( inputStream.read(buffer) == -1 ) 
	        {
	            throw new IOException("EOF reached while trying to read the whole file");
	        }        
	    } 
	    finally 
	    { 
	        try 
	        {
	             if ( inputStream != null )
	             {
	            	 inputStream.close();
	             }
	        } 
	        catch ( IOException e) 
	        {
	        	//ignore
	        }
	    }
	
	    return buffer;
	}
	
	public static byte[] bytesToZip(byte[] bytes, String name) throws IOException
	{
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		ZipOutputStream zipOutputStream = new ZipOutputStream(byteArrayOutputStream);
		zipOutputStream.putNextEntry( new ZipEntry( name ) );
		zipOutputStream.write(bytes, 0, bytes.length);
		zipOutputStream.closeEntry();
		zipOutputStream.finish();
		return byteArrayOutputStream.toByteArray();
	}
	
	public static byte[] read(File file) throws IOException
	{
	    byte []buffer = new byte[(int) file.length()];
	    InputStream ios = null;
	    try {
	        ios = new FileInputStream(file);
	        if ( ios.read(buffer) == -1 ) {
	            throw new IOException("EOF reached while trying to read the whole file");
	        }        
	    } 
	    finally 
	    { 
	        try 
	        {
	             if ( ios != null ) 
	             {
	                  ios.close();
	             }
	        } 
	        catch ( IOException e) 
	        {
	        	//ignore
	        }
	    }
	
	    return buffer;
	}
	
	public static HashMap<String, Object> readForm(HttpServletRequest request) throws ServletException, IOException 
	{
		HashMap<String, Object> parameters = new HashMap<String, Object>();
	    try {
	        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	        for (FileItem item : items) 
	        {
	            if (item.isFormField()) 
	            {
	                // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
	                String fieldname = item.getFieldName();
	                String fieldvalue = item.getString();
	                parameters.put(fieldname, fieldvalue);
	            } 
	            else 
	            {
	                // Process form file field (input type="file").
	                String fieldname = item.getFieldName();
	                String filename = FilenameUtils.getName(item.getName());
	                InputStream filecontent = item.getInputStream();
	                parameters.put(fieldname, filecontent);
	                parameters.put("filename", filename);
	                // ... (do your job here)
	            }
	        }
	    } 
	    catch (FileUploadException e) 
	    {
	        throw new RuntimeException("Cannot parse multipart request.", e);
	    }

	    return parameters;
	}
	
	public static InputStream readFile(HttpServletRequest request, String formFieldName) throws RuntimeException 
	{
	    try 
	    {
	        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	        for (FileItem item : items) 
	        {
	            if (item.isFormField()) 
	            {
	                // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
	                String fieldname = item.getFieldName();
	                String fieldvalue = item.getString();
	                // ... (do your job here)
	            } 
	            else 
	            {
	                // Process form file field (input type="file").
	            	
	            	String fieldname = item.getFieldName();
	            	if( formFieldName.equals(fieldname) )
	            	{
		                String filename = FilenameUtils.getName(item.getName());
		                InputStream filecontent = item.getInputStream();
		                // ... (do your job here)
		                return filecontent;	            		
	            	}
	            }
	        }
	    } 
	    catch (Exception e) 
	    {
	        throw new RuntimeException(e.getMessage());
	    }

	    return null;
	}
	
	public static BufferedImage resizeImage(BufferedImage originalImage)
	{
		int width = 100;
		int height = 100;
		double widthFactor = 0;
		double heightFactor = 0;
		double maxWidth = 800;
		double maxHeight = 600;
				
		//Get widthFactor
		if( originalImage.getWidth() > maxWidth )
		{
			widthFactor = maxWidth / originalImage.getWidth(); 
		}
		else
		{
			widthFactor = 1; 
		}
		
		//Get heightFactor
		if( originalImage.getHeight() > maxHeight )
		{
			heightFactor = maxHeight / originalImage.getHeight(); 
		}
		else
		{
			heightFactor = 1; 
		}
		
		
		//Use the smallest factor
		if(widthFactor < heightFactor)
		{
			
			width = (int) Math.round(originalImage.getWidth() * widthFactor);
			height = (int) Math.round(originalImage.getHeight() * widthFactor);
		}
		else if(widthFactor > heightFactor)
		{
			width = (int) Math.round(originalImage.getWidth() * heightFactor);
			height = (int) Math.round(originalImage.getHeight() * heightFactor);
		}
		else if(widthFactor == heightFactor)
		{
			width = (int) Math.round(originalImage.getWidth() * widthFactor);
			height = (int) Math.round(originalImage.getHeight() * heightFactor);
		}
		
		BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics2D g = resizedImage.createGraphics();
		g.drawImage(originalImage, 0, 0, resizedImage.getWidth(), resizedImage.getHeight(), null);
		g.dispose();
		return resizedImage;
	}
	
	public static BufferedImage resizeImageToThumb(BufferedImage originalImage)
	{
		int width = 100;
		int height = 100;
		if(originalImage.getWidth() > originalImage.getHeight() )
		{
			//Liggande
			width = 133;
		}
		else if(originalImage.getWidth() < originalImage.getHeight() )
		{
			//Stående
			height = 133;
		}
		else
		{
			//Fyrkantig
		}
		
		BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics2D g = resizedImage.createGraphics();
		g.drawImage(originalImage, 0, 0, resizedImage.getWidth(), resizedImage.getHeight(), null);
		g.dispose();
		return resizedImage;
	}
	
	public static BufferedImage bytesToImage(byte[] imageInByte) throws RuntimeException
	{		 
		try 
		{
			InputStream inputStream = new ByteArrayInputStream(imageInByte);
			BufferedImage bufferedImage = ImageIO.read(inputStream);
			return bufferedImage;
		} 
		catch (Exception e) 
		{
			throw new RuntimeException(e);
		}
	}
	
	public static byte[] imageToBytes(BufferedImage bufferedImage) throws RuntimeException
	{		 
		try 
		{
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( bufferedImage, "jpg", baos );
			baos.flush();
			byte[] imageInByte = baos.toByteArray();
			baos.close();
			return imageInByte;
		} 
		catch (Exception e) 
		{
			throw new RuntimeException(e);
		}
	}
	
	public static String printMap(Map<?, ?> mp) 
	{
		StringBuffer stringBuffer = new StringBuffer(); 
	    Iterator<?> it = mp.entrySet().iterator();
	    while (it.hasNext()) 
	    {
	        Map.Entry pairs = (Map.Entry)it.next();
	        stringBuffer.append( " " + pairs.getKey() );
	        if(pairs.getValue() instanceof String )
	        {
	        	stringBuffer.append( "=" );
	        	stringBuffer.append( pairs.getValue() );
	        }
	        else
	        {
	        	stringBuffer.append( "=" );
	        	if(pairs.getValue() != null)
	        	{
	        		stringBuffer.append( "NOT NULL" );
	        	}
	        	else
	        	{
	        		stringBuffer.append( "NULL" );
	        	}
	        	
	        }
	        //it.remove(); // avoids a ConcurrentModificationException
	    }
	    return stringBuffer.toString();
	}
	
	public static byte[] zipToBytes(byte[] zipBytes)
	{
		byte[] bytes = new byte[0];
		ZipInputStream zipInputStream = null;
		ByteArrayOutputStream byteArrayOutputStream = null;
		try
		{
			zipInputStream = new ZipInputStream( new ByteArrayInputStream( zipBytes ), Charset.forName("Cp437") );
			ZipEntry zipEntry = zipInputStream.getNextEntry();
			
			while (zipEntry != null)
			{
				bytes = new byte[ zipInputStream.available() ];
				
				byte[] buffer = new byte[1024];
				
				byteArrayOutputStream = new ByteArrayOutputStream( );
				int length;
				while ( ( length = zipInputStream.read( buffer ) ) > 0)
				{
					byteArrayOutputStream.write( buffer, 0, length );
				}
				
				bytes = byteArrayOutputStream.toByteArray( );
				
				break;
			}

			zipInputStream.closeEntry();
		} 
		catch (IOException ex)
		{
			throw new RuntimeException(ex.getMessage());
		}
		finally 
		{
			if( byteArrayOutputStream != null )
			{
				try
				{
					byteArrayOutputStream.close();
				} 
				catch (IOException e)
				{
					//Ignore
				}
			}
			
			if( zipInputStream != null )
			{
				try
				{
					zipInputStream.close();
				} 
				catch (IOException e)
				{
					//Ignore
				}
			}
		}
		
		return bytes;
	}   

	public static void main(String[] args)
	{
		System.out.println("Start");
		try
		{
			
			byte[] bytes = FileUtil.read( new FileInputStream("C:\\Fredrik\\Images\\telefon_20140312\\DSC_0307B.jpg") );
			
			//Resize original to 800*600
			BufferedImage bufferedImage  = FileUtil.bytesToImage(bytes);
			bufferedImage = FileUtil.resizeImage(bufferedImage);
			bytes = FileUtil.imageToBytes(bufferedImage);
			
			FileOutputStream fos = new FileOutputStream("C:\\Fredrik\\Images\\telefon_20140312\\DSC_0307C.jpg");
			fos.write(bytes);
			fos.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		System.out.println("end");
	}
}


