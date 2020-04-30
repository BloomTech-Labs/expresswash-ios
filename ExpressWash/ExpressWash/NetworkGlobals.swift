//
//  NetworkGlobals.swift
//  ExpressWash
//
//  Created by Joel Groomer on 4/28/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

let BASE_URL = URL(string: "https://www.expresswash.us")!

enum ENDPOINTS: String {
    case registerClient = "/auth/RegisterClient"    // POST     Register for a client account.
    case registerWasher = "/auth/RegisterWasher"    // POST     /:id    Register for a washer account.
    case login = "/auth/login"                      // POST     Login to an existing account.
    
    case carMakes = "/carsPG/makes"         // GET      Returns all car makes.
    case carModels = "/carsPG/models"       // POST     Returns all car models for a given make.
    case carGetId = "/carsPG/getCarId"      // POST     Takes in make and model and returns carId.  (???)
    case carAddToUser = "/carsPG/addACar"   // POST     Takes in userId, carId, color and license plate, ties car to user profile.
    
    // is there no comprehensive job history?
    case clientLatestJob = "/jobs/getLatestJobClient"        // POST    Returns info on the latest job a client had done.
    case clientLatestWasher = "/jobs/getLatestWasherClient"  // POST    Returns info on the last washer on a client's job.
    
    case jobNew = "/jobs/new"                       // POST     Creates a new job.
    case jobAvailable = "/jobs/available"           // GET      Returns all jobs with washerId null (new available jobs).
    case jobInfo = "/jobs/jobInfo"                  // POST     Returns all job info for given jobId
    case jobGetWorkStatus = "/jobs/getWorkStatus"   // POST     Returns the workStatus of a washer   (???)
    case jobSetWorkStatus = "/jobs/setWorkStatus"   // PUT      Boolean, id in req.body sets washer work status (??? job ID or washer ID?)
    case jobSelect = "/jobs/selectJob"              // POST     Adds the washer to a job
    case jobsQtyCompleted = "/jobs/howManyCompleted"    // POST Returns a count of how many jobs the washer is on.

    
    case users      // GET      View all users.
                    // GET      /:id    View specific user.
                    // DELETE   /:id    Remove user.
                    // PUT      /:id    Update user.
    
    // Need an endpoint to get a list washers who are active and near a job location
}
