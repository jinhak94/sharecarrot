package com.kh.sharecarrot.chatting.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.sharecarrot.chatting.model.vo.ChattingMessage;
import com.kh.sharecarrot.chatting.model.vo.ChattingRoom;

@Repository
public class ChattingDaoImpl implements ChattingDao {

	@Autowired
	private SqlSessionTemplate session;


	@Override
	public List<ChattingMessage> selectMessageList(int roomNo) {
		return session.selectList("chat.selectMessageList", roomNo);
	}

	@Override
	public ChattingRoom selectRoomNo(Map<String, Object> param) {
		return session.selectOne("chat.selectRoomNo", param);
	}

	@Override
	public int insertChattingRoom(Map<String, Object> param) {
		return session.insert("chat.insertChattingRoom", param);
	}

	@Override
	public List<ChattingRoom> selectRoomList(String loginMemberId) {
		return session.selectList("chat.selectRoomList", loginMemberId);
	}

	@Override
	public int insertChattingMessage(ChattingMessage chattingMessage) {
		return session.insert("chat.insertChattingMessage", chattingMessage);
	}

	@Override
	public String selectLastChat(int roomNo) {
		return session.selectOne("chat.selectLastChat", roomNo);
	}
	
	
	
}
