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
    }
    
    func updateJob(jobRepresentation: JobRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                   completion: @escaping CompletionHandler) {
    }
    
    func deleteJob(jobRepresentation: JobRepresentation,
                   context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
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
    
    func deleteJob(jobRepresentation: JobRepresentation, completion: @escaping (String?, Error?) -> Void) {
    }
}
