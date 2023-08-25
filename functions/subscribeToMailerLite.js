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

    const MAILERLITE_API_KEY = process.env.MAILERLITE_API_KEY;
    const MAILERLITE_LIST_ID = process.env.MAILERLITE_LIST_ID;

    const response = await axios.post(
      `https://api.mailerlite.com/api/v2/groups/${MAILERLITE_LIST_ID}/subscribers`,
      { email },
      {
        headers: {
          'Content-Type': 'application/json',
          'X-MailerLite-ApiKey': MAILERLITE_API_KEY
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
