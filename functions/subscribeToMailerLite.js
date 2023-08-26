const axios = require("axios");

exports.handler = async (event) => {
  const parsedData = new URLSearchParams(event.body);
  const dataObj = {};
  for (var pair of parsedData.entries()) {
    dataObj[pair[0]] = pair[1];
  }
  console.log("DataObj: ", dataObj);
  const email = dataObj.email;

  // Get environment variables
  const { ML_APIKEY, ML_GROUPID } = process.env;

  // Create the contact in Mailjet
  try {
    const response = await axios.post(
      "https://connect.mailerlite.com/api/subscribers",
      {
        email: email,
        groups: [ML_GROUPID],
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + ML_APIKEY,
        },
      }
    );
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "Contact added to MailerLite successfully",
      }),
    };
  } catch (error) {
    console.error("Error adding contact to MailerLite:", error);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to add contact to MailerLite",
      }),
    };
  }
};
