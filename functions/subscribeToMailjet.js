const axios = require('axios');

exports.handler = async function(event, context) {
  try {
    if (event.httpMethod !== 'POST') {
      return {
        statusCode: 405,
        body: JSON.stringify({ message: 'Method Not Allowed' })
      };
    }

    const { email } = JSON.parse(event.body);

    if (!email) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Missing email in request body' })
      };
    }

    const payload = {
      Email: email,
      ContactsLists: [process.env.MAILJET_LIST_ID],
    };

    const response = await axios.post(
      'https://api.mailjet.com/v3/REST/contact',
      payload,
      {
        auth: {
          username: process.env.MJ_APIKEY_PUBLIC,
          password: process.env.MJ_APIKEY_PRIVATE
        }
      }
    );

    return {
      statusCode: response.status,
      body: JSON.stringify({ message: 'Subscriber added successfully' })
    };
  } catch (error) {
    console.error('Error:', error);

    return {
      statusCode: error.response ? error.response.status : 500,
      body: JSON.stringify({ message: 'An error occurred' })
    };
  }
};
