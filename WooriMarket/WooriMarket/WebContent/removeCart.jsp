<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%@ include file="dbconn.jsp" %>
<%
	String id = request.getParameter("id");
	if (id == null || id.trim().equals("")) {
		response.sendRedirect("products.jsp");
		return;
	}

	ProductRepository dao = ProductRepository.getInstance();
	
	Product product = dao.getProductById(id);
	if (product == null) {
		response.sendRedirect("exceptionNoProductId.jsp");
	}
	
/*******************************************************************/

	PreparedStatement pstmt1 = null;
	String d_sql = "DELETE FROM "+id+"_purchase";
	pstmt1 = conn.prepareStatement(d_sql);
	pstmt1.executeUpdate();
	
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	String sql = "select * from product where p_id = ?";
	pstmt2 = conn.prepareStatement(sql);
	pstmt2.setString(1, id);
	rs = pstmt2.executeQuery();
	
	if (rs.next()) {		
		
		sql = "UPDATE product SET p_unitsInStock=?";	
		pstmt2 = conn.prepareStatement(sql);
		pstmt2.setInt(1, 0);
		pstmt2.executeUpdate();
	}
	
	
	if (pstmt1 != null)
		pstmt1.close();
	
	if (conn != null)
		conn.close();
/*******************************************************************/	
	response.sendRedirect("cart.jsp");
%>
