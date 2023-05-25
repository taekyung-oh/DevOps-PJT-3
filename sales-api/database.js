const AWS = require("aws-sdk");
const sm = new AWS.SecretsManager({region: 'ap-northeast-2'});

const mysql = require('mysql2/promise');
require('dotenv').config()

const connectDb = async (req, res, next) => {
  const smParams = {
    SecretId: process.env.SECRET_MANAGER_ARN
  };

  const smResult = await sm.getSecretValue(smParams).promise();

  const secretObject = JSON.parse(smResult.SecretString)

  const host = secretObject.MYSQL_HOST
  const user = secretObject.MYSQL_USERNAME
  const password = secretObject.MYSQL_PASSWORD
  const database = secretObject.MYSQL_DATABASE

  try {
    req.conn = await mysql.createConnection({ host, user, password, database })
    next()
  }
  catch(e) {
    console.log(e)
    res.status(500).json({ message: "데이터베이스 연결 오류" })
  }
}

const getProduct = (sku) => `
  SELECT BIN_TO_UUID(product_id) as product_id, name, price, stock, BIN_TO_UUID(factory_id) as factory_id, BIN_TO_UUID(ad_id) as ad_id
  FROM product
  WHERE sku = "${sku}"
`

const setStock = (productId, stock) => `
  UPDATE product SET stock = ${stock} WHERE product_id = UUID_TO_BIN('${productId}')
`

module.exports = {
  connectDb,
  queries: {
    getProduct,
    setStock
  }
}