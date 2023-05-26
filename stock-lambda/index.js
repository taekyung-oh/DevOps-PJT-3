const axios = require('axios').default

module.exports.handler = async (event) => {

  for (const record of event.Records) {
    const messageAttrs = JSON.parse(record.body).MessageAttributes

    const productId = messageAttrs.productId?.Value
    const sku = messageAttrs.productSku?.Value
    const factoryId = messageAttrs.factoryId?.Value
    const orderQty = messageAttrs.orderQty?.Value

    console.log(`productId = ${productId} , sku = ${sku} , factoryId = ${factoryId} , orderQty = ${orderQty}`)

    const factoryUrl = 'http://project3-factory.coz-devops.click/api/manufactures'
    const payload = {
      MessageGroupId : "stock-arrival-group",
      MessageAttributeProductId : sku,
      MessageAttributeProductCnt : orderQty,
      MessageAttributeFactoryId : factoryId,
      MessageAttributeRequester : '오태경',
      CallbackUrl : 'https://f1sgb3lkh4.execute-api.ap-northeast-2.amazonaws.com/product/donut'
    }

    await axios.post(factoryUrl, payload, {
      headers: {
          'Content-Type': 'application/json'
      }
    })
  }
  
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `공장 주문 요청 성공 productId = ${productId} , sku = ${sku} , factoryId = ${factoryId} , orderQty = ${orderQty}`,        
      },
      null,
      2
    ),
  };
};
