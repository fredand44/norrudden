package se.norrudden.site.file;

import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.junit.Test;

public class TestFileUtil
{
	/**
	 * Testar att öppna en zipfil och läsa innehållet.
	 */
	@Test
	public void test1()
	{
		FileOutputStream fos;
		try
		{	
			byte[] fileBytes = FileUtil.read( new File("C:\\avtals_förslag.zip") );
			byte[] zipToBytes = FileUtil.zipToBytes( fileBytes );
			
			assertNotNull( zipToBytes );
			
			fos = new FileOutputStream ( "C:\\avtals_förslag_2.pdf" );
			fos.write( zipToBytes );
			fos.close();
		} 
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}

	}
}
