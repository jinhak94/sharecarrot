package com.kh.sharecarrot.chatting.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.sharecarrot.chatting.model.service.ChattingService;
import com.kh.sharecarrot.chatting.model.vo.ChattingMessage;
import com.kh.sharecarrot.chatting.model.vo.ChattingRoom;
import com.kh.sharecarrot.member.model.service.MemberService;
import com.kh.sharecarrot.shop.model.service.ShopService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/chat")
public class ChattingController {
	
	@Autowired
	private ChattingService chattingService;
	
	@Autowired
	private ShopService shopService;
	
	@GetMapping("/chattingRoom.do")
	private void chattingRoom(@RequestParam String roomBuyerId, @RequestParam String roomSellerId, Model model) {
		//0인 경우 구매자, 1인 경우 판매자
		int flag = 0;
		
		Map<String, Object> param = new HashMap<>();
		param.put("roomBuyerId", roomBuyerId);
		param.put("roomSellerId", roomSellerId);
		
		//방번호 찾기
		ChattingRoom chattingRoom = chattingService.selectRoomNo(param);
		
		List<ChattingMessage> chattingMessageList= null;
		//이전에 채팅을 했던 경우, 이전 대화내역 불러오기
		if(chattingRoom != null) {
			chattingMessageList = chattingService.selectMessageList(chattingRoom.getRoomNo());
		}
		//이전 대화내역이 없는 경우, 새로운 대화방 생성
		else {
			int result = chattingService.insertChattingRoom(param);
			chattingRoom = chattingService.selectRoomNo(param);
		}
//		log.info("chatting room : {}", chattingRoom);
//		log.info("chatting Message : {}", chattingMessageList);
		
		//현재 로그인한 아이디
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		//로그인한 memberId
	    String loginMemberId = ((UserDetails) principal).getUsername();		
		
	    //구매자 판매자 구분 정보
	    if(roomBuyerId.equals(loginMemberId)) {
	    	//구매자의 경우 flag = 0
	    	flag = 0;
	    }else if(roomSellerId.equals(loginMemberId)){
	    	//판매자의 경우 flag = 1
	    	flag = 1;
	    }
	    
	    //채팅방 번호
	    model.addAttribute("roomNo", chattingRoom.getRoomNo());
	    //판매자아이디
	    model.addAttribute("seller_id", chattingRoom.getRoomSellerId());
	    //구매자아이디
	    model.addAttribute("buyer_id", chattingRoom.getRoomBuyerId());
	    //구매자, 판매자 구분을 위한 flag
	    model.addAttribute("flag", flag);
	    //이전대화내역
		model.addAttribute("chattingMessageList", chattingMessageList);
	}
	
	@GetMapping("/chattingManagement.do")
	private void chattingManagement(Model model) {
		// 현재 본인의 shop_id로 만들어진 chatting_room이 있는지 검사하고,
		// 있으면 테이블로 띄워주기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal(); 
		//로그인한 memberId
	    String loginMemberId = ((UserDetails) principal).getUsername();
	    String shopId = shopService.selectShopId(loginMemberId);
		List<ChattingRoom> chattingRoomList = chattingService.selectRoomList(loginMemberId);
				
		model.addAttribute("chattingRoomList", chattingRoomList);
		model.addAttribute("shopId", shopId);
	}
	
	@PostMapping("/chatEnroll.do")
	private void chatEnroll(
			@RequestParam String roomBuyerId,
			@RequestParam String shopId,
			@RequestParam String message,
			@RequestParam char flag
			) {
//		private String messageText;
//		private Timestamp messageDate;
//		private int roomNo;
//		private String roomBuyerId;
//		private String roomSellerId;	
		
		//판매자 아이디 찾기
		String roomSellerId = shopService.selectMemberId(shopId);

		Map<String, Object> param = new HashMap<>();
		param.put("roomBuyerId", roomBuyerId);
		param.put("roomSellerId", roomSellerId);
		
		//방번호 찾기
		ChattingRoom chattingRoom = chattingService.selectRoomNo(param);
		ChattingMessage chattingMessage = null;
		
		//현재 시간 timestamp값 가져오기
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        System.out.println(timestamp); // 생성한 timestamp 출력
        SimpleDateFormat sdf = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
		
		//채팅메세지 객체 생성
        //1인 경우, 판매자임. 구매자 id에 null
        if(flag == '1') {
        	chattingMessage = new ChattingMessage(message, timestamp, chattingRoom.getRoomNo(), null, roomSellerId);        	
    	//0인 경우, 구매자임. 판매자 id에 null
        }else if(flag == '0') {        	
        	chattingMessage = new ChattingMessage(message, timestamp, chattingRoom.getRoomNo(), roomBuyerId, null);
        }
		
		//채팅메세지 객체를 사용해 db insert
		int result = chattingService.insertChattingMessage(chattingMessage);
		
	}
}
