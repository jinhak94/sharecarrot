<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="아이디 찾기" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member.css" />
<style>
	.info-container{
		width: 100%;
		height: calc(100vh - 100px);
		display: flex;
		justify-content: center;
		align-items: center;

	}
	.info-wrapper{
		/* background-color: aqua; */
		width: 400px;
		height: 400px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	.info-title{
		font-size: 24px;
		font-weight: bold;
		width: 100%;
		text-align: center;
	}
	.info-input{
		width: 100%;
		height: 50%;
		display: flex;
		flex-direction: column;
		justify-content: space-evenly;
		align-items: center;
	}
	.info-input input {
		width: 300px;
		height: 50px;
		border: none;
		border-bottom: 2px solid #f7863b;
	}

	.btn-search {
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
.btn-search:hover {
  background-color: #3186c4;
}
/* .info-input input{
    background: none;
   
    border: none;
    line-height: 45px;
    padding-left:10px;
    width:267px;
}
.info-input input:focus{
    outline: none;
} */
</style>
<div class="info-container">
<form:form
	action="${pageContext.request.contextPath}/member/findId.do"
	method="POST"
	onsubmit="return validation()">
	<div class="info-wrapper">
		<div class="info-title">
			<p>아이디 찾기</p>
		</div>
		<div class="info-input">
			<div class="name-space">
				<input type="text" name="memberName" id="memberName" placeholder="이름을 입력하세요">
			</div>
			<div class="email-space">
				<input type="email" name="email" id="email" placeholder="이메일주소를 입력하세요">
			</div>
		</div>
		<div class="button-space">
			<input type="submit" class="btn-search btn-large" value="아이디 찾기">
		</div>
	</form:form>
</div>
</div>
<script>
	const inputName = document.querySelector("#memberName");
	const inputEmail = document.querySelector("#email");

	function validation(){
		if(inputName.value == ""){
			alert("이름은 반드시 입력해야합니다.");
			return false;
		} else if(inputEmail.value ==""){
			alert("이메일은 반드시 입력해야합니다.");
			return false;
		}
		return true;
	}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>