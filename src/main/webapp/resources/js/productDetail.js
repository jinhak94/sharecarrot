
/* 로컬 스토리지에 변수 담기 */

console.log(productId, productName, productImg,productPrice);
const recentProduct = {
  productId,
  productName,
  productImg,
  productPrice
}

let tempSave = JSON.stringify(recentProduct);
for(let i = 1; i <= 3; i++){
  recent = localStorage.getItem("최근본상품_" + i);
  if(recent == null){ // 없으면 최근본상품 추가
    localStorage.setItem("최근본상품_" + i , tempSave);
    break;
  }
  else { 
    localStorage.setItem("최근본상품_" + i, tempSave);
    tempSave = recent; 

    //기존에 있던 상품을 JSON으로 parsing
    let tempData = JSON.parse(tempSave);
    //기존에 있던 상품의 id와 현재 본 상품의 id를 비교해서 -> 같으면 break.
    if(tempData.productId == productId) {
      break;
    }
  }
}