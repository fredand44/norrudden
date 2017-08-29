package se.norrudden.site.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Documents")
public class Document
{
	@Id
	@GeneratedValue
	private Integer id;
	private String name;
	private String description;
	private byte[] file;
	private Timestamp pubDate;
	
	public Document()
	{
		super();
	}

	public Document(Integer id, String name, String description, byte[] file, Timestamp pubDate)
	{
		super();
		this.id = id;
		this.name = name;
		this.description = description;
		this.file = file;
		this.pubDate = pubDate;
	}

	public Integer getId()
	{
		return id;
	}

	public void setId(Integer id)
	{
		this.id = id;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public byte[] getFile()
	{
		return file;
	}

	public void setFile(byte[] file)
	{
		this.file = file;
	}

	public Timestamp getPubDate()
	{
		return pubDate;
	}

	public void setPubDate(Timestamp pubDate)
	{
		this.pubDate = pubDate;
	}

	@Override
	public String toString()
	{
		String string = "Document [id=" + id + ", name=" + name + ", description=" + description
				+ ", pubDate=" + pubDate + "]";
		
		if( file != null )
		{
			string = string + " file.size=" + file.length;
		}
		string = string + "]";
		
		return string;
	}
		
	
	
}
