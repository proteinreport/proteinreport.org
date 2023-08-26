exports.handler = async function (event, context) {
    // Get environment variables
  const { MJ_APIKEY_PUBLIC, MJ_APIKEY_PRIVATE, MJ_LIST_ID } = process.env;
  console.log(MJ_LIST_ID);
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello World" }),
  };
};
