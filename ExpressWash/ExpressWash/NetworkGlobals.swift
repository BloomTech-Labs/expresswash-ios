//
//  NetworkGlobals.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

let NODATAERROR = 99999
let INVALIDUSERNAMEORPASSWORD = 99998
let CANCELLED = 99997
let BADPHOTOREQUEST = 99996
let CANNOTCONVERT = 99995
let BADHTTPRESPONSE = 99994

var SESSION = URLSession.shared

let BASEURL = URL(string: "https://serverprod.expresswash.us")!

enum ENDPOINTS: String {
    case registerClient = "/auth/RegisterClient"    // POST     Register for a client account.
    case registerWasher = "/auth/RegisterWasher"    // POST     /:id    Register for a washer account.
    case login = "/auth/login"                      // POST     Login to an existing account.

    case carMakes = "/carsPG/makes"         // GET      Returns all car makes.
    case carModels = "/carsPG/models"       // POST     Returns all car models for a given make.
    case carGetId = "/carsPG/getCarId"      // POST     Takes in make and model and returns carId.  (???)
    case carAddToUser = "/carsPG/addACar"   // POST     Takes in userId, carId, color and license plate,
                                            //          ties car to user profile.

    case jobNew = "/jobs/new"                       // POST     Creates a new job.
    case jobAvailable = "/jobs/available/"          // GET      Returns jobs with washerId null (new available jobs).
    case jobInfo = "/jobs/jobInfo"                  // POST     Returns job info for given jobId
    case jobSelect = "/jobs/selectJob"              // POST     Adds the washer to a job
    case jobRevise = "/jobs/job/"                   // DELETE   Deletes Job by jobID
                                                    // PUT      Edits Job by jobID
    case jobsClient = "/jobs/user/"                 // GET      Gets Jobs by userID
    case jobsWasher = "/jobs/washer"                // GET      Gets Jobs by washerID
    case washersInCity = "/users/available/"        // GET      Gets washers in given city

    case paymentIntent = "/users/payment-intent"    // Post     Established payment intent

    case users      // GET      View all users.
                    // GET      /:id    View specific user.
                    // DELETE   /:id    Remove user.
                    // PUT      /:id    Update user.

    case userRating = "/users/rating"           // PUT  /:id    Updating rating of a user
    case washer = "/users/washer"               // PUT  /:id    Update washer
    case washerRating = "/users/washer/rating"  // PUT  /:id    Update rating of washer

    // Need an endpoint to get a list washers who are active and near a job location
}
