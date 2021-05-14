package com.kh.sharecarrot.utils.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.sharecarrot.utils.model.vo.Location;

@Repository
public class UtilsDaoImpl implements UtilsDao {
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<Location> selectLocationList() {
		return session.selectList("utils.selectLocationList");
	}

}
