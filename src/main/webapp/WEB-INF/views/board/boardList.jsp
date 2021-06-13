<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
	.likeBtn{
		cursor:pointer;
		height:2em;
	}
	.updelBtn{
		color: blue;
		cursor:pointer;
	}
	.boardImg{
		height: 500px;
		width:70%;
	}
	.customTable{
		border-radius: 30px;
	}
</style>
<section id="board-container" class="container">
<br />
	<%-- Nav Bars --%>
	<ul class="nav nav-tabs nav-fill" id="navBars">
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq null? 'active' : ''}" aria-current="page" href="${pageContext.request.contextPath}/board/boardList.do${!empty param.locCode ? '?locCode='+=param.locCode : '' }">전체</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq 'C1'? 'active' : ''} " href="${pageContext.request.contextPath}/board/boardList.do?boardCategory=C1${!empty param.locCode ? '&locCode='+=param.locCode : '' }">여행/음식</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq 'C2'? 'active' : ''}" href="${pageContext.request.contextPath}/board/boardList.do?boardCategory=C2${!empty param.locCode ? '&locCode='+=param.locCode : '' }">취미생활</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq 'C3'? 'active' : ''}" href="${pageContext.request.contextPath}/board/boardList.do?boardCategory=C3${!empty param.locCode ? '&locCode='+=param.locCode : '' }">헬스/다이어트</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq 'C4'? 'active' : ''}" href="${pageContext.request.contextPath}/board/boardList.do?boardCategory=C4${!empty param.locCode ? '&locCode='+=param.locCode : '' }">반려동물</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${param.boardCategory eq 'C5'? 'active' : ''}" href="${pageContext.request.contextPath}/board/boardList.do?boardCategory=C5${!empty param.locCode ? '&locCode='+=param.locCode : '' }">회사생활</a>
    </li>
  </ul>
  <div class='container mt-3'>
  	<div class="row">
		<div class='col'>
			<select id="selectLocation" required>
			  <option selected value="">전체지역</option>
			  <c:forEach items="${locationList}" var="location">
			  	<option value="${location.locCode}" ${param.locCode eq location.locCode ? 'selected' : ''}>${location.locName}</option>
			  </c:forEach>
			</select>
			<select id="selectHottest" required>
			  <option value="L" selected>최신순</option>
			  <option value="H">인기순</option>
			</select>
		</div>
		<div class='col mb-3' style='text-align:right;'>
			<input type="button" value="글쓰기" id="btn-add" class="btn btn-sm btn-outline-dark" onclick="goBoardForm();"/>
		</div>
  	</div>
  </div>
	
	<div id="boardList">
	</div>
	<button id="searchMore" class="btn btn-outline-dark btn-block col-sm-12 mx-auto">더 보기</button>
	
	<script>
	function goBoardForm(){
		if(!loginCheck()){
			return;
		}
		location.href="${pageContext.request.contextPath}/board/boardEnroll.do";
	}
	
	$(document).ready(function(){
		var boardListCnt = $(boardList).children().length;             // 전체 사이즈
		var boardCategory = '<c:out value="${param.boardCategory}"/>'; // 현재 파라미터에 있는 카테고리
		var locCode = '<c:out value="${param.locCode}"/>';             //    ''           지역코드
		var cPage = 1;
		const numPerPage = 5;
		
		readBoardList(cPage++);                                        // 페이지 요청시
		
		$(searchMore).click(function(){                                // 더보기 버튼
			readBoardList(cPage++);
		});

		$("#selectLocation").change(function(e){                       // 지역코드 변경시
			var locCode = e.target.value;
			var url = boardCategory == null || boardCategory == '' ? "" : "&boardCategory="+boardCategory;
			location.href="${pageContext.request.contextPath}/board/boardList.do?locCode=" + locCode + url;
		});
		
		$("#selectHottest").change(function(e){                        // 최신순,인기순 선택시
			const code = e.target.value;
			readBoardList(1, code);
		});
		
		function readBoardList(index, code){                          // board 데이터 비동기 요청
			$.ajax({
				type: "GET",
				dataType : "json",
				data: {
					boardCategory : boardCategory,
					locCode : locCode,
					cPage: index,
					numPerPage: numPerPage,
					code : code
				},
				url: "${pageContext.request.contextPath}/board/searchBoardList.do?${_csrf.parameterName}=${_csrf.token}",
				success: function(data){
					displayList(data,code);
				},
				error:function(request,status,error){
		            console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		           }
			});
		}
		
		
		function displayList(data, code){
			if(code) $(boardList).html('');
			console.log(data);
			if(data.length === 0){
				console.log('nullTEst');
				$(searchMore).html('더 보여줄 자료가 없습니다!');
			}
				
			$.each(data, function(index, elem){
				<%-- 유저 지역 검색 --%>
				var loc = "";
				<c:forEach items='${locationList}' var='location'>
					if('${location.locCode}' == elem.locCode)
						loc = '${location.locName}';
				</c:forEach>
				
				<%--날짜 포맷 변경 밀리초--->>데이트포멧--%> 
				var enDate = getFormetDate(new Date(elem.boardEnrollDate));
				
				
				<%--회원정보 헤더--%>
				var html = "<div class='m-3'>";
						html = "<table class='table customTable'>";
						html += "<tr class='table-secondary'>";
							html += "<td>"+elem.memberId+"</td>";
							html += "<th colspan='3' style='text-align:right;'>["+elem.boardTitle+"]</th>";
							html += "<td align='right'>"+loc+"&nbsp;"+enDate+"</td>";
						html += "</tr>";
						
						<%--이미지--%>		  
						html += "<tr  class='table-light'><td colspan='5'>";
							if(elem.boardImageList != null){
								html += `<div id="imgSlider\${elem.boardNo}" style="text-align:center;" class="carousel slide col" data-bs-ride="carousel">`;
									html += `<div class="carousel-inner">`;
										html += `<div class="carousel-item active">`;
											html += `<img src="${pageContext.request.contextPath}/resources/upload/board/\${elem.boardImageList[0].boardImgRenamed}" class='boardImg' />`;
										html += `</div>`;
										$.each(elem.boardImageList, function(index,img){
											if(index == 0){ 
												return true;
											}
											html += `<div class="carousel-item">`;
												html += "<img src='${pageContext.request.contextPath}/resources/upload/board/"+img.boardImgRenamed+"' class='boardImg' />";
											html += `</div>`;
										});
									html += `</div>`;
									html += ` 
											<button class="carousel-control-prev" type="button" data-bs-target="#imgSlider\${elem.boardNo}" data-bs-slide="prev">
											    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
											    <span class="visually-hidden">Previous</span>
											  </button>
											  <button class="carousel-control-next" type="button" data-bs-target="#imgSlider\${elem.boardNo}" data-bs-slide="next">
											    <span class="carousel-control-next-icon" aria-hidden="true"></span>
											    <span class="visually-hidden">Next</span>
											  </button>
											  `;
								html += `</div>`;
							}
						html += "</td></tr>";
						    
						<%--게시글 내용--%>
						html += "<tr  class='table-light'><td colspan='5' height='0'><b>"+elem.memberId+"</b>&nbsp;"+elem.boardContent+"</td></tr>";
						
						<%--좋아요 버튼--%>
						<%-- 좋아요테이블에 해당게시물의 번호가 포함되어있는지 확인 --%>
						var likeBool = false;
						<c:forEach var="boardLike" items="${boardLikeList}">
						  var boardNo = "${boardLike.boardNo}";
						  if(boardNo == elem.boardNo){
						    likeBool = true;
						  }
						</c:forEach>
						
						if(likeBool){ <%--좋아요를 누른경우--%>
							html += `<tr><td colspan='5'  class='table-light'><img id='likeBtn\${elem.boardNo}' class='likeBtn' 
								src='${pageContext.request.contextPath}/resources/images/board/like.png' onclick="likeBtnTrigger('like\${elem.boardNo}', 'likeCntH\${elem.boardNo}', 'likeCnt\${elem.boardNo}', '\${elem.boardNo}', 'likeBtn\${elem.boardNo}');"/>
								<span class='badge bg-dark rounded-pill ml-3' id='likeCnt\${elem.boardNo}'> \${elem.boardLike} 명이 좋아합니다.</span></td></tr>`;
							html += `<input type='hidden' id='likeCntH\${elem.boardNo}' value='\${elem.boardLike}'/>`;
							html += `<input type='hidden' id='like\${elem.boardNo}' value='1'>`;
							
						} else { <%-- 안누른경우--%>
							html += `<tr><td colspan='5'  class='table-light'><img id='likeBtn\${elem.boardNo}' class='likeBtn' 
								src='${pageContext.request.contextPath}/resources/images/board/nolike.png' onclick="likeBtnTrigger('like\${elem.boardNo}', 'likeCntH\${elem.boardNo}',  'likeCnt\${elem.boardNo}', '\${elem.boardNo}', 'likeBtn\${elem.boardNo}');"/>
								<span class='badge bg-dark rounded-pill ml-3' id='likeCnt\${elem.boardNo}'> \${elem.boardLike} 명이 좋아합니다.</span></td></tr>`;
							html += `<input type='hidden' id='likeCntH\${elem.boardNo}' value='\${elem.boardLike}'/>`;
							html += `<input type='hidden' id='like\${elem.boardNo}' value='-1'>`;
						}
						
						
						<%-- 댓글창 해당 게시물번호에 대한 댓글목록을 불러온다--%>
						html += "<tr>";
						html += `<td colspan='5'  class='table-light' id='commentArea\${elem.boardNo}'>`; 
						html += `<div class="card">`;
						html += `<div class="card-header bg-light"><i class="fa fa-comment fa"></i> 댓글</div>`;
						html += `<div class="card-body">`;
						html += "<ul class='list-group list-group-flush'></ul>";
						html += `</div>`;
						
						html += "</div>";
						html += "</td>";
						html += "</tr>";
						
						
						
						
						<%-- 댓글 등록 버튼 클릭시 게시물번호, CommentText의 Id값을 보내줌--%>
						html +="<tr>"
							html += "<td colspan='5'  class='table-light'>";
								html += `<textarea id='boardCommentText\${elem.boardNo}' style='width:85.5%; height:100%;'></textarea>`;
								html += `<input type='button' class='btn btn-dark' onclick="commentInsert('\${elem.boardNo}', 'boardCommentText\${elem.boardNo}', 1)" value='댓글 등록' style='float:right;'/>`;
							html += "</td>";
						html += "</tr>";
						
						
						//로그인 한경우 수정/삭제버튼 추가
						<sec:authorize access="isAuthenticated()">
						if(elem.memberId == "<sec:authentication property='principal.username'/>"){
							html += "<tr  class='table-light'><td></td><td></td><td></td><td></td>";
							html += "<td align='right'>";
							html += `<input type='button' class='btn btn-sm btn-secondary" d-inline' onclick="location.href='${pageContext.request.contextPath}/board/boardUpdate.do?boardNo=\${elem.boardNo}';" value='수정'/>|`;
							html += `<form class='d-inline' name='deleteF' id='deleteFrm\${elem.boardNo}' action='${pageContext.request.contextPath}/board/boardDelete.do?${_csrf.parameterName}=${_csrf.token}' method='POST'>`;
							html += `<button onclick='deleteFrm();' type='button' class='btn btn-sm btn-secondary" d-inline'>삭제</button>`;
							html += `<input name='boardNo' type='hidden' value='\${elem.boardNo}'/>`;
							html += "</form>";
							html += "</td>";
							html += "</tr>";
						}
						
						</sec:authorize>
				html += "</table>";
				html += "</div><br><br><br>";
				
				$(boardList).append(html);
				
				<%--보드테이블이 생성된후에 댓글목록 생성--%>
				commentSelect(elem.boardNo, `commentArea\${elem.boardNo}`);
			});
		}
		
	});
	
	<%-- 좋아요 기능 관련 FUNCTION START --%>
	function likeBtnTrigger(likeHiddenId, likeCntH, likeCntSpan, boardNo, likeBtn){
		
		//로그인 하지 않았으면 조기리턴
		<sec:authorize access="isAnonymous()">
			alert('로그인 후 이용하실 수 있습니다.');
			return;
		</sec:authorize>
		
		var hidden = $(`#\${likeHiddenId}`); // 1혹은 0 눌렀는지 안눌렀는지를 확인할 flag
		var cntSpan = $(`#\${likeCntSpan}`); // "??명이 좋아요를 눌렀습니다" 를 표시할 영역
		var likeCntH = $(`#\${likeCntH}`); // 해당 게시물의 좋아요 갯수를 표시할 hidden input tag
		var likeCntHVal = Number(likeCntH.val()); // 해당 게시물의 좋아요 갯수
		var likeBtnImg = $(`#\${likeBtn}`); // 좋아요를 눌렀을때와 안눌렀을때 다르게 표시할 이미지 영역
		
		
		var count = 0;
		if(hidden.val() == 1){ // 좋아요가 눌러져 있다면, 좋아요를 취소한경우
			hidden.val('0');
			likeCntH.val(likeCntHVal - 1);
			count = likeCntHVal -1;
			likeBtnImg.attr('src', '${pageContext.request.contextPath}/resources/images/board/nolike.png');
		} else { // 아니라면, 좋아요를 누른경우
			hidden.val('1');
			likeCntH.val(likeCntHVal +1);
			count = likeCntHVal +1;	
			likeBtnImg.attr('src', '${pageContext.request.contextPath}/resources/images/board/like.png');
		}
		cntSpan.html(` \${count} 명이 좋아합니다.`);
		
		
		$.ajax({
			type: 'POST',
			url: '${pageContext.request.contextPath}/board/boardLike.do?${_csrf.parameterName}=${_csrf.token}',
			data : {
				boardNo : boardNo,
				likeCnt : count,
				likeBool : hidden.val(),
				<sec:authorize access="isAuthenticated()">
				memberId : "<sec:authentication property='principal.username' />"
				</sec:authorize>
			},
			success: function(data){
				console.log(data);
			},
			error:function(request,status,error){
            console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
		});
	}
	<%-- 좋아요 기능 관련 FUNCTION END --%>
	
	<%-- 게시물 삭제 관련 FUNCTION START --%>
	function deleteFrm(){
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
		
		$("[name=deleteF]").submit();
	}
	<%-- 게시물 삭제 관련 FUNCTION END --%>
	
	<%-- 댓글 등록 관련 FUNCTION START --%>
	function commentInsert(boardNo, textId, boardCommentLevel, boardCommentRef){
		
		//로그인 하지 않았으면 조기리턴
		<sec:authorize access="isAnonymous()">
			alert('로그인 후 이용하실 수 있습니다.');
			return;
		</sec:authorize>
		
		const text = $(`#\${textId}`);		//사용자가 입력한 댓글영역
		const boardContent = text.val();	// 댓글
		
		//댓글 입력안했을때 조기리턴
		if(!boardContent) {
			alert('댓글 내용을 입력해주세요.');
			return;
		}
		
		$.ajax({
			type: 'POST',
			url : '${pageContext.request.contextPath}/board/boardCommentInsert.do?${_csrf.parameterName}=${_csrf.token}',
			data : {
				boardCommentContent : boardContent,
				boardCommentLevel,
				boardNo : boardNo,
				<sec:authorize access="isAuthenticated()">
				memberId : "<sec:authentication property='principal.username' />",
				</sec:authorize>
				boardCommentRef : boardCommentRef
			},
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			success: function(data){ 
				alert(data); 
				text.val(''); // 값 초기화
				commentSelect(boardNo, 'commentArea'+boardNo);
			},
			error:function(request,status,error){
            console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
           }
		});
		
		
	}
	<%-- 댓글 등록 관련 FUNCTION END --%>
	
	<%-- 댓글 목록 관련 FUNCTION START --%>
	function commentSelect(boardNo, _commentArea){
		const commentArea = $(`#\${_commentArea}`).find('ul');
		
		$.ajax({
			type : 'GET',
			url : '${pageContext.request.contextPath}/board/boardCommentSelect.do',
			data : {
				boardNo : boardNo,
			},
			success : function(data){
				commentArea.html('');
				
				let html = "";
				
				$.each(data, function(index, elem){
					var boardNo = elem.boardNo;
					var textId = `commentReply\${elem.boardCommentId}`;
					var boardCommentRef = elem.boardCommentId;
					var level = elem.boardCommentLevel;
					
					
					var enDate = getFormetDate(new Date(elem.boardCommentEnrollDate));
					<sec:authorize access="isAuthenticated()">
					var loginMemberId = "<sec:authentication property='principal.username'/>";
					</sec:authorize>
					if(level == 1){ // 댓글영역
						html += `<li class='list-group-item d-flex' id='commentLevel\${boardCommentRef}'>`;
						html += `<div><b>\${elem.memberId}</b>&nbsp;</div>`;
						html += `<div class='border flex-fill'>&nbsp;\${elem.boardCommentContent}</div>`;
						html += `<button class='btn btn-sm btn-dark' type='button' onclick='loginCheck();' data-bs-toggle="collapse" data-bs-target="#reply\${elem.boardCommentId}" aria-expanded="false" aria-controls="reply\${elem.boardCommentId}">답글</button>`;
						
						
						html += `<div style='font-size:12px;'>&nbsp;\${enDate} <br> &nbsp;&nbsp;`;
						<sec:authorize access="isAuthenticated()">
						if(elem.memberId == loginMemberId){
							html += `<a class='updelBtn' onclick='loginCheck();' data-bs-toggle="collapse" href="#update\${elem.boardCommentId}" role="button" aria-expanded="false" aria-controls="update\${elem.boardCommentId}">수정&nbsp;&nbsp;&nbsp;</a>`; 
							html += `<span class='updelBtn' onclick="commentDelete('\${elem.boardCommentId}', '\${elem.boardNo}', '\${elem.memberId}')">삭제</span>`;
						}
						</sec:authorize>
						html += `</div>`;
						html += "</li>";
						
						
						
					} else { //대댓글 영역
						html += `<li class='list-group-item d-flex' id='commentLevel\${boardCommentRef}'>`;
						html += `<div>&nbsp;&nbsp;&nbsp;&nbsp;
									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
							  			<path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
									</svg>
									<b>\${elem.memberId}</b>&nbsp;
								</div>`;
						html += `<div class='border flex-fill'>&nbsp;\${elem.boardCommentContent}</div>`;
						
						
						html += `<div style='font-size:12px;'>&nbsp;\${enDate} <br> &nbsp;&nbsp;`;
						<sec:authorize access="isAuthenticated()">
						if(elem.memberId == loginMemberId){
							html += `<a class='updelBtn' onclick='loginCheck();' data-bs-toggle="collapse" href="#update\${elem.boardCommentId}" role="button" aria-expanded="false" aria-controls="update\${elem.boardCommentId}">수정&nbsp;&nbsp;&nbsp;</a>`; 
							html += `<span class='updelBtn' onclick="commentDelete('\${elem.boardCommentId}', '\${elem.boardNo}', '\${elem.memberId}')">삭제</span>`;
						}
						</sec:authorize>
						html += `</div>`;
						html += "</li>";
						
						
					}
					
					<sec:authorize access="isAuthenticated()">
					
					<%--수정영역 로그인 한 경우만 이용가능--%>
					html += `
						<div class="collapse" id="update\${elem.boardCommentId}">
							<div class="card card-body d-flex">
							    <div><b><sec:authentication property='principal.username' /></b></div>
							    <div class='flex-fill'><textarea id='commentUpdateText\${elem.boardCommentId}' style='width:100%; height:100%;'></textarea></div>
							    <div><button class='btn-sm btn-dark' type='button' onclick="commentUpdate('commentUpdateText\${elem.boardCommentId}', '\${elem.boardCommentId}', '\${elem.boardNo}', '\${elem.memberId}');">답글 수정</button></div>
							</div>
						</div>
					`;
					
					<%--답글영역 로그인 한경우만 이용가능--%>
					
					html += `<div class="collapse" id="reply\${elem.boardCommentId}">
						  <div class="card card-body d-flex">
					    <div><b><sec:authentication property='principal.username' /></b></div>
					    <div class='flex-fill'><textarea id='commentReply\${elem.boardCommentId}' style='width:100%; height:100%;'></textarea></div>
					    <div><button class='btn-sm btn-dark' type='button' onclick="commentInsert('\${boardNo}', '\${textId}', 2, '\${boardCommentRef}');">답글 등록</button></div>
					  </div>
					</div>`;
					
					</sec:authorize>
				
				});
				
				commentArea.append(html);
			},
			error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		})
	}
	<%-- 댓글 목록 관련 FUNCTION END --%>

	<%-- 댓글 Update START--%>
	function commentUpdate(_commentUpdateText, boardCommentId, boardNo, memberId){
		const commentUpdateText = $(`#\${_commentUpdateText}`);
		console.log(boardCommentId);
		//로그인 하지 않았으면 조기리턴
		<sec:authorize access="isAnonymous()">
			alert('로그인 후 이용하실 수 있습니다.');
			return;
		</sec:authorize>
		
		//댓글을 입력하지 않았으면 조기리턴
		if(!commentUpdateText.val()){
			alert('내용을 입력해주세요.');
			return;
		}
		
		$.ajax({
			method: 'POST',
			url : '${pageContext.request.contextPath}/board/boardCommentUpdate.do?${_csrf.parameterName}=${_csrf.token}',
			data : {
				boardCommentId : boardCommentId ,
				boardCommentContent : commentUpdateText.val()
			},
			success : function(data){
				alert(data);
				commentUpdateText.val('');
				commentSelect(boardNo, 'commentArea'+boardNo);
			},
			error : function(request, status, error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	<%--댓글 Update End--%>
	
	<%-- 댓글 Delete START --%>
	function commentDelete(boardCommentId, boardNo, memberId){
		//로그인 하지 않았으면 조기리턴
		<sec:authorize access="isAnonymous()">
			alert('로그인 후 이용하실 수 있습니다.');
			return;
		</sec:authorize>
		

		
		//다른사람껄 삭제하려하면
		if(loginMemberId != memberId){
			alert('본인의 댓글만 삭제가 가능합니다!');
			return;
		}
		
		$.ajax({
			method: 'POST',
			url : '${pageContext.request.contextPath}/board/boardCommentDelete.do?${_csrf.parameterName}=${_csrf.token}',
			data : {
				boardCommentId : boardCommentId ,
			},
			success : function(data){
				alert(data);
				commentSelect(boardNo, 'commentArea'+boardNo);
			},
			error : function(request, status, error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	<%--댓글 DELETE END--%>
	
	
	<%-- 로그인 검사--%>
	function loginCheck(){
		<sec:authorize access="isAnonymous()">
		alert('로그인 후 이용하실 수 있습니다.');
		return false;
		</sec:authorize>
		
		return true;
	}
	<%-- 시간포맷 --%>
	function getFormetDate(date){
		var year = date.getFullYear();
		var month = (1 + date.getMonth());
		month = month >= 10 ? month : '0' + month;
		var day = date.getDate();
		day = day >= 10 ? day : '0' + day;
		
		return year + '-' + month + '-' + day;
	}
	</script>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
