package com.kh.sharecarrot.board.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.sharecarrot.board.model.service.BoardService;
import com.kh.sharecarrot.board.model.vo.Board;
import com.kh.sharecarrot.board.model.vo.BoardComment;
import com.kh.sharecarrot.board.model.vo.BoardImage;
import com.kh.sharecarrot.board.model.vo.BoardLike;
import com.kh.sharecarrot.common.ShareCarrotUtils;
import com.kh.sharecarrot.utils.model.service.UtilsService;
import com.kh.sharecarrot.utils.model.vo.Location;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	@Autowired
	private UtilsService utilsService;

	@GetMapping("/boardList.do")
	public void boardList(Model model, Principal principal) {
		List<BoardLike> boardLikeList = null;
		
		//로그인을 한경우
		String memberId = principal.getName();
		if(!(memberId == null || memberId.equals(""))) {
			boardLikeList = boardService.selectBoardLikeList(memberId);
		}
	
		List<Location> locationList = utilsService.selectLocationList();
		model.addAttribute("locationList",locationList );
		model.addAttribute("boardLikeList", boardLikeList);
		
	}
	
	@ResponseBody
	@GetMapping("/searchBoardList.do")
	public List<Board> searchBoardList(@RequestParam(defaultValue = "1") int cPage, int numPerPage,  
					@RequestParam(defaultValue =  "") String boardCategory, @RequestParam(defaultValue = "") String locCode, @RequestParam(defaultValue = "") String code) {

		Map<String, Object> param = new HashMap<>();
		param.put("cPage", cPage);
		param.put("numPerPage", numPerPage);
		param.put("boardCategory", boardCategory);
		param.put("locCode", locCode);
		param.put("code", code);
		
		List<Board> boardList = boardService.selectBoardList(param);
		
		return boardList;
	}
	
	
	@GetMapping("/boardEnroll.do")
	public void boardEnroll(Model model) {
		List<Location> locationList = utilsService.selectLocationList();
		model.addAttribute(locationList);
	}
	
	@PostMapping("/boardEnroll.do")
	public String boardEnroll(@ModelAttribute Board board,
								@RequestParam(value="upfile", required= false) MultipartFile[] upFiles,
								HttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		//줄바꿈, 개행처리
		board.setBoardContent(board.getBoardContent().replaceAll("\r\n", "<br>"));
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
			redirectAttr.addFlashAttribute("msg", "게시글 등록이 완료되었습니다.");
			
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
	
	@PostMapping("/boardUpdate.do")
	public String boardUpdate(@ModelAttribute Board board, String[] boardImgId, 
						@RequestParam(value="upfile", required= false) MultipartFile[] upFiles,
						HttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {

		//줄바꿈, 개행처리
			board.setBoardContent(board.getBoardContent().replaceAll("\r\n", "<br>"));
				
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
			
			int reuslt = boardService.updateBorad(board, boardImgId);				
			
				
			redirectAttr.addFlashAttribute("msg", "게시글 수정이 완료되었습니다.");
			
		} catch(IllegalStateException e) {
			log.error("첨부파일 저장오류", e);
			e.printStackTrace();
			throw e;
		} catch(Exception e) {
			log.error("게시물 수정 오류", e);
			e.printStackTrace();
			throw e;
		}
		
		return "redirect:/board/boardList.do";
	}
	
	@GetMapping("/boardUpdate.do")
	public void boardUpdate(@RequestParam int boardNo, Model model) {
		Board board = boardService.selectOneBoard(boardNo);
		List<Location> locationList = utilsService.selectLocationList();
		//줄바꿈, 개행처리
		board.setBoardContent(board.getBoardContent().replaceAll("<br>", "\r\n"));
		model.addAttribute(locationList);
		model.addAttribute("board", board);
	}
	
	
	@PostMapping("/boardDelete.do")
	public String boardDelete(@RequestParam int boardNo, RedirectAttributes redirectAttr) {
		try {
			int reuslt = boardService.boardDelete(boardNo);			
			redirectAttr.addFlashAttribute("msg", "게시물이 삭제되었습니다.");
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	
		return "redirect:/board/boardList.do";
	}
	
	@PostMapping("/boardLike.do")
	@ResponseBody
	public void boardLike(@RequestParam String boardNo, @RequestParam int likeCnt, @RequestParam int likeBool ,@RequestParam String memberId) {
		//likeBool == 0 --> boardLike -1;
	
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("boardNo", boardNo);
		param.put("likeCnt", likeCnt);
		param.put("memberId", memberId);
		param.put("likeBool", likeBool);

		int result = boardService.updateBoardLike(param);
	}
	
	@PostMapping(value = "/boardCommentInsert.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String boardCommentInsert(@ModelAttribute BoardComment boardComment) {
		log.info("boardComment = {}", boardComment);
		//업무로직
		int result = boardService.boardCommentInsert(boardComment);
		
		return "댓글등록이 완료되었습니다.";
	}
	
	@GetMapping("/boardCommentSelect.do")
	@ResponseBody
	public List<BoardComment> boardCommentSelect(@RequestParam int boardNo){
		List<BoardComment> list = boardService.boardCommentSelect(boardNo);
		
		return list;
	}
	
	@PostMapping(value = "/boardCommentUpdate.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String boardCommentUpdate(@ModelAttribute BoardComment boardComment) {
		int result = boardService.boardCommentUpdate(boardComment);
		return result > 0 ? "댓글 수정이 완료되었습니다." : "댓글 수정에 실패하였습니다.";
	}
	
	@PostMapping(value = "/boardCommentDelete.do", produces = "application/text; charset=utf-8")
	@ResponseBody
	public String boardCommentDelete(@RequestParam String boardCommentId) {
		log.info("boardCommentId = {}", boardCommentId);
		int result = boardService.boardCommentDelete(boardCommentId);
		return result > 0 ? "댓글 수정이 완료되었습니다." : "댓글 수정에 실패하였습니다.";
	}
}
