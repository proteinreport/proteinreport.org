// Import the required dependencies
const mailjet = require('node-mailjet').connect(process.env.MJ_APIKEY_PUBLIC, process.env.MJ_APIKEY_PRIVATE);

// Define the Netlify function
exports.handler = async (event, context) => {
  try {
    // Parse the form data from the event body
    const formData = JSON.parse(event.body);

    // Extract the email address from the form data
    const email = formData.newsletter;

    // Create the Mailjet contact object
    const contact = {
      Email: email,
    };

    // Add the contact to Mailjet using the Mailjet API
    const result = await mailjet.post('contact').request({ Email: email });

    // Return a success response
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Email added to Mailjet contacts successfully' }),
    };
  } catch (error) {
    // Return an error response
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to add email to Mailjet contacts' }),
    };
  }
};
