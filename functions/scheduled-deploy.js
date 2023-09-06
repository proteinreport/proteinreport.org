// Reference:
// https://www.netlify.com/blog/how-to-schedule-deploys-with-netlify/

import fetch from 'node-fetch'
import { schedule } from '@netlify/functions'

// Get environment variables
const { PR_DEPLOY } = process.env;

// This is a sample build hook URL
const BUILD_HOOK = PR_DEPLOY

// Schedules the handler function to run at midnight on
// Mondays, Wednesday, and Friday
const handler = schedule('0 0 * * *', async () => {
  await fetch(BUILD_HOOK, {
    method: 'POST'
  }).then(response => {
    console.log('Build hook response:', response)
  })

  return {
    statusCode: 200
  }
})

export { handler }