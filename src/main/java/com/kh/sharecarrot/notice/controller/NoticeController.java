package com.kh.sharecarrot.notice.controller;

import java.io.File;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.sharecarrot.common.ShareCarrotUtils;
import com.kh.sharecarrot.member.model.service.MemberService;
import com.kh.sharecarrot.notice.model.service.NoticeService;
import com.kh.sharecarrot.notice.model.vo.Notice;
import com.kh.sharecarrot.notice.model.vo.NoticeImage;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/notice")
public class NoticeController {

	@Autowired
	private NoticeService NoticeService;
	
	@GetMapping("/noticeList.do")
	public void NoticeList(Model model, @RequestParam(defaultValue = "1") int cPage, 
							@RequestParam(defaultValue = "") String searchKeyword,
							HttpServletRequest request) {
		
		Map<String, Object> param = new HashMap<>();
		int numPerPage = 10;
		param.put("searchKeyword", searchKeyword);
		param.put("numPerPage", numPerPage);
		param.put("cPage", cPage);
		
		List<Notice> NoticetList = null;
		NoticetList = NoticeService.selectNoticeList(param);
		
		int totalContents = NoticeService.getTotalContents();
		String url = request.getRequestURI();
		String pageBar = ShareCarrotUtils.getPageBar(totalContents, cPage, numPerPage, url);

		model.addAttribute("noticeList", NoticetList);
		model.addAttribute("pageBar", pageBar);
	}
	
	@GetMapping("/noticeDetail.do")
	public void noticeDetail(@RequestParam int no, Model model) {
		Notice notice = NoticeService.selectOneNoticeDetail(no);
		
		model.addAttribute("notice", notice);
	}
	
	@GetMapping("/noticeListGo.do")
	public String noticeListGo(@RequestParam int no, Model model) {

		int notice = NoticeService.updatenoticeYn(no);
		
		// model.addAttribute("notice", notice);
		
		return "redirect:/notice/noticeList.do";
	}
	@GetMapping("/noticeForm.do")
	public void noticeForm() {
		
	}
	
	@PostMapping("/noticeEnroll.do")
	public String noticeEnroll(@ModelAttribute Notice notice,
							  HttpServletRequest request,
							  RedirectAttributes redirectAttr) throws IllegalStateException, IOException {

		try {

			int reuslt = NoticeService.insertNotice(notice);
			redirectAttr.addFlashAttribute("msg", "????????? ????????? ?????????????????????.");	
		} catch (Exception e) {
			log.error("????????? ?????? ??????!", e);
			throw e; // spring container?????? ?????? ??????
		}
			
		return "redirect:/notice/noticeList.do";
	}
	
	@GetMapping("/noticeUpdateForm.do")
	public void noticeUpdateForm(@RequestParam(required = true) int no, Model model) {
		//1.???????????? 
		Notice notice = NoticeService.selectOneNoticeDetail(no);
		log.info("notice = {}", notice);
		//2. jsp??????
		model.addAttribute("notice", notice);
		log.info("null");
	}
	
	@PostMapping("/noticeUpdateForm.do")
	public String noticeUpdateForm(Notice notice, RedirectAttributes redirectAttr) {
		//1.???????????? 
		log.info("noticeUpdateForm - no : {}", notice);
		int result = NoticeService.noticeUpdateForm(notice);
		String msg = result > 0 ? "?????? ??????" : "?????? ??????";
		
		//2. ??????????????? ??? ????????? ?????????
		redirectAttr.addFlashAttribute("msg", msg);
		
		return "redirect:/notice/noticeList.do";
	}
	
	@PostMapping("/deleteForm.do")
	public String deleteForm(@RequestParam int no, RedirectAttributes redirectAttr) {
		//1. ????????????
		int result = NoticeService.deleteForm(no);
		String msg = result > 0 ? "?????? ??????" : "?????? ??????";
		//2. ??????????????? ??? ??????????????????
		redirectAttr.addFlashAttribute("msg", msg);
		return "redirect:/notice/noticeList.do";
	}
	
}
	
