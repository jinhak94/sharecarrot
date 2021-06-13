package com.kh.sharecarrot.board.model.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.sharecarrot.board.model.dao.BoardDao;
import com.kh.sharecarrot.board.model.vo.Board;
import com.kh.sharecarrot.board.model.vo.BoardComment;
import com.kh.sharecarrot.board.model.vo.BoardImage;
import com.kh.sharecarrot.board.model.vo.BoardLike;

@Service
public class BoardServiceImpl implements BoardService{

	@Autowired
	private BoardDao boardDao;

	@Override
	public List<Board> selectBoardList(Map<String, Object> param) {
		return boardDao.selectBoardList(param);
	}

	@Override
	public int getTotalContents(String boardCategory) {
		return boardDao.getTotalContents(boardCategory);
	}

	@Override
	public int insertBorad(Board board) {
		int result = 0;
		//1. board객체 등록
		result = boardDao.insertBoard(board);
		
		//2.boardImageList 등록
		if(!board.getBoardImageList().isEmpty()) {
			for(BoardImage boardImg : board.getBoardImageList()) {
				boardImg.setBoardNo(board.getBoardNo());
				result = boardDao.insertBoardImg(boardImg);
			}
		}
		return result;
	}

	@Override
	public int boardDelete(int boardNo) {
		return boardDao.boardDelete(boardNo);
	}

	@Override
	public Board selectOneBoard(int boardNo) {
		return boardDao.selectOneBoard(boardNo);
	}

	@Override
	public int updateBorad(Board board, String[] boardImgId) {
		int result = 0;
		
		//1. board객체 수정
		result = boardDao.updateBoard(board);
		
		//2.boardImageList 등록
		if(!board.getBoardImageList().isEmpty()) {
			for(BoardImage boardImg : board.getBoardImageList()) {
				boardImg.setBoardNo(board.getBoardNo());
				result = boardDao.insertBoardImg(boardImg);
			}
		}
		
		//3. boardImageId 삭제
		List<String> list = null;
		if(boardImgId != null)
			list = Arrays.asList(boardImgId);
		if(list != null) {
			for(String id : list) {
				result = boardDao.deleteBoardImg(id);
			}
		}
		
		
		return result;
	}

	@Override
	public List<BoardLike> selectBoardLikeList(String memberId) {
		return boardDao.selectBoardLikeList(memberId);
	}

	@Override
	public int updateBoardLike(Map<String, Object> param) {
		int result = 0;
		int likeBool = (int)param.get("likeBool");
		
		//1. board에 like 컬럼 update
		result = boardDao.updateBoardLike(param);
		
		//2. board_like 테이블 insert or delete
		if(likeBool == 1) {
			result = boardDao.insertBoardLike(param);			
		} else if(likeBool == 0){
			result = boardDao.deleteBoardLike(param);
		}
		
		return result;
	}

	@Override
	public int boardCommentInsert(BoardComment boardComment) {
		return boardDao.boardCommentInsert(boardComment);
	}

	@Override
	public List<BoardComment> boardCommentSelect(int boardNo) {
		return boardDao.boardCommentSelect(boardNo);
	}

	@Override
	public int boardCommentUpdate(BoardComment boardComment) {
		return boardDao.boardCommentUpdate(boardComment);
	}

	@Override
	public int boardCommentDelete(String boardCommentId) {
		return boardDao.boardCommentDelete(boardCommentId);
	}
}
