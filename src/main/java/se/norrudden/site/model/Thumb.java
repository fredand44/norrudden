package se.norrudden.site.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Thumbs")
public class Thumb
{
	@Id
	private Integer id;
	private String description;
	private byte[] file;
	private Timestamp pubDate;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="fk_imageId")
	private Image image;
	
	public Thumb()
	{
		super();
	}

	public Thumb(Integer id, String description, byte[] file, Timestamp pubDate,
			Image image)
	{
		super();
		this.id = id;
		this.description = description;
		this.file = file;
		this.pubDate = pubDate;
		this.image = image;
	}

	public Integer getId()
	{
		return id;
	}

	public void setId(Integer id)
	{
		this.id = id;
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

	public Image getImage()
	{
		return image;
	}

	public void setImage(Image image)
	{
		this.image = image;
	}

	@Override
	public String toString()
	{
		String string = "Thumb [id=" + id + ", description=" + description
				+ ", pubDate=" + pubDate + ", image=" + image + "]";
		
		if( file != null )
		{
			string = string + " file.size=" + file.length;
		}
		string = string + "]";
		
		return string;
	}
		
	
	
}
