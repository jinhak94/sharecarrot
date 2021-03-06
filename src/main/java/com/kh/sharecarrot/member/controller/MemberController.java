package com.kh.sharecarrot.member.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.sharecarrot.common.ShareCarrotUtils;
import com.kh.sharecarrot.member.model.service.MemberService;
import com.kh.sharecarrot.member.model.vo.Authority;
import com.kh.sharecarrot.member.model.vo.Member;
import com.kh.sharecarrot.shop.model.service.ShopService;
import com.kh.sharecarrot.shop.model.vo.Shop;
import com.kh.sharecarrot.utils.model.service.UtilsService;
import com.kh.sharecarrot.utils.model.vo.Location;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/member")
@SessionAttributes("loginMember")
public class MemberController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private UtilsService utilsService;
	
	@Autowired
	private ShopService shopService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@GetMapping("/memberLogin.do")
	public void memberLogin() {
	}
	
	@GetMapping("/memberDetail.do")
	public void memberDetail(Authentication authentication, Model model) { //principal??? ?????? ?????? ????????? ???????????? 2????????????
		//1. secuirty context holder bean ????????? ?????? ?????? ???????????? ??????
		//2. handler??? ??????????????? Authenticaiton??? ???????????? ???????????? ????????????.
		//3. @AuthenticationPrincipal ?????????????????? ???????????? ???????????? ?????? ???????????? ??????. Member??? userDetails??? ???????????? ??????????????????.
//		Authentication authentication =
//		SecurityContextHolder.getContext().getAuthentication(); // ????????? ????????? ????????? ???????????????.
		Member member = (Member)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		//UsernamePasswordAuthenticationToken 
		log.debug("member = {}",member);

		model.addAttribute("loginMember", member);
	}

	@GetMapping("/memberEnroll.do")
	public void memberEnroll() {
		
	}
	
	@PostMapping("/memberEnroll.do")
	public String memberEnroll(
			@RequestParam(value = "id") String memberId,
			@RequestParam(value = "password") String memberPassword,
			@RequestParam(value = "name") String memberName,
			@RequestParam(value = "phone") String phone,
			@RequestParam(value = "email") String email,
			@RequestParam(value = "birthday") String _birthday,
			@RequestParam(value = "address2") String addr2,
			@RequestParam(value = "address3") String addr3,
			@RequestParam(value="upfile", required= false) MultipartFile upFile,
			HttpServletRequest request,
    		Authentication oldAuthentication,
			RedirectAttributes redirectAttr
//			,HttpServletRequest request
			) throws Exception {
		try {
			request.setCharacterEncoding("UTF-8");
//			//MultipartRequest?????? ??????
//			String saveDirectory = getServletContext().getRealPath("/upload/memberProfile");// / -> Web Root Directory
//			int maxPostSize = 30 * 1024 * 1024;
//			String encoding = "utf-8";
//			FileRenamePolicy policy = new MvcFileRenamePolicy();
//			MultipartRequest multipartReq = 
//					new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
			
			//????????? ?????????
			String address = addr2 + addr3;
			String locCode = null;
			List<Location> locationList = utilsService.selectLocationList();
			Iterator<Location> iter = locationList.iterator();
			while(iter.hasNext()) {
				Location loc = (Location)iter.next();
				if(address.contains(loc.getLocName())) {
					locCode = loc.getLocCode();
					break;
				}
			}
			Date birthday = java.sql.Date.valueOf(_birthday);
			Member member = new Member(memberId, memberPassword, memberName,
					birthday, email, phone, true, 'n', null, null, null, address, locCode, null);
			log.info("member = {}", member);

			String saveDirectory =
					request.getServletContext().getRealPath("/resources/upload/member");
			File dir = new File(saveDirectory);
			if(!dir.exists())
				dir.mkdirs(); // ???????????? ??????X ??? ?????? ??????
			
			if(!upFile.isEmpty()) {
				File renamedFile = ShareCarrotUtils.getRenamedFile(saveDirectory, upFile.getOriginalFilename());
				//????????????
				upFile.transferTo(renamedFile);
				member.setProfileOriginal(upFile.getOriginalFilename());
				member.setProfileRenamed(renamedFile.getName());				
			}
			
			
			Shop shop = new Shop();
			String rawPassword = member.getPassword();
			String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
			log.info("rawPassword = {}", rawPassword);
			log.info("encodedPassword = {}", encodedPassword);			
			member.setMemberPassword(encodedPassword);
			
			//1. ????????????
			int result = memberService.memberEnroll(member);
			shop.setShopId(member.getMemberId().substring(0, 1) + String.valueOf((int)(Math.random()*9)+1));
			shop.setMemberId(memberId);
			shopService.shopEnroll(shop);
			Authority auth = new Authority(MemberService.ROLE_USER, memberId);
			int authset = memberService.setAuthority(auth);	
		}catch(Exception e) {
			//1. ????????????
			log.error(e.getMessage(), e);
			//2. ?????? spring container??? ?????? ???.
			throw e;
		}
		redirectAttr.addFlashAttribute("msg", "???????????? ??????");
		return "redirect:/";
	}
	
	@GetMapping("/checkIdDuplicate.do")
	public ResponseEntity<?> checkIdDuplicate(@RequestParam String id){
		//?????? ??????
		Member member = memberService.selectOneMember(id);
		boolean usable = (member == null);

		//2. json ?????? ??????
		Map<String, Object> map = new HashMap<>();
		map.put("usable", usable);
			
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
		return new ResponseEntity<>(map, headers, HttpStatus.OK);
	}
	
    /* ????????? ?????? */
	@GetMapping("/emailCheck.do")
	@ResponseBody
    public String emailCheck(String email) throws Exception{
        
//        log.info("????????? ????????? ?????? ??????");
//        log.info("???????????? : " + email);
                
	    Random random = new Random();
	    int checkNum = random.nextInt(888888) + 111111;
        log.info("???????????? " + checkNum);
        
        /* ????????? ????????? */
        String host = "smtp.naver.com";
        final String username = "testyongdo1";
        final String password = "sharecarrot";
        int port = 465;
        
        String recipient = email;
        String subject = "???????????? ?????? ????????? ?????????.";
        String body = 
                "??????????????? ?????????????????? ???????????????." +
                "\n" + 
                "?????? ????????? " + checkNum + "?????????." + 
                "\n" + 
                "?????? ??????????????? ???????????? ???????????? ???????????? ?????????.";
        
        Properties props = System.getProperties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.tr ust", host);
        
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
        	String un=username;
        	String pw=password;
        	protected PasswordAuthentication getPasswordAuthentication() {
        		return new PasswordAuthentication(un, pw);
        	}
        });
        session.setDebug(true);
        
        Message mimeMessage = new MimeMessage(session);
        mimeMessage.setFrom(new InternetAddress("testyongdo1@naver.com"));
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        mimeMessage.setSubject(subject);
        mimeMessage.setText(body);
        Transport.send(mimeMessage);
        
        return String.valueOf(checkNum);
	}	
	

    @PostMapping("/memberUpdate.do")
    public String memberUpdate(
			@RequestParam(value = "id") String memberId,
			@RequestParam(value = "name") String memberName,
			@RequestParam(value = "birthday") Date birthday,
			@RequestParam(value = "email") String email,
			@RequestParam(value = "phone") String phone,
			@RequestParam(value = "address") String address,
			@RequestParam(value="upfile", required= false) MultipartFile upFile,
			HttpServletRequest request,
    		Authentication oldAuthentication,
 		    RedirectAttributes redirectAttr) throws IllegalStateException, IOException {
 	    //1. ???????????? : db ??????
    	Member updateMember = new Member(memberId, ((Member)oldAuthentication.getPrincipal()).getPassword(), memberName,
				birthday, email, phone, ((Member)oldAuthentication.getPrincipal()).isEnabled(), 
				((Member)oldAuthentication.getPrincipal()).getQuitYn(), ((Member)oldAuthentication.getPrincipal()).getMemberEnrollDate()
				, ((Member)oldAuthentication.getPrincipal()).getProfileOriginal(), ((Member)oldAuthentication.getPrincipal()).getProfileRenamed()
				, address, ((Member)oldAuthentication.getPrincipal()).getLocCode(), null);
		log.info("member = {}", updateMember);
 	    //updateMember??? authorities setting
 	    List<SimpleGrantedAuthority> authorities = new ArrayList<>();
 	    for(GrantedAuthority auth : oldAuthentication.getAuthorities()) {
 		    SimpleGrantedAuthority simpleGrantedAuthority = 
 				    new SimpleGrantedAuthority(auth.getAuthority());
 		    authorities.add(simpleGrantedAuthority);
 	    }
 	    
 	   String saveDirectory =
				request.getServletContext().getRealPath("/resources/upload/member");
		File dir = new File(saveDirectory);
		if(!dir.exists())
			dir.mkdirs(); // ???????????? ??????X ??? ?????? ??????
		
		if(!upFile.isEmpty()) {
			File renamedFile = ShareCarrotUtils.getRenamedFile(saveDirectory, upFile.getOriginalFilename());
			//????????????
			upFile.transferTo(renamedFile);
			updateMember.setProfileOriginal(upFile.getOriginalFilename());
			updateMember.setProfileRenamed(renamedFile.getName());				
		}
	   
	    updateMember.setAuthorities(authorities); 
	    //????????? ???????????????
	    
	    //2. security context?????? principal ??????
	    Authentication newAuthentication = 
	  		    new UsernamePasswordAuthenticationToken(
				 	    updateMember, 
					    oldAuthentication.getCredentials(),
					    oldAuthentication.getAuthorities()
					    );
	    SecurityContextHolder.getContext().setAuthentication(newAuthentication);
	   
	    //db?????? ???????????????.
	    int result = memberService.memberUpdate(updateMember);
	    
	    //3. ????????? ?????????
	    redirectAttr.addFlashAttribute("msg", "????????? ?????? ?????? ??????");
	   
	    return "redirect:/member/memberDetail.do";
    }	
    
    @GetMapping("/findId.do")
    public void findId() {
    	
    }
    
    @PostMapping("/findId.do")
    public String findId(
    					@RequestParam String memberName,
    					@RequestParam String email,
    					Model model){
    	log.info("log={}, {}", memberName, email);
    	Map<String, Object> param = new HashMap<>();
    	param.put("memberName", memberName);
    	param.put("email", email);
    	String memberId = memberService.findId(param);
    	log.info("memberId = {}", memberId);
    	//null??????
    	if(memberId != null) {
    		model.addAttribute("memberId", memberId);    		
    	}
    	
    	return "/member/checkId";
    	
    }
    
    @GetMapping("/findPassword.do")
    public void findPassword() {
    	
    }
    
    @PostMapping("/searchPassword.do")
    public String searchPassword(
    				@RequestParam String memberId,
    				@RequestParam String email,
    				Model model) throws AddressException, MessagingException {
    	//?????????????????? ??????
    	String tempPassword = "123456";
    
    	//????????? ???????????? ?????? ??????
    	log.info("log={}, {}", memberId, email);
    	Map<String, Object> param = new HashMap<>();
    	param.put("memberId", memberId);
    	param.put("email", email);
    	//??????????????? ????????? ?????? ?????? ??????????????? ??????
    	Member member = memberService.searchPassword(param);
    	if(member == null) {
            return "/member/checkPassword";
    	}
    	log.info("???????????? = {}", member);
    	//????????? ???????????? ?????????
    	String encodedPassword = bcryptPasswordEncoder.encode(tempPassword);
    	member.setMemberPassword(encodedPassword);
    	
    	//????????? ????????? ??????????????? ????????????????????? update
    	int result = memberService.memberPasswordUpdate(member);
    	
    	//?????????????????? ????????? ??????
    	
    	 /* ????????? ????????? */
        String host = "smtp.naver.com";
        final String username = "testyongdo1";
        final String password = "sharecarrot";
        int port = 465;
        
        String recipient = email;
        String subject = "???????????? ????????? ?????? ?????? ?????????????????????.";
        String body = 
                "ShareCarrot ?????????????????? ???????????????." +
                "\n" + 
                "?????? ??????????????? " + tempPassword + " ?????????." + 
                "\n" + 
                "????????????????????? ????????? ???????????????. ????????? ????????? ????????? ??????????????????.";
        
        Properties props = System.getProperties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.tr ust", host);
        
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
        	String un=username;
        	String pw=password;
        	protected PasswordAuthentication getPasswordAuthentication() {
        		return new PasswordAuthentication(un, pw);
        	}
        });
        session.setDebug(true);
        
        Message mimeMessage = new MimeMessage(session);
        mimeMessage.setFrom(new InternetAddress("testyongdo1@naver.com"));
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        mimeMessage.setSubject(subject);
        mimeMessage.setText(body);
        Transport.send(mimeMessage);
        
        model.addAttribute("email", email);

        return "/member/checkPassword";
    }
    
    @GetMapping("/changePassword.do")
    public void changePassword() {
    	
    }
    
    @PostMapping("/changePassword.do")
    public String changePassword(
    			@RequestParam Map<String, Object> param,
    			Model model
    		) {
    	log.info("param = {}", param);
    	String oldPassword = (String)param.get("oldPassword");
    	String newPassword = (String)param.get("newPassword");
    	String memberId = (String)param.get("memberId");
    	//????????? ID??? ???????????? ??????
    	Member member = memberService.selectOneMember(memberId);
    	//?????? ??????????????? ????????? ????????? ???????????? ??????(T / F)
    	Boolean bool = bcryptPasswordEncoder.matches(oldPassword, member.getPassword());
    	log.info("??????????????? ?????????? = {}" , bool);

    	if(!bool){
    		model.addAttribute("msg1", "???????????? ??????????????? ?????? ??????????????? ????????????.");
    		return "/member/updatePassword";
    	}
    	
    	String encodednewPassword = bcryptPasswordEncoder.encode(newPassword);
    	member.setMemberPassword(encodednewPassword);
    	//????????? ???????????? update
    	int result = memberService.memberPasswordUpdate(member);
    	if(result != 1) {
    		model.addAttribute("msg2", "???????????? ????????? ?????????????????????. ?????? ??????????????????.");
    		return "/member/updatePassword";
    	}
    	model.addAttribute("msg3","??????????????? ??????????????? ?????????????????????.");
    	return "/member/updatePassword";
    }
    
}
