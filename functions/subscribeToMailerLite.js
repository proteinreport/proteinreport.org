const axios = require("axios");

exports.handler = async (event) => {
  const parsedData = new URLSearchParams(event.body);
  const dataObj = {};
  for (var pair of parsedData.entries()) {
    dataObj[pair[0]] = pair[1];
  }
  console.log("DataObj: ", dataObj);
  const email = dataObj.email;

  // Get environment variables
  const { ML_APIKEY, ML_GROUPID } = process.env;

  try {
    const response = await axios.post(
      "https://connect.mailerlite.com/api/subscribers",
      {
        email: email,
        groups: [ML_GROUPID],
      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + ML_APIKEY,
        },
      }
    );
    
    if (response.status === 200 || response.status === 201 || response.status === 202) {
      let message;
      if (response.status === 200) {
        message = "The request was accepted. (Status Code: 200)";
      } else if (response.status === 201) {
        message = "Resource was created. (Status Code: 201)";
      } else if (response.status === 202) {
        message = "The request was accepted and further actions are taken in the background. (Status Code: 202)";
      } else if (response.status === 204) {
        message = "The request was accepted and there is nothing to return. (Status Code: 204)";
      }
      
      return {
        statusCode: response.status,
        body: JSON.stringify({
          message: message,
        }),
      };
    } else {
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: "Failed to add contact to MailerLite",
        }),
      };
    }
  } catch (error) {
    // If the error indicates the subscriber already exists and is inactive
    if (error.response && error.response.status === 422 && error.response.data && error.response.data.field === 'email') {
      try {
        const response = await axios.get(
          `https://connect.mailerlite.com/api/subscribers?email=${email}`,
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: 'Bearer ' + ML_APIKEY,
            },
          }
        );

        if (response.status === 200 && response.data.length > 0 && response.data[0].status === 0) {
          // Update the subscriber's status to active
          const updateResponse = await axios.put(
            `https://connect.mailerlite.com/api/subscribers/${response.data[0].id}`,
            {
              status: 'active',
            },
            {
              headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + ML_APIKEY,
              },
            }
          );

          if (updateResponse.status === 200) {
            return {
              statusCode: 200,
              body: JSON.stringify({
                message: "Contact added to MailerLite successfully (Subscriber reactivated)",
              }),
            };
          }
        }
      } catch (error) {
        console.error("Error adding contact to MailerLite:", error);
      }
    }

    console.error("Error adding contact to MailerLite:", error);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to add contact to MailerLite",
      }),
    };
  }
};
