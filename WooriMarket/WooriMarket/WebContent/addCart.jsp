<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%@ include file="dbconn.jsp" %>
<%
    String id = request.getParameter("id");
	String loginId = (String) session.getAttribute("sessionId");
    if (id == null || id.trim().equals("")) {
        response.sendRedirect("products.jsp");
        return;
    }

    PreparedStatement pstmt1 = null;

    ResultSet rs = null;
    
    String select_sql = "select * from product where p_id = ?";
    pstmt1 = conn.prepareStatement(select_sql);
    pstmt1.setString(1, id);
    rs = pstmt1.executeQuery();
    
    String cartId = session.getId();
    String userId = (String)session.getAttribute("sessionId");
    Integer price;
    Long stock;
    String productId;
    String productName;
    String productUnitPrice;
    String productStock;
    
    if (rs.next()) {
        productId = rs.getString("p_id");
        productName = rs.getString("p_name");
        productUnitPrice = rs.getString("p_unitPrice");
		productStock = rs.getString("p_unitsInStock");
		
        if (productUnitPrice.isEmpty())
            price = 0;
        else
            price = Integer.valueOf(productUnitPrice);
        
        if (productStock.isEmpty()){
        	stock = 0L;
        }
        else{
        	stock = Long.valueOf(productStock);
        }

        PreparedStatement parent = null;
    	PreparedStatement ipstmt = null;
        String p_sql = "UPDATE product SET p_name=?, p_unitPrice=?, p_description=?, p_manufacturer=?, p_category=?, p_unitsInStock=?, p_condition=?, p_fileName=? WHERE p_id=?";
        
		parent = conn.prepareStatement(p_sql);
		parent.setString(1, productName);
		parent.setInt(2, price);
		parent.setString(3, rs.getString("p_description"));
		parent.setString(4, rs.getString("p_manufacturer"));
		parent.setString(5, rs.getString("p_category"));
		parent.setLong(6, stock+1);
		parent.setString(7, rs.getString("p_condition"));
		parent.setString(8, rs.getString("p_fileName"));
		parent.setString(9, productId);	
		parent.executeUpdate();		
		
		String check = "Select count(*) from "+productId+"_purchase Where id = ?";
		PreparedStatement cpstmt = conn.prepareStatement(check);
		cpstmt.setString(1,userId);
		
		ResultSet crs = cpstmt.executeQuery();
		if(crs.next()){
			int count = crs.getInt(1);
			boolean exists = count > 0;

			if (exists){
				String s_sql = "Select * FROM " + productId+"_purchase Where id = ?";
				
				PreparedStatement stockstmt = null;
				ResultSet stockrs = null;
				
				stockstmt = conn.prepareStatement(s_sql);
				stockstmt.setString(1, userId);
				stockrs = stockstmt.executeQuery();
				
				if(stockrs.next()){
					String IdStock = stockrs.getString("p_unitsInStock");
					
					Long stock1 = Long.valueOf(IdStock);
					
					PreparedStatement pstmt = null;	
					
					String sql = "UPDATE "
							+ productId +"_purchase SET "
							+ "p_unitsInStock=?";
			
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setLong(1, stock1+1);
					pstmt.executeUpdate();
			        if (pstmt != null)
			        	pstmt.close();
				}
				
				
		        if (conn != null)
		            conn.close();
		        
		        if (parent != null)
		        	parent.close();
		        if (stockstmt != null)
		        	stockstmt.close();
				
		        
		        rs.close();
		        stockrs.close();
			}else{
				
				String i_sql = "insert into "
						+ productId+"_purchase"
						+ " values(?,?)";
				ipstmt=conn.prepareStatement(i_sql);
				ipstmt.setString(1,loginId);
				ipstmt.setLong(2,1);
				ipstmt.executeUpdate();
				
				if (ipstmt != null)
					ipstmt.close();
			}
		}

        response.sendRedirect("product.jsp?id=" + productId);
    /*********************************************************************/
        
    }
%>
