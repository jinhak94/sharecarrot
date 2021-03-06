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
	                               <i class="fas fa-store" style="font-size:23px;"></i>???????????????
	                            </div>
	                            <div style="float: left; width: 11%;">
	                                ${openday}???
	                            </div>
	                            <div style="float: left; width: 22%; font-weight: bold;">
	                                <i class="fas fa-users" style="font-size:23px;"></i>???????????????
	                            </div>
	                            <div style="float: left; width: 11%;">
	                                ${shop.shopVisitCount}???
	                            </div>
	                            <div style="float: left; width: 21%; font-weight: bold;">
	                              <i class="fas fa-shopping-cart" style="font-size: 23px;"></i>????????????
	                            </div>
	                            <div style="float: left; width: 13%;">
	                                ${sellCount}???
	                            </div>
                            </div>
                        </li>
                    </ul>
                    <div id="shopMemo">
                    	${shop.shopMemo}
                    </div>
                    <!-- ???????????????/?????????????????? -->
                     <div class="mystore-btn" style="margin-top: 10px;  margin-left: 9px; " >
	                    
	                    
	                    	<a onclick="goMyManagement();"  class='btn btn-warning'>???????????????</a>
	                 	
	                    		<a onclick="goReportForm();" class='btn btn-warning'>????????????</a>
	                    	
                      </div>

                </div>
            </div>
	 </div>
            
            <br />
            <div class="col-lg-10">
               <ul class="nav nav-tabs">
				  <li class="nav-item">
				    <a class="nav-link active" data-toggle="tab" href="#myshopProduct">??????</a>
				  </li>
				  <li class="nav-item">
				    <a class="nav-link" data-toggle="tab" href="#myshopStoreReview">????????????</a>
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
           <!-- clone ??? ?????????????????? !-->
         
       
 
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
          alert('???????????? ??????????????????.');
          return;
    	</sec:authorize>
    	
    	if(loginMember == enrollMember){
	    	alert('?????? ????????? ????????? ??? ????????????.');
	    	return;
	    }
    	
    	location.href = "${pageContext.request.contextPath }/report/reportForm.do?shopId=${shop.shopId}"
	}
	
	function goMyManagement(){
		<sec:authorize access="isAnonymous()">
	       alert('???????????? ??????????????????.');
	       return;
	    </sec:authorize>

	    if(loginMember != enrollMember){
	    	alert('?????? ????????? ????????? ??? ????????????.');
	    	return;
	    }

		location.href = "${pageContext.request.contextPath }/shopmanage/shopManageBase.do"

	}
	
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>