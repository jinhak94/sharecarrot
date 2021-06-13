<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>	
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>
	.history-box{
    position: fixed;
    top: 102px;
    right: calc(50% - 500px);
    z-index: 20;
	}
    .history-box-container{
      width: 90px;
    }
    /* 공통부분 CSS 시작 */
    .jjim,
    .recent{
      padding: 10px;
      width: 100%;
      border: 1px solid rgb(204, 204, 204);
      background: rgb(255, 255, 255);
      margin-bottom: 6px;
    }
    .jjim{
      border-color: rgb(102, 102, 102);
      height: 50px;
      padding: 3px 3px;
    }
    .top{
      margin-bottom: 0px;
      padding: 0px;
      border-color: rgb(229, 229, 229);
    }
    
    .jjim-title,
    .recent-title{
      font-size: 12px;
      font-weight: 600;
      color: rgb(102, 102, 102);
      text-align: center;
      margin-bottom: 8px;
    }
    /* 공통부분 CSS 끝 */
    /*찜한 상품 CSS 시작*/
    .jjim-count-wrapper{
      display: flex;
      -webkit-box-pack: center;
      justify-content: center;
      height: 25%;
    }
    .jjim-count{
      display: flex;
      -webkit-box-align: center;
      align-items: center;
      font-size: 12px;
      color: black;
      font-weight: 600;
      cursor:pointer;
    }
    /*찜한 상품 CSS 끝*/
    /*최근 본 상품 CSS 시작*/
    .recent-title{
      letter-spacing: -1px;
    }
    .recent-dot{
      display: flex;
      -webkit-box-pack: center;
      justify-content: center;
      font-size: 12px;
      color: rgb(247, 0, 0);
      font-weight: 600;
      border-bottom: 2px dotted rgb(136, 136, 136);
    }

    .recent-content{
      height: 150px;
      display: flex;
      flex-direction: column;
      -webkit-box-align: center;
      align-items: center;
      -webkit-box-pack: center;
      justify-content: center;
      color: rgb(204, 204, 204);
      font-size: 12px;
      text-align: center;
    }

    .recent-img {
      width: 70px;
      height: 70px;
      position: relative;
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
      color: black;
      margin: 5px 0;
    }
    .recent-img:hover{
      cursor: pointer;
    }

    .recent-detail-area {
      position: absolute;
      width: 200px;
      height: 100%;
      border: 1px solid black;
      right: 0%;
      display: none;
    }
    .recent-img:hover .recent-detail-area {
      display: block;
    }
    .recent-detail-div {
      height: 100%;
      width: calc(100% - 70px);
      background-color: white;
      text-align: left;
    }
    .recent-detail-name {
        font-size: 0.7rem;
        font-weight: bold;
        padding: 5px 10px 0px 10px;
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
    }
    .recent-detail-price {
        font-weight: bold;
        padding: 0px 10px 3px 10px;
    }

    /*최근 본 상품 CSS 끝*/
    /* TOP 버튼 CSS 시작 */
    .top-btn{
      display: flex;
      -webkit-box-align: center;
      align-items: center;
      -webkit-box-pack: center;
      justify-content: center;
      height: 40px;
      width: 100%;
      font-weight: 800;
      font-size: 14px;
      color: rgb(102, 102, 102);
      border: 1px solid rgb(204, 204, 204);
      background-color: white;
      outline: none;
    }
    /* TOP 버튼 CSS 끝 */
</style>

<sec:authorize access="isAuthenticated()">
<script>
var totalJjim = 0;
(() => {
	$.ajax({
        type : "GET",
		url: "${pageContext.request.contextPath}/product/getTotalJjimNo.do",
        contentType : "application/json; charset:UTF-8",
	    success: function(data){
			console.log(data);
			
			$('#jjim_count').html(totalJjim);
		},
		error: (request, status, err) =>{
			 console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+err);
	       

		}
	});
	

});
</script>
</sec:authorize>

<div class="history-box">
    <div class="history-box-container">
      <!-- 찜 상품 목록 시작-->
        <div class="jjim">
          <div class="jjim-title"><spring:message code="jjim.items" /></div>
          <div class="jjim-count-wrapper">
            <!-- 찜한 상품 생길 시 count ++, 색상 변경(red)-->
            <div class="jjim-count" onclick='jjimListDo();'>
              <span id = 'jjim-icon'>♥</span>
              <span id="jjim_count">&nbsp;${fn:length(jjimList)}</span>
            </div>
          </div>
        </div>
      <!--  찜 상품 목록 끝 -->
      <!-- 최근 본 상품 목록 시작 -->
        <div class="recent">
          <div class="recent-title"><spring:message code="jjim.recent.see.product" /></div>
          <div class="recent-dot"></div>
          <!-- 최근 본 상품 == null -->
          <div class="recent-content" id="recent-content">
           <div id="recent-no-content">
             <spring:message code="jjim.recent.see" /><br/> <spring:message code="jjim.recent.see.product" /> <br/><spring:message code="jjim.recent.see.product.no" />
           </div> 
          </div>
          <!-- 최근 본 상품 != null => 3개까지 출력. 저장은 DB? Session? -->
        </div>
      <!-- 최근 본 상품 목록 끝 -->
      <!-- TOP 버튼 시작-->
        <div class="top">
          <!-- 버튼 클릭 시 화면 최상단으로 이동 : scrollTo() -->
          <button class="top-btn">TOP</button>
        </div>
      <!-- TOP 버튼 끝 -->
    </div>
</div>
<script>
  
  const topBtn = document.querySelector(".top-btn");
  topBtn.addEventListener("click", e =>{
    e.preventDefault();
    window.scrollTo({top: 0, behavior:"smooth"});
  });
  
  $(document).ready(function(){
	  const jjimIcon = $("#jjim-icon");
	  if(!${fn:length(jjimList)} == 0)
		  jjimIcon.css('color', 'red');
	  
  });
  function jjimListDo(){
	<sec:authorize access="isAnonymous()">
      alert('로그인후 이용해주세요.');
      return;
	</sec:authorize>
	  location.href = '${pageContext.request.contextPath}/jjim/jjimList.do';
  }

  const recentList = (productInfo) =>{
    const recent_div = document.querySelector("#recent-content");
    
    const recent_img = document.createElement("div");
    recent_img.className = "recent-img";
    recent_img.style.backgroundImage="url(${pageContext.request.contextPath}/resources/upload/product/" + productInfo.productImg + ")";
    recent_img.width = 50;
    recent_img.height = 50;

    const recent_detail_area = document.createElement("div");
    recent_img.appendChild(recent_detail_area);
    recent_detail_area.className="recent-detail-area"
    recent_detail_area.addEventListener("click", function(e) {
          location.href='${pageContext.request.contextPath}/product/productDetail.do?productId=' + productInfo.productId;
        })

    const recent_detail_div = document.createElement("div");
    recent_detail_area.appendChild(recent_detail_div);
    recent_detail_div.className="recent-detail-div"

    const recent_detail_name = document.createElement("div");
    const recent_detail_price = document.createElement("div");
    recent_detail_name.className = "recent-detail-name";
    recent_detail_price.className = "recent-detail-price";

    recent_detail_name.innerText = productInfo.productName;
    recent_detail_price.innerText = productInfo.productPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",") + " 원";

    recent_detail_div.appendChild(recent_detail_name);
    recent_detail_div.appendChild(recent_detail_price);
    

    recent_div.appendChild(recent_img);
  }
  
  // 로컬스토리지에 있는 최근본상품1~3 값을 불러온다.(JSON)

  let product_count = 0;
  for(let i = 1; i <= 3; i++){
    const productInfoJSON = localStorage.getItem("최근본상품_" + i);

    // 키값을 통해 불러온 값이 없으면 멈춰!
    if(!productInfoJSON) {
      break;
    }

    //불러온 JSON값을 JSON.PARSE해서 저장
    const productInfo = JSON.parse(productInfoJSON);
    console.log(productInfo)

    //변수들을 html요소로 만든다.
    recentList(productInfo);
    product_count++;
  }  
  
  // 로컬스토리지에 상품이 하나라도 있으면 문구 지운다.
  if(product_count > 0) {
    document.querySelector("#recent-no-content").style.display = "none";
  }
  
</script>