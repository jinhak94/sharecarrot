package com.kh.sharecarrot.reviewcomment.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.sharecarrot.reviewcomment.model.vo.ReviewComment;

@Repository
public class ReviewCommentDaoImpl implements ReviewCommentDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public int insertReviewComment(ReviewComment reviewComment) {
		// TODO Auto-generated method stub
		return session.insert("reviewComment.insertReviewComment",reviewComment);
	}
}
