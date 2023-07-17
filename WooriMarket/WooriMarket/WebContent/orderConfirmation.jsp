<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%@ include file="dbconn.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cartId = request.getParameter("cartId");

	//String cartId = session.getId();

	String shipping_cartId = "";
	String shipping_name = "";
	String shipping_shippingDate = "";
	String shipping_phone = "";
	String shipping_accountNumber = "";
	String shipping_addressName = "";
	
	Cookie[] cookies = request.getCookies();
	String productStock = "";;
	String productUnitPrice = "";
	Integer price = 0;
	Long stock = 0L;
	Long total = 0L;
	
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			Cookie thisCookie = cookies[i];
			String n = thisCookie.getName();
			if (n.equals("Shipping_cartId"))
				shipping_cartId = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			if (n.equals("Shipping_name"))
				shipping_name = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			if (n.equals("Shipping_shippingDate"))
				shipping_shippingDate = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			if (n.equals("Shipping_phone"))
				shipping_phone = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			if (n.equals("Shipping_accountNumber"))
				shipping_accountNumber = URLDecoder.decode((thisCookie.getValue()), "utf-8");
			if (n.equals("Shipping_addressName"))
				shipping_addressName = URLDecoder.decode((thisCookie.getValue()), "utf-8");
		}
	}
%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>주문 정보</title>
</head>
<body>
	<jsp:include page="menu.jsp" />
	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">주문 정보</h1>
		</div>
	</div>
	<div class="container col-8 alert alert-info">
		<div class="text-center ">
			<h1>영수증</h1>
		</div>
		<div class="row justify-content-between">
			<div class="col-4" align="left">
				주문자 성명 : <% out.println(shipping_name); %><br> 
				계좌 번호 : <% 	out.println(shipping_accountNumber);%><br> 
				주소 : <%	out.println(shipping_addressName);%><br>
			</div>
			<div class="col-4" align="right">
				<p>	<em>배송일: <% out.println(shipping_shippingDate);	%></em>
			</div>
		</div>
		<div>
			<table class="table table-hover">			
			<tr>
				<th class="text-center">상품</th>
				<th class="text-center">user</th>
				<th class="text-center">#</th>
				<th class="text-center">가격</th>
				<th class="text-center">총 가격</th>
			</tr>
			<%
			/*******************************************************************/
				PreparedStatement stmt = null;
				ResultSet rs = null;
				String sql = "SELECT * FROM "
						+cartId+"_purchase";
				
				stmt = conn.prepareStatement(sql);
				rs = stmt.executeQuery();
				
				PreparedStatement pstmt = null;
				ResultSet prs = null;
				String s_sql = "SELECT * FROM product where p_id = ?";
				pstmt = conn.prepareStatement(s_sql);
				pstmt.setString(1,cartId);
				prs = pstmt.executeQuery();
				if (prs.next()) {
					productUnitPrice = prs.getString("p_unitPrice");
				}
				
				
			%>
			<%
			
				while(rs.next()){
					
					productStock = rs.getString("p_unitsInStock");
					price = Integer.valueOf(productUnitPrice);
					stock = Long.valueOf(productStock);
					total += price * stock;

			%>
			<tr>
				<td class="text-center"><em><%=prs.getString("p_name")%> </em></td>
				<td class="text-center"><em><%=rs.getString("id") %></em>
				<td class="text-center"><%=stock%></td>
				<td class="text-center"><%=price%>원</td>
				<td class="text-center"><%=stock*price%>원</td>
			</tr>
				
			<%
				}
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
				
			/*********************************************************************/
			%>
			<tr>
				<td> </td>
				<td> </td>
				<td class="text-right">	<strong>총액: </strong></td>
				<td class="text-center text-danger"><strong><%=total%> </strong></td>
			</tr>
			</table>			
				<a href="./thankCustomer.jsp?cartId=<%=cartId %>"  class="btn btn-success" role="button"> 주문 완료 </a>
				<a href="./checkOutCancelled.jsp" class="btn btn-secondary"	role="button"> 취소 </a>			
		</div>
	</div>	
</body>
</html>
