package se.norrudden.site.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


/*
 * Represents one RSS message
 */
@Entity
@Table(name = "FeedMessages")
public class FeedMessage
{
	@Id
	@GeneratedValue
	private Integer id;
	private String title;
	private String description;
	private String link;
	private String guid;
	private Timestamp pubDate;

	@ManyToOne
	@JoinColumn(name="fk_feedId")
	private Feed feed;
	
	public FeedMessage()
	{
		
	}

	public FeedMessage(Integer id, String title, String description,
			String link, String guid, Timestamp pubDate, Feed feed)
	{
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.link = link;
		this.guid = guid;
		this.pubDate = pubDate;
		this.feed = feed;
	}

	public String getTitle()
	{
		return title;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public String getLink()
	{
		return link;
	}

	public void setLink(String link)
	{
		this.link = link;
	}

	public String getGuid()
	{
		return guid;
	}

	public void setGuid(String guid)
	{
		this.guid = guid;
	}
	

	public Timestamp getPubDate()
	{
		return pubDate;
	}

	public void setPubDate(Timestamp pubDate)
	{
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

	public Feed getFeed()
	{
		return feed;
	}

	public void setFeed(Feed feed)
	{
		this.feed = feed;
	}

	@Override
	public String toString()
	{
		return "FeedMessage [id=" + id + ", title=" + title + ", description="
				+ description + ", link=" + link + ", guid=" + guid
				+ ", pubDate=" + pubDate + ", feed=" + feed + "]";
	}
}
