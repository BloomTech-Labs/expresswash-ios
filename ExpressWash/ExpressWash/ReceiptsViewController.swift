//
//  ReceiptsViewController.swift
//  ExpressWash
//
//  Created by Bobby Keffury on 4/22/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ReceiptsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    let jobController = JobController()
    var jobs: [Job] = []

    // MARK: - Outlets

    @IBOutlet weak var receiptsTableView: UITableView!

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        getJobs()
    }

    // MARK: - Methods

    private func getJobs() {
        guard let user = UserController.shared.sessionUser else { return }

        jobController.getUserJobs(user: user) { (jobRepresentations, error) in
            if let error = error {
                print("Error getting user's jobs: \(error)")
                return
            }

            guard let jobReps = jobRepresentations else { return }

            self.jobs = []

            for rep in jobReps {
                let job = Job(representation: rep)
                self.jobs.append(job)
            }

            self.receiptsTableView.reloadData()
        }
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell",
                                                       for: indexPath) as? ReceiptTableViewCell else {
                                                        return UITableViewCell() }

        let job = jobs[indexPath.row]

        let firstName = job.washer!.user!.firstName
        let lastName = job.washer!.user!.lastName

        cell.washerName.text = firstName + lastName

        // Handle washer profile photo

        cell.washerRating.text = "★ \(job.washer!.washerRating))"

        // Ask for backend to add date requested to job

        // Also add timeArrived to help calculate timeTaken

        // Handle before & after pictures

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FILL ME IN" {
            if let receiptDetailVC = segue.destination as? ReceiptDetailViewController,
                let indexPath = receiptsTableView.indexPathForSelectedRow {
                let job = jobs[indexPath.row]
                receiptDetailVC.job = job
            }
        }
    }
}
