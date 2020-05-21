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
    
    // MARK: - Network Methods
    
    func createJob(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {
    }
    
    func getJobInfo(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {
    }
    
    func getUserJobs(user: User, completion: @escaping ([Job?], Error?) -> Void) {
    }
    
    func assignWasher(jobRepresentation: JobRepresentation, washerID: Int, completion: @escaping CompletionHandler) {
    }
    
    func editJob(jobRepresentation: JobRepresentation, completion: @escaping CompletionHandler) {
    }
    
    func deleteJob(job: Job, completion: @escaping (String?, Error?) -> Void) {
    }
    
    struct WasherID: Codable {
        var washerID: Int
    }
}
