package com.kh.sharecarrot.storereviews.model.dao;

import java.util.List;

import com.kh.sharecarrot.storereviews.model.vo.ReviewImage;
import com.kh.sharecarrot.storereviews.model.vo.StoreReviews;

public interface StoreReviewsDao {

	List<StoreReviews> selectStoreReviewsList(String shopId);

	List<ReviewImage> selectReviewImageList(int reviewNo);

}