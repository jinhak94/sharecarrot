package com.kh.sharecarrot.shop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(value = "/shop")
@SessionAttributes("loginMember")
public class ShopController {
	
	@RequestMapping(value="/manage.do")
	public String shopManagePage() {
		return "shop/myshop";
	}
	
	@RequestMapping(value="/productReg.do")
	public ModelAndView productReg() {
		ModelAndView mav = new ModelAndView("shop/myshop");
		mav.addObject("targetTab","productReg");
		return mav;
	}
	
	
}
