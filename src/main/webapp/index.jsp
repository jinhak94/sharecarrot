<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- 메인 페이지 작업영역 -->
<link rel="stylesheet" href="./resources/css/index.css" />
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100&display=swap" rel="stylesheet">
<div class="main-container">
  <div class="main-wrapper">
    <!-- 배너 시작 -->
    <!-- 이미지 슬라이더(carousel) 구현하기 -->
    <div class="banner">
      <div class="slides">
        <div class="slide">
          <img src="./resources/images/mainlogo.png" alt="배너1">
        </div>
        <div class="slide">
          <img src="./resources/images/sample_banner1.jpg" alt="배너2">
        </div>
        <div class="slide">
          <img src="./resources/images/kh-banner.PNG" alt="배너3">
        </div>
      </div>
      <div class="slide-controls">
        <button id="prev-btn">
          <
          </button>
          <button id="next-btn">
            >
          </button>
        </div>
      </div>
      <!-- 배너 끝 -->
      <!-- 검색 시작 -->
        <div class="search">
          <div style="display: flex">
            <div class="location-nav">
              <select id="select-location">
                <!-- 지역명 불러오기 , 로그인 시 회원 지역정보 우선 -->
                <option value="" disabled selected><spring:message code="index.location" text="기본값"/>
                  
                </option>
                <option value=""> <spring:message code="index.select.all" text="default text" />
                </option>
                <c:forEach items="${locationList}" var="location">
                  <sec:authorize access="isAnonymous()">
                    <option value="${location.locCode}">${location.locName}</option>
                  </sec:authorize>
                  <sec:authorize access="isAuthenticated()">
                    <option value="${location.locCode}" ${locCode eq location.locCode ? 'selected' : '' }>${location.locName}</option>
                  </sec:authorize>
                </c:forEach>
              </select>
            </div>
            <div class="category-nav">
              <select id="select-category" >
                <!-- 카테고리명 불러오기 -->
                <option value="" disabled selected><spring:message code="index.category" /></option>
                <option value=""><spring:message code="index.category.all" /></option>
                <c:forEach items="${categoryList}" end="4" var="category">
                  <option value="${category.categoryCode}">${category.categoryName}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>
        <!-- 검색 끝 -->
        <!-- 상품 리스트 시작 -->
        <!-- 조건에 맞는 상품 정보 불러오기 -->
        
        
        <div class="item-wrapper">
          <c:if test="${listLength ne 0}">
            <div class="items" id="item-list">
              <c:forEach items="${productList}" var="product">
                <div class="item" onclick="location.href='${pageContext.request.contextPath}/product/productDetail.do?productId=${product.productId}'">
                  <div class="item-photo">
                    <img src="./resources/upload/product/${product.productImgRenamed}" alt="상품이미지">
                  </div>
                  <div class="item-detail">
                    <div class="item-name">${product.productName}</div>
                    <div class="item-price">
                      <strong class="amount"><fmt:formatNumber value="${product.productPrice}" pattern="#,###" /></strong>
                      <span class="currency">원</span>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:if>
            <c:if test="${listLength eq 0}">
              <div class="no-item-list" id="item-list">
                <div class="no-item">
                  <p><spring:message code="index.noitem" /></p>
                </div>
              </div>
            </c:if>
            
          </div>
          <!-- 상품 끝 -->
          <!-- 버튼 시작-->
          <!-- 버튼 클릭 시 상품 목록 불러오기 (10개씩)-->
          <c:if test="${listLength ne 0}">
            <div class="button-more" id="button-more">
              <button type="button" class="bttn btn-more btn-large"><spring:message code="index.more.button" /></button>
            </c:if>
            <c:if test="${listLength eq 0}">
              <div class="button-nomore" id="button-more">
                <button type="button" class="bttn btn-nomore"></button>
              </c:if>
              <input type="hidden" id="btn-plus" value="2">
            </div>
            
            <!-- 버튼 끝 -->
          </div>
          <jsp:include page="/WEB-INF/views/common/history.jsp" />
        </div>
      </div>
      <script src="./resources/js/index.js"></script>
      <!-- jQuery ajax script-->
      <script>
        const list_div = document.getElementById("item-list");
        const btnMore = document.getElementById("button-more");
        
        /* 상품 목록 없을 때 함수*/
        const noItemList = () => {
          btnMore.className = "btn-nomore";
          
          const item = document.createElement("div");
          list_div.append(item);
          item.className="no-item";
          const noItemText = document.createElement("p");
          item.appendChild(noItemText);
          noItemText.innerText="등록된 상품이 없습니다.";
          
          return item;
        };
        /* 상품 목록 없을 때 함수 끝 */
        
        /* 상품 리스트 생성 함수 */
        function makeItem({productId,productName,productPrice,productImgRenamed}) {          
          const item = document.createElement("div");
          item.className = "item";
          item.addEventListener("click", function(e) {
            location.href='${pageContext.request.contextPath}/product/productDetail.do?productId=' + productId;
          })
          
          const item_photo = document.createElement("div");
          item.appendChild(item_photo);
          item_photo.className ="item-photo"
          
          const item_photo_img = document.createElement("img");
          item_photo_img.src = "./resources/upload/product/" + productImgRenamed;
          item_photo_img.alt ="상품이미지";
          item_photo.appendChild(item_photo_img);
          
          const item_detail = document.createElement("div");
          item.appendChild(item_detail);
          item_detail.className ="item-detail";
          const item_name = document.createElement("div");
          item_detail.appendChild(item_name);
          item_name.className ="item-name";
          item_name.innerText = productName;
          const item_price = document.createElement("div");
          item_detail.appendChild(item_price);
          item_price.className ="item-price"
        
        const amount = document.createElement("strong");
        amount.innerText = productPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",");
        amount.className ="amount";
        item_price.appendChild(amount);
        
        const currency = document.createElement("span");
        currency.innerText = " 원";
        currency.className = "currency"
        item_price.appendChild(currency);
        
        return item;
    }
    /* 상품 리스트 생성 함수끝*/

        const $locationOption = $("#select-location");
        const $categoryOption = $("#select-category");
        const button_more = document.querySelector(".bttn");
        let btnPlus = document.querySelector("#btn-plus").value;

        const itemList = document.getElementById("item-list");

      /* 지역 선택시 Ajax 요청 */
      $locationOption.on("change", function(){
      
      $.ajax({
        type:"POST",
        dataType:"JSON",
        data:{
          locCode : $locationOption.val(),
          category : $categoryOption.val(),
        },
        url:"${pageContext.request.contextPath}/search/mainProductList.do?${_csrf.parameterName}=${_csrf.token}",
        success: data =>{
          const list_div = document.getElementById("item-list");
          
          if(data.length > 0){
            list_div.className ="items";
            button_more.className="bttn btn-more btn-large";
            button_more.innerText="더보기";
          } else {
            list_div.className ="no-item-list";
            btnMore.className = "btn-nomore";
          }
          btnMore.className= "button-more";
          
          while ( list_div.hasChildNodes() ) { 
            list_div.removeChild( list_div.firstChild ); 
          }
          
          for (let i = 0; i < data.length; i++) 
          {          
            let item = makeItem(data[i]);
            list_div.appendChild(item);
          }
          
          if(data.length == 0){
            list_div.className ="no-item-list";
            noItemList();
          }

        },
        error: (request, status, error) =>{
          console.log(request, status, error);
        },
      })
    })
    /* 지역 선택시 Ajax 요청 끝*/         
  
    /* 카테고리 선택시 Ajax 요청 */     
    $categoryOption.on("change", function(){ 

        $.ajax({
        type:"POST",
        dataType:"JSON",
        data:{
          locCode : $locationOption.val(),
          category: $categoryOption.val()
        },
        url:"${pageContext.request.contextPath}/search/mainProductList.do?${_csrf.parameterName}=${_csrf.token}",
        success: data =>{
          
          let list_div = document.getElementById("item-list");
          list_div.className= "items";
          btnMore.className= "button-more";

          while ( list_div.hasChildNodes() ) { 
            list_div.removeChild( list_div.firstChild ); 
          }

          for (let i = 0; i < data.length; i++) 
          {          
            let item = makeItem(data[i]);
            list_div.appendChild(item);
          }

          if(data.length === 0){
            list_div.className ="no-item-list"; // 상품 없을 경우 버튼 display: none
            noItemList();
          }

        },
        error: (request, status, error) =>{
          console.log(request, status, error);
        },
      })
    })
    /* 카테고리 선택시 Ajax 요청 끝*/
    
    /* 더보기 버튼 클릭시 Ajax 요청 */  
    button_more.addEventListener("click", e =>{
      $.ajax({
        type:"POST",
        dataType:"JSON",
        data:{
          locCode : $locationOption.val(),
          category: $categoryOption.val(),
          cPage : btnPlus,
        },
        url:"${pageContext.request.contextPath}/search/mainProductList.do?${_csrf.parameterName}=${_csrf.token}",
        success: data =>{
          
          let list_div = document.getElementById("item-list");

          for (let i = 0; i < data.length; i++) 
          {          
            let item = makeItem(data[i]);
            list_div.appendChild(item);
          }
          btnPlus++;

          if(data.length === 0){
            alert("등록된 상품이 없습니다.")
            btnMore.className = "btn-nomore";
          }
        },
        error: (request, status, error) =>{
          console.log(request, status, error);
        },
      })
    })
    /* 더보기 버튼 클릭시 Ajax 요청 끝*/  
  </script>
<!-- jQuery ajax script 끝-->

<!--메인 페이지 작업영역 끝 -->
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>