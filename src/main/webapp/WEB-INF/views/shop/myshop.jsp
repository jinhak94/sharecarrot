<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/history.jsp" />
  
<!--Custom CSS-->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mystore.css" type="text/css" />
<!--jquery-->
<!-- <script src="http://code.jquery.com/jquery-latest.min.js"></script>  -->
<!--icon -->
 <script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
 <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>

<section id="my-store-container" class="ms_container">
        <br /><br />
    <div class="container">
            <div class="row">
                <div class="col-lg-3" style="height: 220px; border: 2px solid #FA8440;">
	                <c:choose>
		                <c:when test="${empty profile} == null">
		                	<div><img id="profileImg" src='${pageContext.request.contextPath}/resources/images/noProfile.png' style="width: 112%;; height: 217px; margin-left: -12px;"></div>
		                </c:when>
		                <c:otherwise>
		                    <div><img id="profileImg" src='${pageContext.request.contextPath}/resources/upload/member/${profile}' style="width: 112%;; height: 217px; margin-left: -12px;"></div>
		                </c:otherwise>
	                </c:choose>
                </div>
                <div class="col-lg-7" style="width: 590px; height: 220px;">
                    <ul class="amount">
                        <li>
                            <div style="font-size: 36px; font-weight: bold;">
                                ${shop.memberId}
                            </div>
                            <div style="margin-top: 5px;">
	                            <div style="float: left; width: 22%; font-weight: bold;">
	                               <i class="fas fa-store" style="font-size:23px;"></i>상점오픈일
	                            </div>
	                            <div style="float: left; width: 11%;">
	                                ${openday}일
	                            </div>
	                            <div style="float: left; width: 22%; font-weight: bold;">
	                                <i class="fas fa-users" style="font-size:23px;"></i>상점방문수
	                            </div>
	                            <div style="float: left; width: 11%;">
	                                ${shop.shopVisitCount}명
	                            </div>
	                            <div style="float: left; width: 21%; font-weight: bold;">
	                              <i class="fas fa-shopping-cart" style="font-size: 23px;"></i>상품판매
	                            </div>
	                            <div style="float: left; width: 13%;">
	                                ${sellCount}개
	                            </div>
                            </div>
                        </li>
                    </ul>
                    <div id="shopMemo">
                    	${shop.shopMemo}
                    </div>
                    <!-- 내상점관리/신고하기버튼 -->
                     <div class="mystore-btn" style="margin-top: 10px;  margin-left: 9px; " >
	                    
	                    
	                    	<a onclick="goMyManagement();"  class='btn btn-warning'>내상점관리</a>
	                 	
	                    		<a onclick="goReportForm();" class='btn btn-warning'>신고하기</a>
	                    	
                      </div>

                </div>
            </div>
	 </div>
            
            <br />
            <div class="col-lg-10">
               <ul class="nav nav-tabs">
				  <li class="nav-item">
				    <a class="nav-link active" data-toggle="tab" href="#myshopProduct">상품</a>
				  </li>
				  <li class="nav-item">
				    <a class="nav-link" data-toggle="tab" href="#myshopStoreReview">상점후기</a>
				  </li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane fade show active" id="myshopProduct">
						<jsp:include page="myshopProductList.jsp"></jsp:include>
					</div>
					<div class="tab-pane fade" id="myshopStoreReview">
						<jsp:include page="myshopReviewList.jsp"></jsp:include>
					</div>
				</div>			

            </div>
           <!-- clone 후 수정중입니다 !-->
         
       
 
</section>
<script>
<sec:authorize access='isAuthenticated()'>
const loginMember = "<sec:authentication property='principal.username'/>";
const enrollMember = '${memberId}';
</sec:authorize>
	const tempParam = {
	      shopId: "${shop.shopId}",
	}
	
	function goReportForm(){
		<sec:authorize access="isAnonymous()">
          alert('로그인후 이용해주세요.');
          return;
    	</sec:authorize>
    	
    	if(loginMember == enrollMember){
	    	alert('상점 주인은 이용할 수 없습니다.');
	    	return;
	    }
    	
    	location.href = "${pageContext.request.contextPath }/report/reportForm.do?shopId=${shop.shopId}"
	}
	
	function goMyManagement(){
		<sec:authorize access="isAnonymous()">
	       alert('로그인후 이용해주세요.');
	       return;
	    </sec:authorize>

	    if(loginMember != enrollMember){
	    	alert('상점 주인만 이용할 수 있습니다.');
	    	return;
	    }

		location.href = "${pageContext.request.contextPath }/shopmanage/shopManageBase.do"

	}
	
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>