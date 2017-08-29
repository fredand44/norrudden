package se.norrudden.rss.write;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.EndElement;
import javax.xml.stream.events.StartDocument;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;

import se.norrudden.site.model.Feed;
import se.norrudden.site.model.FeedMessage;

public class RSSFeedWriter 
{
  private PrintWriter servletPrintWriter;
  private Feed rssfeed;
  private XMLEventWriter eventWriter;

  public RSSFeedWriter(Feed rssfeed, PrintWriter servletPrintWriter) 
  {
    this.rssfeed = rssfeed;
    this.servletPrintWriter = servletPrintWriter;
  }

  public void write() throws Exception 
  {
    // create a XMLOutputFactory
    XMLOutputFactory outputFactory = XMLOutputFactory.newInstance();

    // create XMLEventWriter
    eventWriter = outputFactory.createXMLEventWriter( servletPrintWriter );

    // create a EventFactory
    XMLEventFactory eventFactory = XMLEventFactory.newInstance();
    XMLEvent end = eventFactory.createIgnorableSpace("\n");
    XMLEvent tab = eventFactory.createIgnorableSpace("\t");
    XMLEvent dtd = eventFactory.createDTD("\n");

    // create and write Start Tag
    StartDocument startDocument = eventFactory.createStartDocument();
    eventWriter.add(startDocument);
    
    // create open tag
    eventWriter.add(dtd);
    
    StartElement rssStart = eventFactory.createStartElement("", "", "rss");
    eventWriter.add(rssStart);
    eventWriter.add( eventFactory.createAttribute("version", "2.0") );
    eventWriter.add( eventFactory.createNamespace("atom", "http://www.w3.org/2005/Atom") );
    eventWriter.add( end );
    
    eventWriter.add( tab );
    eventWriter.add(eventFactory.createStartElement("", "", "channel"));
    eventWriter.add( end );
    
    eventWriter.add( tab );
    createNode(eventWriter, "", "", "title", rssfeed.getTitle(), null);
    
    eventWriter.add( tab );
    createNode(eventWriter, "", "", "link", rssfeed.getLink(), null);
    
    eventWriter.add( tab );
    createNode(eventWriter, "", "", "description", rssfeed.getDescription(), null);
    
    Attribute[] attributes = new Attribute[3];
    attributes[0] = eventFactory.createAttribute("href", "http://jbossas-norrudden.rhcloud.com/norrudden.xml");
    attributes[1] = eventFactory.createAttribute("rel", "self");
    attributes[2] = eventFactory.createAttribute("type", "application/rss+xml");
    
    eventWriter.add( tab );
    createNode(eventWriter, "atom", "xmlns", "link", null, attributes);
    
    for (FeedMessage entry : rssfeed.getFeedMessages()) 
    {
      eventWriter.add( tab );
      eventWriter.add( tab );
      eventWriter.add(eventFactory.createStartElement("", "", "item"));
      eventWriter.add( end );
      
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
      sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));
      
      eventWriter.add( tab );
      eventWriter.add( tab );
      createNode(eventWriter, "", "", "title", entry.getTitle() + " " + sdf.format( entry.getPubDate() ), null);
      eventWriter.add( tab );
      eventWriter.add( tab );
      createNode(eventWriter, "", "", "description", entry.getDescription(), null);
      eventWriter.add( tab );
      eventWriter.add( tab );
      createNode(eventWriter, "", "", "link", entry.getLink(), null);
      
      
      attributes = new Attribute[1];
      attributes[0] = eventFactory.createAttribute("isPermaLink", "false");
      
      eventWriter.add( tab );
      eventWriter.add( tab );
      createNode(eventWriter, "", "", "guid", entry.getGuid(), attributes);
      eventWriter.add( tab );
      eventWriter.add( tab );
      createNode(eventWriter, "", "", "pubDate", format( entry.getPubDate() ), null);
      eventWriter.add( tab );
      eventWriter.add( tab );
      eventWriter.add(eventFactory.createEndElement("", "", "item"));
    }
    eventWriter.add( end );
    
    eventWriter.add( tab );
    eventWriter.add(eventFactory.createEndElement("", "", "channel"));
    eventWriter.add( end );
    
    eventWriter.add(eventFactory.createEndElement("", "", "rss"));

    eventWriter.add(eventFactory.createEndDocument());

    eventWriter.close();
  }

  private void createNode(XMLEventWriter eventWriter, String prefix, String localName, String name, String value, Attribute[] attributes) throws XMLStreamException 
  {
    XMLEventFactory eventFactory = XMLEventFactory.newInstance();
    XMLEvent end = eventFactory.createIgnorableSpace("\n");
    XMLEvent tab = eventFactory.createIgnorableSpace("\t");
    
    // create Start node
    StartElement startElement = eventFactory.createStartElement(prefix, localName, name);
    eventWriter.add(tab);
    eventWriter.add(startElement);
    
    if(attributes != null)
    {
	    for (int i = 0; i < attributes.length; i++)
		{
	        eventWriter.add(attributes[i]);
		}
    }
    
    if(value != null)
    {
	    // create Content
	    Characters characters = eventFactory.createCharacters(value);
	    eventWriter.add(characters);
    }
    
    // create End node
    EndElement eElement = eventFactory.createEndElement(prefix, localName, name);
    eventWriter.add(eElement);
    eventWriter.add(end);
  }
  
  //public final static String RFC822 = "EEE, dd MMM yyyy HH:mm:ss Z";
  
  public static String format ( Date date ) {
	  SimpleDateFormat sdf = new SimpleDateFormat("EEE', 'dd' 'MMM' 'yyyy' 'HH:mm:ss' 'Z");
	  sdf.setTimeZone(TimeZone.getTimeZone("Europe/Stockholm"));  
	  return sdf.format ( date );
	  }
} 