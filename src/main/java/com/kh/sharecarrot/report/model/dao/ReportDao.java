package com.kh.sharecarrot.report.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.sharecarrot.report.model.vo.Report;
import com.kh.sharecarrot.report.model.vo.ReportImage;

public interface ReportDao {

	List<Report> selectReportList(Map<String, Object> param);
	Report selectOneReprotDetail(int no);
	int updateReportYn(int no);
	int getTotalContents();
	int insertReport(Report report);
	int insertReportImg(ReportImage reportImg);
	List<ReportImage> selectReprotImageDetail(int no);
	ReportImage selectOneReportImage(int no);

}
