package com.kh.sharecarrot.notice.model.service;

import java.util.List;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.sharecarrot.notice.model.dao.NoticeDao;
import com.kh.sharecarrot.notice.model.vo.Notice;

@Service
public class NoticeServiceImpl implements NoticeService {

	@Autowired
	private NoticeDao noticeDao;

	@Override
	public List<Notice> selectNoticeList(Map<String, Object> param) {
		return noticeDao.selectNoticetList(param);
	}

	@Override
	public int getTotalContents() {
		return noticeDao.getTotalContents();
	}

	@Override
	public Notice selectOneNoticeDetail(int no) {
		return noticeDao.selectOneNoticeDetail(no);
	}
	

}
