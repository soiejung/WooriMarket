<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>주문 완료</title>
</head>
<body>
	<%
		String shipping_cartId = "";
		String shipping_name = "";
		String shipping_shippingDate = "";
		String shipping_phone = "";
		String shipping_accountNumber = "";
		String shipping_addressName = "";		

		Cookie[] cookies = request.getCookies();

		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie thisCookie = cookies[i];
				String n = thisCookie.getName();
				if (n.equals("Shipping_cartId"))
					shipping_cartId = URLDecoder.decode((thisCookie.getValue()), "utf-8");		
				if (n.equals("Shipping_shippingDate"))
					shipping_shippingDate = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			}
		}
	%>
	<jsp:include page="menu.jsp" />
	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">주문 완료</h1>
		</div>
	</div>
	<div class="container">
		<h2 class="alert alert-danger">주문해주셔서 감사합니다.</h2>
		<p>주문은	<%	out.println(shipping_shippingDate);	%>에 주문되었습니다! !	
		<p>주문번호 :	<%	out.println(shipping_cartId);	%>
	</div>
	<div class="container">
		<p><a href="./products.jsp" class="btn btn-secondary"> &laquo; 상품 목록</a>
	</div>
</body>
</html>
<%

/*******************************************************************/
	//session.invalidate();

	String cartId = request.getParameter("cartId");
	PreparedStatement pstmt = null;	
	ResultSet rs = null;
	String sql = "DELETE FROM product where p_id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1,cartId);
	pstmt.executeUpdate();
	
	PreparedStatement pstmt1 = null;
	String d_sql = "DROP table "+cartId+"_purchase";
	pstmt1 = conn.prepareStatement(d_sql);
	pstmt1.executeUpdate();

	if (pstmt != null)
		pstmt.close();
	
	if (pstmt1 != null)
		pstmt1.close();
	
	if (conn != null)
		conn.close();
	
/*******************************************************************/

	for (int i = 0; i < cookies.length; i++) {
		Cookie thisCookie = cookies[i];
		String n = thisCookie.getName();

		if (n.equals("Shipping_cartId"))
			thisCookie.setMaxAge(0);
		if (n.equals("Shipping_name"))
			thisCookie.setMaxAge(0);
		if (n.equals("Shipping_shippingDate"))
			thisCookie.setMaxAge(0);
		if (n.equals("Shipping_phone"))
			thisCookie.setMaxAge(0);
		if (n.equals("Shipping_accountNumber"))
			thisCookie.setMaxAge(0);
		if (n.equals("Shipping_addressName"))
			thisCookie.setMaxAge(0);
		
		response.addCookie(thisCookie);
	}
%>
