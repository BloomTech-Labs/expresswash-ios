//
//  JobController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 5/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

class JobController {

    // MARK: - Properties

    typealias CompletionHandler = (Job?, Error?) -> Void

    // MARK: - Local Methods

    func addJob(jobRepresentation: JobRepresentation,
                context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                completion: @escaping CompletionHandler) {

        createJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error creating job: \(error)")
                completion(nil, error)
                return
            }

            guard let job = job else {
                return
            }

            completion(job, nil)

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to save car to user: \(error)")
                    context.reset()
                    return
                }
            }
        }
    }

    func updateJob(jobRepresentation: JobRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {

        editJob(jobRepresentation: jobRepresentation) { (job, error) in
            if let error = error {
                print("Error updating job: \(error)")
                completion(nil, error)
                return
            }

            guard let job = job else { return }

            completion(job, nil)

            context.perform {
                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    print("Unable to update job: \(error)")
                    context.reset()
                    return
                }
            }
        }
    }

    func updateJob(_ job: Job,
                   with rep: JobRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {
        context.perform {
            job.address = rep.address
            job.address2 = rep.address2
            job.city = rep.city
            job.completed = rep.completed
            job.jobId = Int32(rep.jobId)
            job.jobLocationLat = rep.jobLocationLat
            job.jobLocationLon = rep.jobLocationLon
            job.jobType = rep.jobType
            job.notes = rep.notes
            job.paid = rep.paid
            job.photoAfterJob = rep.photoAfterJob
            job.photoBeforeJob = rep.photoBeforeJob
            job.scheduled = rep.scheduled
            job.state = rep.state
            job.timeArrived = rep.timeArrived
            job.timeCompleted = rep.timeCompleted
            job.timeRequested = rep.timeRequested
            job.zip = rep.zip

            let washerController = WasherController()
            let carController = CarController()
            job.client = UserController.shared.findUser(byID: rep.clientId)
            if let washerId = rep.washerId {
                job.washer = washerController.findWasher(byID: washerId)
            }
            job.car = carController.findCar(by: rep.carId)

            do {
                try CoreDataStack.shared.save(context: context)
                completion(job, nil)
            } catch {
                print("Unable to save updated job: \(error)")
                context.reset()
                completion(nil, error)
            }
        }
    }

    func deleteJob(job: Job,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        deleteJob(job: job) { _, error in
            if let error = error {
                print("Error deleting job: \(error)")
                return
            } else {
                context.perform {
                    do {
                        context.delete(job)
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        print("Could not save after deleting: \(error)")
                        context.reset()
                        return
                    }
                }
            }
        }
    }

    func findJob(by jobId: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Job? {
        var foundJob: Job?
        let objcJobId = NSNumber(value: jobId)
        let fetchRequest: NSFetchRequest<Job> = Job.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jobId == %@", objcJobId)
        do {
            let matchedJobs = try context.fetch(fetchRequest)

            if matchedJobs.count == 1 {
                foundJob = matchedJobs[0]
            }

            return foundJob
        } catch {
            print("Error when searching core data for jobId \(jobId): \(error)")
            return nil
        }
    }

    // finds or creates a Job in Core Data (not on the server)
    func findOrCreateJobInCoreData(from rep: JobRepresentation,
                                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Job {
        var foundJob = findJob(by: rep.jobId, context: context)
        if foundJob == nil {
            foundJob = Job(representation: rep, context: context)
            foundJob?.washer = WasherController.shared.findWasher(byID: rep.washerId!)
        } else {
            // if the Job already exists in Core Data, update based on rep
            updateJob(foundJob!, with: rep) { (_, _) in }
        }
        return foundJob!
    }
}
