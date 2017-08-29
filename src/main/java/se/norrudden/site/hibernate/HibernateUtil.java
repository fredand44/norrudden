package se.norrudden.site.hibernate;

import java.io.Serializable;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.exception.JDBCConnectionException;

import se.norrudden.site.model.SystemParameter;
  
public class HibernateUtil {
  
    private static SessionFactory sessionFactory = buildSessionFactory();
  
    private static SessionFactory buildSessionFactory() 
    {
        try 
        {
            // Create the SessionFactory from hibernate.cfg.xml
            return new AnnotationConfiguration().configure().buildSessionFactory();
        } 
        catch (Throwable ex) 
        {
            throw new ExceptionInInitializerError(ex);
        }
    }
  
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    
    public static Object selectForId(Object id, Class<?> clazz, boolean retry)
    {
    	try
    	{
		    SessionFactory sf = HibernateUtil.getSessionFactory();
		    Session session = sf.openSession();
		 
		    Object object = session.get(clazz, (Serializable) id);
		    session.close();
		    
		    return object;
    	}
    	catch(JDBCConnectionException e)
    	{
    		if(retry)
    		{
    			sessionFactory = buildSessionFactory();
    			return selectForId(id, clazz, false);
       		}
       		else
       		{
       			throw e;
       		}
    	}
    }
    
    public static List<Object> executeQuery(String queryString, String[] parameterNames, Object[] parameterValues, boolean retry)
    {
    	try
    	{
	    	SessionFactory sf = HibernateUtil.getSessionFactory();
	    	Session session = sf.openSession();
	    	
	    	Query query = session.createQuery(queryString);
			
	    	for (int i = 0; i < parameterValues.length; i++) 
	    	{
	    		query.setParameter(parameterNames[i], parameterValues[i]);
			}
	 
			@SuppressWarnings("unchecked")
			List<Object> list = query.list();
			
			session.close();
			
			return list;
    	}
       	catch(JDBCConnectionException e)
    	{
       		if(retry)
       		{
       			sessionFactory = buildSessionFactory();
       			return executeQuery(queryString, parameterNames, parameterValues, false);
       		}
       		else
       		{
       			throw e;
       		}
    	}
    }
    
    public static void save(Object object, Object id, boolean retry)
    {
    	try
    	{
	    	SessionFactory sf = HibernateUtil.getSessionFactory();
	    	Session session = sf.openSession();
	    	session.beginTransaction();
	    	
			if (id == null) {
				// new
				//session.persist(object);
				session.save(object);
			} else {
				// update
				session.merge(object);
			}
			
			session.getTransaction().commit();
			session.close();
    	}
       	catch(JDBCConnectionException e)
    	{
       		if(retry)
       		{
       			sessionFactory = buildSessionFactory();
       			save(object, id, false);
       		}
       		else
       		{
       			throw e;
       		}
    	}
    }
    
    public static void delete(Object object, boolean retry)
    {
    	try
    	{
	    	SessionFactory sf = HibernateUtil.getSessionFactory();
	    	Session session = sf.openSession();
	    	session.beginTransaction();
	    	
	    	session.delete( object );
	    	
			
			session.getTransaction().commit();
			session.close();
    	}
       	catch(JDBCConnectionException e)
    	{
       		if(retry)
       		{
       			sessionFactory = buildSessionFactory();
       			delete(object, false);
       		}
       		else
       		{
       			throw e;
       		}
    	}
    }
    
	public static String getSystemParameter(String parameterName)
	{
		String[] parameterNames = {"name"};
		Object[] parameterValues = {parameterName};
		List<Object> parameterList = HibernateUtil.executeQuery(SystemParameter.NAME_QUERY, parameterNames, parameterValues, true);
		SystemParameter systemParameter = (SystemParameter)parameterList.get(0);
		return systemParameter.getValue();
	}
}
