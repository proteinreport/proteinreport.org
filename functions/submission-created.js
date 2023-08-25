const axios = require("axios");

require('dotenv').config()
const fetch = require('node-fetch')

const API_KEY = process.env.MAILERLITE_PRODUCTION_API_KEY;
const BASE_URL = process.env.MAILERLITE_PRODUCTION_BASE_API_URL;
const GROUP_ID = process.env.MAILERLITE_PRODUCTION_NEWSLETTER_GROUP_ID;

exports.handler = async event => {
  if (!event.body) {
    return;
  }
  const { email, name } = JSON.parse(event.body).payload;
  const url = `${BASE_URL}/subscribers`;

  const data = {
    email: email,
    fields: {
      name: name,
    },
    groups: [`${GROUP_ID}`],
  };

  const options = {
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${API_KEY}`,
    },
  };

  try {
    await axios.post(url, data, options);
    return {
      statusCode: 201,
      body: JSON.stringify({
        message: "Subscriber successfully created and added to group",
      }),
    };
  } catch (error: any) {
    console.log(error);
    return {
      statusCode: 500,
      body: JSON.stringify(error),
    };
  }
}
