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

    @IBOutlet weak var emptyReceiptsView: UIView!
    @IBOutlet weak var receiptsTableView: UITableView!

    // MARK: - Views

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        getJobs()
        receiptsTableView.delegate = self
        receiptsTableView.dataSource = self
        receiptsTableView.backgroundColor = .white
    }

    // MARK: - Methods

    private func getJobs() {
        guard let user = UserController.shared.sessionUser.user else { return }

        jobController.getUserJobs(user: user) { (jobRepresentations, error) in
            if let error = error {
                print("Error getting user's jobs: \(error)")
                return
            }

            guard let jobReps = jobRepresentations else { return }

            self.jobs = []

            for rep in jobReps {
                let job = self.jobController.findOrCreateJobInCoreData(from: rep)
                self.jobs.append(job)
            }

            DispatchQueue.main.async {
                self.receiptsTableView.reloadData()
            }
        }
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobs.count == 0 {
            emptyReceiptsView.alpha = 1
            return jobs.count
        } else {
            emptyReceiptsView.alpha = 0
            return jobs.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiptCell",
                                                       for: indexPath) as? ReceiptTableViewCell else {
                                                        return UITableViewCell() }

        let job = jobs[indexPath.row]

        let firstName = job.washer!.user!.firstName
        let lastName = job.washer!.user!.lastName

        cell.washerName.text = "\(firstName) \(lastName)"

        if let url = job.washer!.user!.profilePicture {
            cell.washerImage.image = UIImage.cached(from: url, defaultTitle: "person.circle")
            cell.washerImage.layer.cornerRadius = cell.washerImage.frame.size.height/2
        } else {
            cell.washerImage.image = UIImage(systemName: "person.circle")
        }

        cell.washerRating.text = "★ \(job.washer!.washerRating)"

        cell.dateLabel.text = job.creationDate

        let timeTakenString = DateFormatter.timeTaken(timeArrived: job.timeArrived, timeCompleted: job.timeCompleted)

        cell.timeTakenLabel.text = timeTakenString

        if let beforeString = job.photoBeforeJob {
            cell.beforeImageView.image = UIImage.cached(from: beforeString, defaultTitle: "Logo")
            cell.beforeImageView.layer.cornerRadius = 5.0
        }

        if let afterString = job.photoAfterJob {
            cell.afterImageView.image = UIImage.cached(from: afterString, defaultTitle: "Logo")
            cell.afterImageView.layer.cornerRadius = 5.0
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "washDetailSegue" {
            if let receiptDetailVC = segue.destination as? ReceiptDetailViewController,
                let indexPath = receiptsTableView.indexPathForSelectedRow {
                let job = jobs[indexPath.row]
                receiptDetailVC.job = job
            }
        }
    }
}
