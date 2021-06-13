<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShareCarrot</title>
    
    <!-- tostr css 라이브러리 -->
    <link rel="stylesheet" type="text/css" href="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" />
	<!-- Jquery Cdn -->
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>

    <!-- bootstrap js: jquery load 이후에 작성할것.-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <!-- bootstrap css -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0" crossorigin="anonymous">
   <!--  shortcut icon-->
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" />	
   <!-- sockJs Cdn -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js" integrity="sha512-hsqWiVBsPC5Hz9/hy5uQX6W6rEtBjtI8vyOAR4LAFpZAbQjJ43uIdmKsA7baQjM318sf8BBqrMkcWsfSsaWCNg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<!-- stompJs Cdn -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <!-- toast Cdn -->
	<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

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
        .toast{
        	background-color: blue !important;
        }
				li.head-nav:not(:nth-child(1)) {
					margin-top : 6px;
				}
				.form-logout{
					margin-bottom: 0px;
				}
    </style>
</head>
<body>
    <header>
    <ul class="nav nav-pills flex-column flex-sm-row mb-3" id="header-nav">
    
    <!-- LOGO -->
        <li class="nav-item head-nav mb-2">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        <a href="${pageContext.request.contextPath}">
	            <img src="${pageContext.request.contextPath}/resources/images/mainlogo.png" style="max-height: 50px;">
	        </a>
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </li>
        
	<!-- 검색바 -->
        <li class="nav-item head-nav flex-sm-fill">
            <div class="input-group">
                <div class="dropdown">
				  <button class="btn btn-outline-success dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
				    <spring:message code="header.nav.Catagory" />
				  </button>
				  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
				  <c:forEach var="category" items="${categoryList}" varStatus='vs'>
				  	<c:if test='${!vs.last}'>
				    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/product/headerSearch.do?category=${category.categoryCode}">${category.categoryName }</a></li>
				   	</c:if>
				   </c:forEach>
				  </ul>
				</div>
                <input type="text" onkeyup="enterkey();" id="headersearch" name="headersearch" class="form-control" placeholder="지역 혹은 물품을 검색해주세요" aria-label="Recipient's username" aria-describedby="button-addon2">
                <button class="btn btn-outline-success" onclick="search_button_click();" id="searchbutton" name="searchbutton" type="button" id="button-addon2"><spring:message code="header.search" /></button>
            </div>
        </li>
        
	<!-- 버튼그룹 -->
        <li class="nav-item head-nav">
            <div class="btn-group" role="group" aria-label="Button group with nested dropdown">
            
		<!-- 비회원 화면 -->
   				<sec:authorize access="isAnonymous()">
	                <button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do';"><spring:message code="header.login" /></button>
	                <button type="button" class="btn btn-light" onclick="location.href='${pageContext.request.contextPath}/member/memberEnroll.do';"><spring:message code="header.signup" /></button>
                </sec:authorize>
		<!-- 로그인시 화면 -->
                <sec:authorize access="isAuthenticated()">
               		<form:form class="d-inline form-logout" action="${pageContext.request.contextPath}/member/memberLogout.do" method="POST">
					    <button class="btn btn-light my-2 my-sm-0" type="submit"><spring:message code="header.logout" /></button>
	                </form:form>
	                <button type="button" class="btn btn-light" onclick=" myshop_head_click();"><spring:message code="header.myshop" /></button>
	                <button type="button" class="btn btn-light"><spring:message code="header.sell" /></button>
                </sec:authorize>
                
		<!-- 카테고리 DROPDOWN -->
                <div class="btn-group" role="group">
                  <button id="btnGroupDrop1" type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"></button>
                  <ul class="dropdown-menu" aria-labelledby="btnGroupDrop1">
<!--                     <li> -->
<%--                     	<a class="dropdown-item" href="#"><spring:message code="header.nav.Catagory" /></a> --%>
<!--                     </li> -->
                    <%--분기처리 --%>
                    <sec:authorize access="isAnonymous()">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/boardList.do"><spring:message code="header.nav.board" /></a></li>
                    </sec:authorize>
                    <sec:authorize access="isAuthenticated()">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/boardList.do"><spring:message code="header.nav.board" /></a></li>
                    </sec:authorize>
 					<sec:authorize access="hasRole('ROLE_ADMIN')">
	                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/reportList.do"><spring:message code="header.nav.report" /></a></li>
                    </sec:authorize>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/notice/noticeList.do"><spring:message code="header.nav.notice" /></a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/chat/chattingManagement.do"><spring:message code="header.nav.chat" /></a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/memberDetail.do"><spring:message code="header.nav.setting" /></a></li>
                  </ul>
                </div>
              </div>
        </li>
      </ul>


    </header>
    <!-- 공백 -->
    <br/><br/><br/>

<script>
toastr.options = {
	"positionClass": "toast-bottom-right",
}

<sec:authorize access="isAuthenticated()">
//웹소켓 연결 로그인을 한경우에만
const ws = new SockJS("${pageContext.request.contextPath}/stomp");
const stompClient = Stomp.over(ws);
const subArr = [];

const loginMemberId = "<sec:authentication property='principal.username'/>";

stompClient.connect({}, (frame) => { //sock.connect
	console.log(frame);
}); //sock.connect

//알람 기능
var alarmId = null;

setAlarm();
function setAlarm(){
	console.log("set Alarm");
	alarmId = setInterval(getRoomNo, 5000);
}
function getRoomNo(){ //주기적으로 참여한 채팅방의 번호를 불러옴
	$.ajax({
		url : "${pageContext.request.contextPath}/chat/selectRoomNo.do?${_csrf.parameterName}=${_csrf.token}",
		data : {
			loginMemberId
		},
		type : 'GET',
		success : function(data){
			
			$(data).each(function(index, item){
				if(subArr.includes(item)){ // subArr에 해당 방번호가 이미 추가되어있다면
					return;
				}
				else { // 새로개설된 채팅방이 있는경우
					subArr.push(item);
					stompClient.subscribe(`/chattingRoom/\${item}`, (frame) => {
						const msgObj = JSON.parse(frame.body);
						console.log(msgObj);
						
						//메시지 작업처리
						if(loginMemberId != msgObj.roomBuyerId){
							toastr.info(msgObj.roomBuyerId, msgObj.messageText, {timeOut: 50000});
						}
						toastr.options.onclick = function() {
							chatting_popup(msgObj.roomBuyerId, loginMemberId);
						}
					})					
				}
			});
		},
		error : function(request,status, error){
			console.log(request,status, error);
		}
	});
}

function chatting_popup(roomBuyerId, roomSellerId){
	var url = "${pageContext.request.contextPath}/chat/chattingRoom.do?roomBuyerId=" + roomBuyerId + "&roomSellerId="+roomSellerId;
	var popupWidth = 600;
	var popupHeight = 420;
	var popupX = (window.screen.width / 2) - (popupWidth / 2);
	// 만들 팝업창 width 크기의 1/2 만큼 보정값으로 빼주었음
	var popupY= (window.screen.height / 2) - (popupHeight / 2) - 50;
	// 만들 팝업창 height 크기의 1/2 만큼 보정값으로 빼주었음
	window.open(url, "chat", "width=" + popupWidth + ", height=" + popupHeight + ", left="+popupX+", top=" + popupY).focus();
}

//알람 기능 FINISH
</sec:authorize>

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
	        	location.href="${pageContext.request.contextPath}/shop/myshop.do?shopId=" + data;

	        }                
	});
}

<c:if test="${not empty msg}">
	alert("${msg}");
</c:if>
</script>
    
<section>