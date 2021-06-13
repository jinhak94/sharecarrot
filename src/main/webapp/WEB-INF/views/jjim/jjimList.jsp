<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/history.jsp" />
<style>
	img{
		hegiht:50px;
		width:50px;
	}
	#jjimTable{
		width:80%;
		margin-left: 50px;
	}
</style>
<table class="table" id="jjimTable">
  <thead>
    <tr>
      <th scope="col">상품사진</th>
      <th scope="col">상품이름</th>
      <th scope="col">상품가격</th>
      <th scope="col">상품등록일</th>
      <th scope="col">#</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="jjim" items="${jjimList }" varStatus='vs'>
    	<tr>
    		<th><img src="${pageContext.request.contextPath}/resources/upload/product/${jjim.productImageList[0].productImgRenamed}"></th>
    		<th>${jjim.productName }</th>
    		<td>${jjim.productPrice }<sub>원</sub></td>
    		<td>${jjim.productRegDate }</td>
    		<td>
    		<form:form 
    			id="del-jjim-frm${vs.index}"
    			method="POST"
    			action="${pageContext.request.contextPath}/jjim/deleteJjim.do?${_csrf.parameterName}=${_csrf.token}"
    			>
    			<input type='button' class="btn btn-sm btn-danger" style="color:white;" value="찜 취소" onclick="deleteJjim(${vs.index})">
    			<input type='hidden' name='memberId' value='${jjim.memberId}'>
    			<input type='hidden' name='productId' value='${jjim.productId}'>
    		</form:form>
    		</td>
    	</tr>
    </c:forEach>
  </tbody>
</table>

<script>
function deleteJjim(index){
	if(confirm('찜을 취소하시겠습니까?')){
		$(`#del-jjim-frm\${index}`).submit();
	}
}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>