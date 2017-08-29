package se.norrudden.site.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "ContactMessages")
public class ContactMessage
{
	@Id
	@GeneratedValue
	private Integer id;
	private String sender;
	private String email;
	private String telephone;
	private String message;
	private Timestamp pubDate;
	
	public ContactMessage()
	{
		
	}

	public ContactMessage(String sender, String email,
			String telephone, String message, Timestamp pubDate)
	{
		super();
		this.sender = sender;
		this.email = email;
		this.telephone = telephone;
		this.message = message;
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

	public String getSender()
	{
		return sender;
	}

	public void setSender(String sender)
	{
		this.sender = sender;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	public String getTelephone()
	{
		return telephone;
	}

	public void setTelephone(String telephone)
	{
		this.telephone = telephone;
	}

	public String getMessage()
	{
		return message;
	}

	public void setMessage(String message)
	{
		this.message = message;
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
		return "ContactMessage [id=" + id + ", sender=" + sender + ", email="
				+ email + ", telephone=" + telephone + ", message=" + message
				+ ", pubDate=" + pubDate + "]";
	}
}
