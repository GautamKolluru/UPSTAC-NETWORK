"use strict"

/**
 * This is a Node.JS application to add a new student on the network.
 */
const { getContractInstance, disconnect } = require("./contractHealper")
async function main(phone, vaccineStatus) {
  let requestBuffer
  try {
    const certnetContract = await getContractInstance("org.covid.vaccine")

    // Registrar getting all the user request
    console.log(".....Update vaccine Status request")
    requestBuffer = await certnetContract.submitTransaction(
      "updateVaccineStatus",
      phone,
      vaccineStatus
    )
    // process response
    console.log(
      ".....Processing update vaccine status Transaction Response \n\n"
    )
    let newStudent = JSON.parse(requestBuffer.toString())
    console.log(newStudent)
    console.log("\n\n.....update vaccine status Transaction Complete!")
    return newStudent
  } catch (error) {
    console.log("\n\n..... Update vaccine status Request Errored Out!")
    console.log(error.toString())
  } finally {
    disconnect()
  }
}

main("6692519298", "Inprogress")
module.exports.execute = main
