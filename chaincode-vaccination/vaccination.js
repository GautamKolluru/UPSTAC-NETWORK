"use strict"

const { Contract } = require("fabric-contract-api")

class vaccine extends Contract {
  constructor() {
    super("org.covid.vaccine")
  }

  async instantiate() {
    console.log("Covid Smart Contract Instatiate")
  }

  async vaccineRegister(ctx, firstName, lastName, mobileNumber, address) {
    const userkey = ctx.stub.createCompositeKey("org.vaccine", [
      "user",
      "-",
      mobileNumber,
    ])

    const data = await ctx.stub.getState(userkey)

    if (data.toString().length <= 0) {
      throw new Error("User not register in the platform")
    }
    const userRegisterKey = ctx.stub.createCompositeKey("org.vaccine", [
      "register",
      "-",
      mobileNumber,
    ])

    let register = {
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      address: address,
      status: "Created",
      orgRegistered: ctx.clientIdentity.getMSPID(),
    }

    let dataBuffer = Buffer.from(JSON.stringify(register))
    await ctx.stub.putState(userRegisterKey, dataBuffer)

    return register
  }

  async addUser(ctx, firstName, lastName, mobileNumber, address) {
    const userkey = ctx.stub.createCompositeKey("org.vaccine", [
      "user",
      "-",
      mobileNumber,
    ])

    const data = await ctx.stub.getState(userkey)

    if (data.toString().length > 0) {
      throw new Error("User already register in the platform")
    }

    let register = {
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      address: address,
      orgRegistered: ctx.clientIdentity.getMSPID(),
    }

    let dataBuffer = Buffer.from(JSON.stringify(register))
    await ctx.stub.putState(userkey, dataBuffer)

    return register
  }

  /**
   * @desc: Update vaccine status
   * @param {*} ctx
   * @param {*} mobileNumber
   * @param {*} vaccinestatus
   * @returns
   */
  async updateVaccineStatus(ctx, mobileNumber, vaccinestatus) {
    if (!ctx.clientIdentity.assertAttributeValue("isAdmin", "true")) {
      throw new Error("Only Admin can perform this operation")
    }
    const userkey = ctx.stub.createCompositeKey("org.vaccine", [
      "register",
      "-",
      mobileNumber,
    ])

    const data = await ctx.stub.getState(userkey)

    if (data.toString().length <= 0) {
      throw new Error("User not register in the platform")
    }

    const newdata = JSON.parse(data)
    console.log("Data Before update: " + JSON.stringify(newdata))
    let updatedStatus = {
      ...newdata,
      status: vaccinestatus,
    }
    let dataBuffer = Buffer.from(JSON.stringify(updatedStatus))
    await ctx.stub.putState(userkey, dataBuffer)
    return updatedStatus
  }
  /**
   * @desc: Check vascation status
   * @param {*} ctx :Transcation context
   * @param {mobile number} mobileNumber :Userr mobile number
   * @returns
   */
  async getVaccineStatus(ctx, mobileNumber) {
    const userkey = ctx.stub.createCompositeKey("org.vaccine", [
      "register",
      "-",
      mobileNumber,
    ])

    const data = await ctx.stub.getState(userkey)

    if (data.toString().length <= 0) {
      throw new Error("User not register in the platform")
    }

    return JSON.parse(data)
  }
}

module.exports = vaccine
