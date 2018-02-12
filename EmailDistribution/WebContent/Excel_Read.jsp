<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"  
   pageEncoding="ISO-8859-1"%>  
 <!DOCTYPE html>  
 <%@ page import ="java.util.Date" %>  
 <%@ page import ="java.io.*" %>  
 <%@ page import ="java.io.FileNotFoundException" %>  
 <%@ page import ="java.io.IOException" %>  
 <%@ page import ="java.util.Iterator" %>  
 <%@ page import ="java.util.ArrayList" %>  
 <%-- Apache POI Libraries --%>  
 <%@ page import ="org.apache.poi.hssf.usermodel.HSSFCell" %>  
 <%@ page import ="org.apache.poi.hssf.usermodel.HSSFRow" %>  
 <%@ page import ="org.apache.poi.hssf.usermodel.HSSFSheet" %>  
 <%@ page import ="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>  
 <%@ page import ="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>  
 <html>  
 <head>  
 <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">  
 <title>4155 Project: HR Email Distribution List Generator</title>  
 </head>  
 <body>  
 <jsp:useBean id="connection" class="Database.Database_Connection" scope="page">  
   <jsp:setProperty name="connection" property="*"/>  
 </jsp:useBean>  
 <%!    
 Connection conn;  
 PreparedStatement ps = null; 
 /* ArrayList to hold ArrayList of cells */
 public static ArrayList readExcelFile(String fileName) {  
	// To do: Define  
   	ArrayList cellArrayList = new ArrayList();  
   	try {  
		/* Creating Input Stream */  
    	FileInputStream myInput = new FileInputStream(fileName);  
   		/* Create a POIFSFileSystem object */  
   		POIFSFileSystem myFileSystem = new POIFSFileSystem(myInput);  
   		/* Create a HSSF workbook using the File System */  
    	HSSFWorkbook myWorkBook = new HSSFWorkbook(myFileSystem);  
    	/* Get the first sheet from workbook */  
   		HSSFSheet mySheet = myWorkBook.getSheetAt(0);  
   		/* Iterate through the cells */  
    	Iterator rowIter = mySheet.rowIterator();  
    	while(rowIter.hasNext()) {  
      		HSSFRow myRow = (HSSFRow) rowIter.next();  
      		Iterator cellIter = myRow.cellIterator();  
      		ArrayList storeArrayList=new ArrayList();  
      		while(cellIter.hasNext()){  
        		HSSFCell myCell = (HSSFCell) cellIter.next();  
        		storeArrayList.add(myCell);  
      		}  
      		cellArrayList.add(storeArrayList);  
    	}  
	}
   	catch (Exception e){e.printStackTrace(); }  
   
   	return cellArrayList;  
 }%>  
 
 <%  
	// Excel fileName to read and store
	String fileName = "testExcel.xls";  
	// Read an Excel File and Store in a ArrayList  
	ArrayList excelData = readExcelFile(fileName);  
	// Print the data read  
	//printCellDataToConsole(dataHolder);  
 
 	conn = connection.getConn(); 
 	// Insert PreparedStatement query into table
 	String query = "insert into Employees values (?,?,?)";  
 	ps = conn.prepareStatement(query);  
	
 	int count = 0;  
	ArrayList storeArrayList = null;  
	// Insert data in query for database entry
	for (int i=1;i < excelData.size(); i++) {  
		storeArrayList=(ArrayList)excelData.get(i);  
		ps.setString(1, ((HSSFCell)storeArrayList.get(0)).toString());  
     	ps.setString(2, ((HSSFCell)storeArrayList.get(1)).toString());  
     	ps.setString(3, ((HSSFCell)storeArrayList.get(2)).toString());  
    	count = ps.executeUpdate();  
     	System.out.print(((HSSFCell)storeArrayList.get(2)).toString() + "t");  
     }  
	
	// Ensure data entry 
   	if(count>0) {
   		%>  
        Data inserted into Employees table from Excel  
           <table>  
             <tr>  
               <th>Header 1</th>  
               <th>Header 2</th>  
               <th>Header 3</th>  
             </tr>  
     	<% for (int i=1;i < excelData.size(); i++) {  
   			storeArrayList=(ArrayList)excelData.get(i);%>  
   			<tr>  
     			<td><%=((HSSFCell)storeArrayList.get(0)).toString() %></td>  
     			<td><%=((HSSFCell)storeArrayList.get(1)).toString() %></td>  
     			<td><%=((HSSFCell)storeArrayList.get(2)).toString() %></td>  
   			</tr>  
     	<%
     	}  
    } else { %>
    	<center> Data Insertion Error </center>  
   	<% }  %>  
    
    </table>  
 </body>  
 </html>  