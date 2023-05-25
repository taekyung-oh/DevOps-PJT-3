module.exports.handler = async (event) => {

  for (const record of event.Records) {
    const messageAttrs = JSON.parse(record.body).MessageAttributes

    const productId = messageAttrs.productId?.Value
    const sku = messageAttrs.productSku?.Value
    const factoryId = messageAttrs.factoryId?.Value
    const orderQty = messageAttrs.orderQty?.Value

    console.log(`productId = ${productId} , sku = ${sku} , factoryId = ${factoryId} , orderQty = ${orderQty}`)

  }
  
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Go Serverless v3.0! Your function executed successfully!',
        input: event,
      },
      null,
      2
    ),
  };
};
