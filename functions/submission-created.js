const mailjet = require('node-mailjet').connect(
  process.env.MJ_APIKEY_PUBLIC,
  process.env.MJ_APIKEY_PRIVATE
);

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

    const request = mailjet
      .post('contact', { version: 'v3' })
      .request({
        IsExcludedFromCampaigns: 'true',
        Name: 'New Contact',
        Email: email
      });

    const result = await request;

    return {
      statusCode: result.response.statusCode,
      body: JSON.stringify(result.body)
    };
  } catch (error) {
    console.error('Error:', error);

    return {
      statusCode: error.response ? error.response.status : 500,
      body: JSON.stringify({ message: 'An error occurred' })
    };
  }
};
