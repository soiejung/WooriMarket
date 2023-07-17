<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Product"%>
<%@ page import="dao.ProductRepository"%>
<%@ include file="dbconn.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("cartId");
	Cookie cartId = new Cookie("Shipping_cartId", URLEncoder.encode(request.getParameter("cartId"), "utf-8"));
	Cookie name = new Cookie("Shipping_name", URLEncoder.encode(request.getParameter("name"), "utf-8"));
	Cookie phone = new Cookie("Shipping_phone", URLEncoder.encode(request.getParameter("phone"), "utf-8"));
	Cookie shippingDate = new Cookie("Shipping_shippingDate", URLEncoder.encode(request.getParameter("shippingDate"), "utf-8"));
	Cookie accountNumber = new Cookie("Shipping_accountNumber",	URLEncoder.encode(request.getParameter("account"), "utf-8"));
	Cookie addressName = new Cookie("Shipping_addressName", URLEncoder.encode(request.getParameter("addressName"), "utf-8"));

	cartId.setMaxAge(365 * 24 * 60 * 60);
	name.setMaxAge(365 * 24 * 60 * 60);
	phone.setMaxAge(365 * 24 * 60 * 60);
	accountNumber.setMaxAge(365 * 24 * 60 * 60);
	addressName.setMaxAge(365 * 24 * 60 * 60);

	response.addCookie(cartId);
	response.addCookie(name);
	response.addCookie(shippingDate);
	response.addCookie(phone);
	response.addCookie(accountNumber);
	response.addCookie(addressName);

	
	response.sendRedirect("orderConfirmation.jsp?cartId="+id);
%>
