// // optionally configure local env vars
// require('dotenv').config()

// // details in https://css-tricks.com/using-netlify-forms-and-netlify-functions-to-build-an-email-sign-up-widget
const process = require('process')

const fetch = require('node-fetch')

const API_KEY = process.env.MAILERLITE_PRODUCTION_API_KEY;
const BASE_URL = process.env.MAILERLITE_PRODUCTION_BASE_API_URL;
const GROUP_ID = process.env.MAILERLITE_PRODUCTION_NEWSLETTER_GROUP_ID;

const { EMAIL_TOKEN } = process.env
const handler = async (event) => {
  const { email } = JSON.parse(event.body).payload
  console.log(`Received a submission: ${email}`)
  try {
    const response = await fetch('${BASE_URL}/subscribers', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email }),
    })
    const data = await response.json()
    console.log(`Submitted to Buttondown:\n ${data}`)
  } catch (error) {
    return { statusCode: 422, body: String(error) }
  }
}

module.exports = { handler }
