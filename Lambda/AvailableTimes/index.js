exports.handler =  async (event) => {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2))
    return true
  }