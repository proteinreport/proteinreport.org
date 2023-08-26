exports.handler = async function (event, context) {
  // Get environment variables
  const { MJ_APIKEY_PUBLIC, MJ_APIKEY_PRIVATE, MJ_LIST_ID } = process.env;

  const parsedData = new URLSearchParams(event.body);
  const dataObj = {};
  for (var pair of parsedData.entries()) {
    dataObj[pair[0]] = pair[1];
  }
  console.log("DataObj: ", dataObj);
  const email = dataObj.email;

  return {
    statusCode: 200,
    body: JSON.stringify({
      DataObj: JSON.stringify(dataObj),
      email: email,
    }),
  };
};
