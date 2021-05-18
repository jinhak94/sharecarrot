package com.kh.sharecarrot.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.sharecarrot.member.model.vo.Member;

@Repository
public class MemberDaoImpl implements MemberDao{

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public Member selectOneMember(String id) {
		return session.selectOne("member.selectOneMember",id);
	}

	@Override
	public int memberEnroll(Member member) {
		return session.insert("member.memberEnroll",member);
	}
}
