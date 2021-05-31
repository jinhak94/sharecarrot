package com.kh.sharecarrot.shopmanage.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.sharecarrot.product.model.vo.Product;
import com.kh.sharecarrot.product.model.vo.ProductImage;
import com.kh.sharecarrot.shop.model.vo.Shop;

@Repository
public class ShopManageDaoImpl implements ShopManageDao{

	@Autowired
	private SqlSessionTemplate session;
	
	@Override
	public int productEnroll(Product product) {
		return session.insert("shopmanage.productEnroll", product);
	}

	@Override
	public int productImageEnroll(ProductImage productImage) {
		return session.insert("shopmanage.productImageEnroll", productImage);
	}

	@Override
	public Shop selectShopInfo(String memberId) {
		return session.selectOne("shopmanage.selectShopInfo", memberId);
	}
	
	@Override
	public Product selectProduct(Product product) {
		return session.selectOne("shopmanage.selectProduct", product);
	}

	@Override
	public List<Product> selectProductList(Product product) {
		return session.selectList("shopmanage.selectProductList", product);
	}
	
	@Override
	public int selectProductListCount(Product product) {
		return session.selectOne("shopmanage.selectProductListCount",product);
	}

	@Override
	public List<ProductImage> selectProductImageList(Product product) {
		return session.selectList("shopmanage.selectProductImageList", product);
	}

	@Override
	public int updateProductYnh(Product product) {
		return session.update("shopmanage.updateProductYnh", product);
	}

	@Override
	public int deleteProduct(Product product) {
		return session.update("shopmanage.deleteProduct", product);
	}
	
	@Override
	public int deleteProductImage(Product product) {
		return session.delete("shopmanage.deleteProductImage", product);
	}

	@Override
	public int updateProduct(Product product) {
		return session.update("shopmanage.updateProduct", product);
	}

	@Override
	public List<Product> selectTransactionList(Product product) {
		return session.selectList("shopmanage.selectTransactionList", product);
	}

	@Override
	public int selectTransactionListCount(Product product) {
		return session.selectOne("shopmanage.selectTransactionListCount",product);
	}

}
