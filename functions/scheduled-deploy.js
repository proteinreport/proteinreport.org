// Reference:
// https://www.netlify.com/blog/how-to-schedule-deploys-with-netlify/

import fetch from 'node-fetch'
import { schedule } from '@netlify/functions'

// This is a sample build hook URL
const BUILD_HOOK =
  'https://api.netlify.com/build_hooks/64f81bc3767e5843d3fd3667'

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