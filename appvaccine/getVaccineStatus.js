"use strict"

/**
 * This is a Node.JS application to add a new student on the network.
 */
const { getContractInstance, disconnect } = require("./contractHealper")
async function main(phone) {
  let requestBuffer
  try {
    const certnetContract = await getContractInstance("org.covid.vaccine")

    // Registrar getting all the user request
    console.log(".....Get vaccine Status request")
    requestBuffer = await certnetContract.submitTransaction(
      "getVaccineStatus",
      phone
    )
    // process response
    console.log(".....Processing get vaccine status Transaction Response \n\n")
    let newStudent = JSON.parse(requestBuffer.toString())
    console.log(newStudent)
    console.log("\n\n.....Processing get vaccine status Transaction Complete!")
    return newStudent
  } catch (error) {
    console.log("\n\n..... Get vaccine status Request Errored Out!")
  } finally {
    disconnect()
  }
}

main("6692519298")
module.exports.execute = main
