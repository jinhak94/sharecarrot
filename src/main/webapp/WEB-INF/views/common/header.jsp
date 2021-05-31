<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShareCarrot</title>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>

    <!-- bootstrap js: jquery load 이후에 작성할것.-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <!-- bootstrap css -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0" crossorigin="anonymous">
   <!--  shortcut icon-->
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" />	
   <style>
        #header-nav {
            background-color: rgb(247, 247, 247);
            border-bottom: 1px solid rgb(209, 209, 209);
            padding-top: 10px;
        }
        header{
        	position: fixed;
        	top : 0;
        	left : 0;
        	right : 0;
        	z-index: 99;
        }
    </style>
<script>

function enterkey() {
    if (window.event.keyCode == 13) {
    	search_button_click();
    }
}

function search_button_click() {
    // 검색 버튼을 눌렀을때의 기능 구현
	var searchkeyword = $('#headersearch').val();
    location.href = "${pageContext.request.contextPath}/product/headerSearch.do?searchkeyword="+searchkeyword;
}

function myshop_head_click(){

	 $.ajax({
	        type:"GET",
	        url:"${pageContext.request.contextPath}/shop/myshopHead.do",
	        success:function(data){
				console.log(data);
	        	location.href="${pageContext.request.contextPath}/shop/myshop.do?shopId=" + data;

	        }                
	});
}

</script>
<c:if test="${not empty msg}">
<script>
	alert("${msg}");
</script>
</c:if>
</head>
<body>
    <header>
    <ul class="nav nav-pills flex-column flex-sm-row mb-3" id="header-nav">
    
    <!-- LOGO -->
        <li class="nav-item mb-2">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        <a href="${pageContext.request.contextPath}">
	            <img src="${pageContext.request.contextPath}/resources/images/mainlogo.png" style="max-height: 50px;">
	        </a>
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </li>
        
	<!-- 검색바 -->
        <li class="nav-item flex-sm-fill">
            <div class="input-group">
                <input type="text" onkeyup="enterkey();" id="headersearch" name="headersearch" class="form-control" placeholder="지역 혹은 물품을 검색해주세요" aria-label="Recipient's username" aria-describedby="button-addon2">
                <button class="btn btn-outline-success" onclick="search_button_click();" id="searchbutton" name="searchbutton" type="button" id="button-addon2">검색</button>
            </div>
        </li>
        
	<!-- 버튼그룹 -->
        <li class="nav-item">
            <div class="btn-group" role="group" aria-label="Button group with nested dropdown">
            
		<!-- 비회원 화면 -->
   				<sec:authorize access="isAnonymous()">
	                <button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do';">로그인</button>
	                <button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/member/memberEnroll.do';">회원가입</button>
                </sec:authorize>
		<!-- 로그인시 화면 -->
                <sec:authorize access="isAuthenticated()">
               		<form:form class="d-inline" action="${pageContext.request.contextPath}/member/memberLogout.do" method="POST">
					    <button class="btn btn-light my-2 my-sm-0" type="submit">로그아웃</button>
	                </form:form>
	                <button type="button" class="btn btn-light" onclick=" myshop_head_click();">내상점</button>
	                <button type="button" class="btn btn-light">판매하기</button>
                </sec:authorize>
                
		<!-- 카테고리 DROPDOWN -->
                <div class="btn-group" role="group">
                  <button id="btnGroupDrop1" type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"></button>
                  <ul class="dropdown-menu" aria-labelledby="btnGroupDrop1">
                    <li><a class="dropdown-item" href="#">상품카테고리</a></li>
                    <%--분기처리 --%>
                    <sec:authorize access="isAnonymous()">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/boardList.do">동네생활게시판</a></li>
                    </sec:authorize>
                    <sec:authorize access="isAuthenticated()">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/boardList.do?memberId=<sec:authentication property='principal.username'/>">동네생활게시판</a></li>
                    </sec:authorize>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/reportList.do">신고게시판</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/notice/noticeList.do">공지사항</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/chat/chattingManagement.do">채팅관리</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/memberDetail.do">계정설정</a></li>
                  </ul>
                </div>
              </div>
        </li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </ul>
    </header>
    
    <!-- 공백 -->
    <br/><br/><br/>
<section>