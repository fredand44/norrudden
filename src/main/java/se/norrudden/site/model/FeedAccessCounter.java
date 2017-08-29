package se.norrudden.site.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


/*
 * Stores an RSS feed visit
 */
@Entity
@Table(name = "FeedAccesses")
public class FeedAccessCounter
{
	@Id
	private Integer id;
	private long counter;
	
	@ManyToOne
	@JoinColumn(name="fk_feedId")
	private Feed feed;

	public FeedAccessCounter()
	{
		
	}
	
	public FeedAccessCounter(Integer id,
			long counter, Feed feed)
	{
		super();
		this.id = id;
		this.counter = counter;
		this.feed = feed;
	}

	public Integer getId()
	{
		return id;
	}

	public void setId(Integer id)
	{
		this.id = id;
	}

	public long getCounter()
	{
		return counter;
	}

	public void setCounter(long counter)
	{
		this.counter = counter;
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
		return "FeedAccessCounter [id=" + id + ", counter=" + counter
				+ ", feed=" + feed + "]";
	}
}
