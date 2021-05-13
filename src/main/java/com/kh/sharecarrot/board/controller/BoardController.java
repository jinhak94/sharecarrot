package com.kh.sharecarrot.board.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.sharecarrot.board.model.service.BoardService;
import com.kh.sharecarrot.board.model.vo.Board;
import com.kh.sharecarrot.board.model.vo.BoardImage;
import com.kh.sharecarrot.common.ShareCarrotUtils;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private ResourceLoader resourceLoader; // Resource 객체를 관리
	
	@Autowired
	private ServletContext servletContext; // application객체 파일의 절대경로를 알아낼수 있음
	
	@GetMapping("/boardList.do")
	public void boardList(@RequestParam(defaultValue = "1") int cPage, @RequestParam(defaultValue =  "") String boardCategory,Model model, HttpServletRequest request) {
		log.info("boardCategory = {}", boardCategory);
		//사용자 입력값
		int numPerPage = 5;
		Map<String, Object> param = new HashMap<>();
		param.put("numPerPage", numPerPage);
		param.put("cPage", cPage);
		param.put("boardCategory", boardCategory);
		//select boardList
		List<Board> boardList = boardService.selectBoardList(param);
		
		//get pageBar
		int totalContents = boardService.getTotalContents(boardCategory);
		log.debug("totalContents = {}", totalContents);
		String url = request.getRequestURI();
		log.debug("url = {}", url);
		String pageBar = ShareCarrotUtils.getPageBar(totalContents, cPage, numPerPage, url);
		
		//jsp
		model.addAttribute("boardList", boardList);
		model.addAttribute("pageBar", pageBar);
	}
	
	@GetMapping("/boardEnroll.do")
	public void boardEnroll() {
	}
	
	@PostMapping("/boardEnroll.do")
	public String boardEnroll(@ModelAttribute Board board,
								@RequestParam(value="upfile", required= false) MultipartFile[] upFiles,
								HttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {
		request.setCharacterEncoding("UTF-8");
		log.info("board = {}", board);
		try {
			//파일저장
			//saveDir
			String saveDirectory =
					request.getServletContext().getRealPath("/resources/upload/board");
			File dir = new File(saveDirectory);
			if(!dir.exists())
				dir.mkdirs(); // 지정경로 존재X 시 폴더 생성
			
			//BoardImageList
			List<BoardImage> boardImgList = new ArrayList<>();
			
			for(MultipartFile upFile : upFiles) {
				if(upFile.isEmpty()) continue;
				
				//저장할 파일명
				File renamedFile = ShareCarrotUtils.getRenamedFile(saveDirectory, upFile.getOriginalFilename());
				
				//파일저장
				upFile.transferTo(renamedFile);
				BoardImage boardImg = new BoardImage();
				boardImg.setBoardImgOrigin(upFile.getOriginalFilename());
				boardImg.setBoardImgRenamed(renamedFile.getName());
				
				boardImgList.add(boardImg);
			}
			
			board.setBoardImageList(boardImgList);
			int reuslt = boardService.insertBorad(board);
			
		} catch(IllegalStateException e) {
			log.error("첨부파일 저장오류", e);
			e.printStackTrace();
			throw e;
		} catch(Exception e) {
			log.error("게시물 등록 오류", e);
			e.printStackTrace();
			throw e;
		}
		return "redirect:/board/boardList.do";
	}
	
}
