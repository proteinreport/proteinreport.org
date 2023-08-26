const axios = require('axios');

exports.handler = async (event) => {
  try {
    const parsedData = new URLSearchParams(event.body);
    const dataObj = {};
    for (var pair of parsedData.entries()) {
      dataObj[pair[0]] = pair[1];
    }

    const email = dataObj.email;

    // Get environment variables
    const { MAILERLITE_PRODUCTION_API_KEY, MAILERLITE_PRODUCTION_NEWSLETTER_GROUP_ID } = process.env;

    // Create the subscriber in MailerLite
    const response = await axios.post(
      'https://connect.mailerlite.com/api/subscribers',
      {
        email,
        groups: [MAILERLITE_PRODUCTION_NEWSLETTER_GROUP_ID],
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer' + MAILERLITE_PRODUCTION_API_KEY,
        },
      }
    );

    return {
      statusCode: response.status,
      body: JSON.stringify({
        message: 'Subscriber added to MailerLite successfully',
      }),
    };
  } catch (error) {
    console.error('Error adding subscriber to MailerLite:', error);

    return {
      statusCode: error.response ? error.response.status : 500,
      body: JSON.stringify({
        message: 'Failed to add subscriber to MailerLite',
      }),
    };
  }
};
