package se.norrudden.site.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;


/*
 * Stores an RSS feed
 */
@Entity
@Table(name = "Feeds")
public class Feed
{
	@Id
	@GeneratedValue
	private Integer id;
	private String title;
	private String link;
	private String description;

	@OneToMany(mappedBy="feed", fetch=FetchType.EAGER)
	final private List<FeedMessage> feedMessages = new ArrayList<FeedMessage>();

	public Feed()
	{
		
	}

	public Feed(String title, String link, String description)
	{
		super();
		this.title = title;
		this.link = link;
		this.description = description;
	}
	
	public Integer getId()
	{
		return id;
	}

	public void setId(Integer id)
	{
		this.id = id;
	}

	public List<FeedMessage> getFeedMessages()
	{
		return feedMessages;
	}

	public String getTitle()
	{
		return title;
	}

	public String getLink()
	{
		return link;
	}

	public String getDescription()
	{
		return description;
	}

	@Override
	public String toString()
	{
		return "Feed [id=" + id + ", title=" + title + ", link=" + link
				+ ", description=" + description + ", feedMessages=" + feedMessages + "]";
	}
}
