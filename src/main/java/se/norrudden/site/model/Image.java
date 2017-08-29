package se.norrudden.site.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "Images")
public class Image
{
	@Id
	@GeneratedValue
	private Integer id;
	private byte[] file;
	
	public Image()
	{
		super();
	}
	
	public Image(Integer id, byte[] file)
	{
		super();
		this.id = id;
		this.file = file;
	}
	public Integer getId()
	{
		return id;
	}
	public void setId(Integer id)
	{
		this.id = id;
	}
	
	public byte[] getFile()
	{
		return file;
	}
	public void setFile(byte[] file)
	{
		this.file = file;
	}
	@Override
	public String toString()
	{
		String string = "Images [id=" + id;
		if( file != null )
		{
			string = string + " file.size=" + file.length;
		}
		string = string + "]";
		
		return string;
	}
}
