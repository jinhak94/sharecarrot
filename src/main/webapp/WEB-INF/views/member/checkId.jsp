<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="아이디확인" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member.css" />
<style>
		.result-container{
		width: 100%;
		height: calc(100vh - 100px);
		display: flex;
		justify-content: center;
		align-items: center;

	}
	.result-wrapper{
		justify-content: center;
	}
	.id-search-result{
		/* background-color: aqua; */
		width: 400px;
		height: 400px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	.password-search-result{
	/* background-color: aqua; */
	width: 400px;
	height: 400px;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
}
.content-container{
	text-align: center;
	width: 100%;
	height: 80%;
	/* justify-content: center; */
	display: flex;
	flex-direction: column;
	justify-content: center;
}
.content-container b{
	font-size: 32px;
	border-bottom: 3px solid #f7863b;
}
.id-search-result{
	font-size: 18px;
	font-weight: 600;
	margin-top: 10px;
}
.login-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0 8px;
  border: none;
  border-radius: 4px;
  font-weight: 700;

  color: #fff;
  background-color: #3da5f5;
  transition: background-color 200ms ease-in-out;
	margin-top: 10px;
}
.btn-large {
	width: 200px;
	height: 40px;
  font-size: 18px;
  line-height: 24px;
  letter-spacing: -0.01em;
}
.btn-password:hover {
  background-color: #3186c4;
}
</style>
<div class="result-container">
	<c:choose>
		<c:when test="${not empty memberId}">
			<div class="result-wrapper">
				<div class="content-container">
					<div class="id-search-result">
						회원님의 아이디는 
						<b>${memberId}</b> 
						입니다.
						<!-- 로그인으로 이동 -->
						<div class="buttons">
							<input type="button" class="button login-btn btn-large" id="login-btn" value="로그인">
						</div>
					</div>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="result-wrapper">
				<div class="id-search-result">
					조회된 아이디가 없습니다.
					<!-- 다시 아이디 조회 -->
					<div class="buttons">
						<input type="button" class="button" id="find-id-btn" value="아이디 찾기">
					</div>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</div>
<script>
const loginBtn = document.getElementById("login-btn");
const findIdBtn = document.getElementById("find-id-btn");
const btn = document.querySelector(".button")

btn.addEventListener('click', ()=>{
	if(loginBtn == null){
		history.back();
	}
	else if(findIdBtn == null) {
		location.href='${pageContext.request.contextPath}/member/memberLogin.do';
	}
})
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>