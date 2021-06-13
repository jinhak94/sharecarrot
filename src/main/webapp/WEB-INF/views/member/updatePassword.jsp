<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="비밀번호변경확인" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member.css" />
<style>
		.result-container{
		width: 100%;
		height: calc(100vh - 100px);
		/* background-color: hotpink; */
		display: flex;
		justify-content: center;
		align-items: center;

	}
	.result-wrapper{
		justify-content: center;
	}
	.password-update-result{
		/* background-color: aqua; */
		width: 500px;
		height: 500px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	.msg-container{
		display: flex;
		justify-content: center;
		align-items: center;
		width: 100%;
		height: 80%;
	}
	.buttons{
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.msg-container p{
		margin-bottom: 0;
		font-size: 22px;
		font-weight: 700;
	}
	.button-container{
		width: 100%;
		height: 20%;
	}
	
	.btn-password {
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
		<c:when test="${not empty msg1}">
			<!-- 기존 비밀번호랑 변경 비밀번호가 다를 때-->
			<div class="result-wrapper">
				<div class="password-update-result">
					<div class="msg-container">
						<p>
							${msg1}
						</p>
					</div>
					<div class="button-container">
						<!-- 비밀번호변경으로 이동 -->
						<div class="buttons">
							<input type="button" class="btn-password btn-large" id="password-btn" value="비밀번호 변경">
						</div>
					</div>
				</div>
			</div>
		</c:when>
		<c:when test="${not empty msg2}">
			<!-- DB업데이트가 실패한 경우 -->
			<div class="result-wrapper">
				<div class="password-update-result">
					<div class="msg-container">
						<p>${msg2}</p>
						<!-- 비밀번호 찾기로 이동 -->
					</div>
						<div class="buttons">
							<input type="button" class="btn-password btn-large" id="password-btn" value="비밀번호 변경">
						</div>
					</div>
				</div>
			</div>
		</c:when>	
		<c:when test="${not empty msg3}">
			<!-- 성공한 경우 -->
			<div class="result-wrapper">
				<div class="password-update-result">
					<div class="msg-container">
						<p>${msg3}</p>
						<!-- 비밀번호 찾기로 이동 -->
						</div>
						<div class="buttons">
							<input type="button" class="btn-password btn-large" id="member-detail-btn" value="확인">
						</div>
					</div>
				</div>
			</div>
		</c:when>	
	</c:choose>
</div>
<script>
	const passwordBtn = document.getElementById("password-btn");
	const memberDetailBtn = document.getElementById("member-detail-btn");
	const btn = document.querySelector(".btn-password")
	
	btn.addEventListener('click', ()=>{
		if(passwordBtn == null){
			location.href='${pageContext.request.contextPath}/member/memberDetail.do';
		}
		else if(memberDetailBtn == null) {
			location.href='${pageContext.request.contextPath}/member/changePassword.do';
		}
	})
	</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>