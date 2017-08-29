package se.norrudden.site.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;


/*
 * Represents one RSS message
 */
@Entity
@Table(name = "SystemParameters")
public class SystemParameter
{
	
	public static final String NAME_QUERY = "SELECT s FROM SystemParameter s WHERE s.name=:name";
	
	public static final String EMAIL_ADDRESS = "EMAIL_ADDRESS";
	public static final String EMAIL_PASSWORD = "EMAIL_PASSWORD";
	public static final String EMAIL_SMTP_HOST = "EMAIL_SMTP_HOST";
	public static final String EMAIL_SMTP_PORT = "EMAIL_SMTP_PORT";
	public static final String EMAIL_SEND = "EMAIL_SEND";
	public static final String DOCUMENT_MAXSIZE = "DOCUMENT_MAXSIZE";
	public static final String IMAGE_MAXSIZE = "IMAGE_MAXSIZE";
	public static final String PASSWORD = "PASSWORD";
	
	
	@Id
	@GeneratedValue
	private Integer id;
	private String name;
	private String value;
	
	public SystemParameter()
	{
		
	}

	public SystemParameter(String name, String value)
	{
		super();
		this.name = name;
		this.value = value;
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

	public String getValue()
	{
		return value;
	}

	public void setValue(String value)
	{
		this.value = value;
	}

	@Override
	public String toString()
	{
		return "SystemParameter [id=" + id + ", name=" + name + ", value="
				+ value + "]";
	}
}
