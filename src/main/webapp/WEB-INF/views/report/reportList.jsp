<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
<jsp:param value="신고게시판" name="title"/>
</jsp:include>

<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<style>
 .searchlist{
 	margin-left: 1000px;
 }
</style>
<script>
/* function goReportForm(){
	location.href = "${pageContext.request.contextPath}/report/reportForm.do";
} */

$(() => {
	//상세보기페이지
	$("tr[data-no]").click(e => {
		var $tr = $(e.target).parent();
		var no = $tr.data("no");
		
		location.href = `${pageContext.request.contextPath}/report/reportDetail.do?no=\${no}`;
	});
	
	//검색버튼 클릭했을때
	$(searchDateButton).click(e =>{
		//검색창
		const searchDate = $("#searchDate");
		//사용자가 입력한값
		const searchKeyword = searchDate.val();
		//검색내용이 비어있다면 취소
		if(!searchKeyword){
			alert('검색어를 입력해주세요.');
			return;
		}
		else {
			location.href=`${pageContext.request.contextPath}/report/reportList.do?searchKeyword=\${searchKeyword}`;
		}	
	});
	
});
</script>
<section id="board-container" class="container">
	<h1>신고 합니다</h1>
	<div class="searchlist">
	<input type="date"  id="searchDate" />
	<input type="button"  value="검색" id="searchDateButton" />
	</div>
	<table id="tbl-board" class="table table-bordered" style="vertical-align:middle">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>신고자</th>
			<th>피신고자</th>
			<th>신고일</th>
			<th>처리 결과</th> 
			<th>처리 날짜</th>
		</tr>
		<c:forEach items="${reportList}" var="report">
		<tr data-no="${report.reportNo}">
			<td>${report.reportNo}</td>
			<td>${report.reportTitle}</td>
			<td>${report.memberId}</td>
			<td>${report.shopId}</td>
			<td><fmt:formatDate value="${report.reportDate}" pattern="yy/MM/dd"/></td>
			<td>${report.reportProcessYn}</td>
			<td><fmt:formatDate value="${report.reportProcessingDate}" pattern="yy/MM/dd"/></td>
			
		</tr>
		</c:forEach>
		
	</table>
	${pageBar}
	<!-- <input type="button" value="신고하기" id="btn-add" class="btn btn-outline-success" onclick="goReportForm();"/> -->
</section> 

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
