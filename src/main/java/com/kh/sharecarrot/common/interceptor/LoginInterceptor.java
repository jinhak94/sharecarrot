package com.kh.sharecarrot.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.kh.sharecarrot.member.model.vo.Member;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//로그인검사
		HttpSession session = request.getSession();
		Member loginMember = (Member)session.getAttribute("loginMember");
		if(loginMember == null) {
			//RedirectAttributes 내부에서 사용하는 FlashMap에 사용자 피드백 저장
			FlashMap flashMap = new FlashMap();
			flashMap.put("msg", "로그인 후 이용하세요.");
			//RequestContextUtils는 이번 요청 관련한 처리를 담당함.
			FlashMapManager manager = RequestContextUtils.getFlashMapManager(request);
			manager.saveOutputFlashMap(flashMap, request, response);
			
			//언제 어디서든 해당 요청을 가져올 수 있는 방법
			//HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			
			response.sendRedirect(request.getContextPath());
			return false;
		}

		return super.preHandle(request, response, handler);
	}
}

