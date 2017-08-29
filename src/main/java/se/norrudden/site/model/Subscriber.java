package se.norrudden.site.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Subscribers")
public class Subscriber
{
	@Id
	@GeneratedValue
	private Integer id;
	private String name;
	private String email;
	
	public Subscriber()
	{
		
	}

	public Subscriber(String name, String email)
	{
		super();
		this.name = name;
		this.email = email;
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

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	@Override
	public String toString()
	{
		return "Subscriber [id=" + id + ", name=" + name + ", email=" + email + "]";
	}
}
