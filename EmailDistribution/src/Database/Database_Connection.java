package Database;  

import java.sql.Connection;  
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;  

public class Database_Connection {  
	private Connection conn;  
    
	public Database_Connection() throws SQLException  {  
		try {  
			String conUrl="jdbc:mysql://localhost:3306/4155_TestDB";  
            String userName="root";  
            String pass="project";  
            Class.forName("com.mysql.jdbc.Driver");  
            conn = DriverManager.getConnection(conUrl,userName,pass);  
		}  
        catch(SQLException s) {  
        	System.out.println(s);  
        }  
        catch(ClassNotFoundException c) {  
        	System.out.println(c);  
        }  
		
		setupDatabase();
	}  
   
	public Connection getConn() {  
		return conn;  
	}  
   
	public void setConn(Connection conn) {  
		this.conn = conn;  
	}
	
	/* Database creation if the Employees table does not already exist 
	 * 
	 * TO DO: 
	 * Review the exception - Probably should be try/catch connection
	 * Add the other categories within the project's scope
	 * Compare ordering with Excel - structure to maintain format
	 * 
	 * */
	private void setupDatabase() throws SQLException {
		Statement stmt = conn.createStatement();
		/* Check count for existing tables named Employees */
		ResultSet rs = stmt.executeQuery("SELECT COUNT(*) TBLCNT FROM SYS.SYSTABLES"
				+ " WHERE SYS.SYSTABLES.TABLENAME = 'Employees'");
		rs.next();
			if (rs.getInt("TBLCNT") <= 0) {
				/* Employees table does not exist. Create the table. 
				 * Table needs to reflect the categories specified for project.
				 */
				String create = "CREATE TABLE Employees ("
		            + "EMPLOYEE_ID VARCHAR(25) NOT NULL PRIMARY KEY,"
		            + "FIRST_NAME VARCHAR(25) NOT NULL,"
		            + "LAST_NAME VARCHAR(25) NOT NULL,"
		            + "EMAIL_ADDRESS VARCHAR(50) NOT NULL,"
		            + "SS_NUMBER VARCHAR(12) NOT NULL,"
		            + "DATE_OF_BIRTH VARCHAR(20) NOT NULL,"
		            + "GENDER VARCHAR(1) NOT NULL,"
		            + "LOCATION VARCHAR(40) NOT NULL,"
		            + "POSITION VARCHAR(50) NOT NULL)";
				stmt.executeUpdate(create);
			}
		}
}