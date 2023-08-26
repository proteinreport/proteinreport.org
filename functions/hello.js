exports.handler = async function (event, context) {
  // Get environment variables
  const { MJ_APIKEY_PUBLIC, MJ_APIKEY_PRIVATE, MJ_LIST_ID } = process.env;

  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
};
