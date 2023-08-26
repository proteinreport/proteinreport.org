const mailjet = require('node-mailjet').connect(
  process.env.MJ_APIKEY_PUBLIC,
  process.env.MJ_APIKEY_PRIVATE
);

exports.handler = async (event, context) => {
  try {
    const { email } = JSON.parse(event.body);

    const request = mailjet.post('contact').request({
      Email: email
    });

    const response = await request;
    const contactId = response.body.Data[0].ID;

    const listId = process.env.MJ_LIST_ID;
    const subscribeRequest = mailjet.post(`listrecipient/${listId}/managecontact`).request({
      Action: 'addforce',
      ContactID: contactId
    });

    await subscribeRequest;

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Contact added successfully' })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'An error occurred' })
    };
  }
};