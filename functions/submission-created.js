const axios = require('axios');

exports.handler = async function(event, context) {
  try {
    if (event.httpMethod !== 'POST') {
      return {
        statusCode: 405,
        body: JSON.stringify({ message: 'Method Not Allowed' })
      };
    }

    const { email, formName } = JSON.parse(event.body);

    if (!email || !formName || formName !== 'newsletter') {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Invalid request' })
      };
    }

    const MAILERLITE_API_KEY = process.env.MAILERLITE_API_KEY;
    const BASE_URL = process.env.MAILERLITE_PRODUCTION_BASE_API_URL;
    const GROUP_ID = process.env.MAILERLITE_PRODUCTION_NEWSLETTER_GROUP_ID;

    const response = await axios.post(
      BASE_URL + 'api/subscribers',
      {
        email,
        group_ids: [GROUP_ID] // Replace with your MailerLite group ID(s)
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + MAILERLITE_API_KEY
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
