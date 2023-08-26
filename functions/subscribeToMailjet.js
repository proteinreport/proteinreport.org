// netlify/functions/subscribeToMailjet.js

const mailjet = require('node-mailjet').connect(
  process.env.MJ_APIKEY_PUBLIC,
  process.env.MJ_APIKEY_PRIVATE
);

exports.handler = async (event, context) => {
  try {
    const { email } = JSON.parse(event.body);

    // Add email to Mailjet contacts
    const result = await mailjet.post('contact').request({
      Email: email
    });

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Email added to Mailjet contacts' })
    };
  } catch (error) {
    console.error(error);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Error adding email to Mailjet contacts' })
    };
  }
};
