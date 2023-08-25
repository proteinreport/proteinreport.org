const mailjet = require ('node-mailjet')
	.connect(process.env.MJ_APIKEY_PUBLIC, process.env.MJ_APIKEY_PRIVATE)
const request = mailjet
	.post("contact", {'version': 'v3'})
	.request({
      "IsExcludedFromCampaigns":"true",
      "Name":"New Contact",
      "Email":"passenger@mailjet.com"
    })
request
	.then((result) => {
		console.log(result.body)
	})
	.catch((err) => {
		console.log(err.statusCode)
	})