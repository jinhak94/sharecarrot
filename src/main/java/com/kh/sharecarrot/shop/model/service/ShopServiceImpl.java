package com.kh.sharecarrot.shop.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.sharecarrot.member.model.vo.Member;
import com.kh.sharecarrot.product.model.vo.Product;
import com.kh.sharecarrot.shop.model.dao.ShopDao;
import com.kh.sharecarrot.shop.model.vo.Shop;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ShopServiceImpl implements ShopService{
	
	@Autowired
	private ShopDao shopDao;
	
	
	@Override
	public int updateVisitCount(String shopId) {
		return shopDao.updateVisitCount(shopId);
	}

	
	@Override
	public Shop selectShopOne(Map<String, Object> param) {
		return shopDao.selectShopOne(param);
	}


	@Override
	public List<Product> selectshopProductList(String shopId) {
		return shopDao.selectshopProductList(shopId);
	}


	@Override
	public int selectOpenDay(String shopId) {
		return shopDao.selectOpenDay(shopId);
	}


	@Override
	public String selectMemberId(String shopId) {
		return shopDao.selectMemberId(shopId);
	}


	@Override
	public Shop selectShop(String shopId) {
		return shopDao.selectShop(shopId);
	}


	@Override
	public Member selectProfilOne(String shopId) {
		return shopDao.selectProfilOne(shopId);
	}


	@Override
	public String selectMembershopId(String memberId) {
		return shopDao.selectMembershopId(memberId);
	}


	@Override
	public int selectsellCount(String shopId) {
		return shopDao.selectsellCount(shopId);

	}
	
	public String selectShopId(String loginMemberId) {
		return shopDao.selectShopId(loginMemberId);

	}


	
}
