//
//  WasherViewController+UIImagePickerControllerDelegate.swift
//  ExpressWash
//
//  Created by Joel Groomer on 6/20/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension WasherViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // this method will be called after the user takes a photo of the job
    // from arriveCompletedTapped(_:)

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let job = job else {
            print("Don't know what this image is for!")
            return
        }

        let nextImageNeeded: ImageEndpoint = jobStarted ? .imagesJobAfter : .imagesJobBefore
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            PhotoController.shared.uploadPhoto(image,
                                               httpMethod: "POST",
                                               endpoint: nextImageNeeded,
                                               theID: Int(job.jobId)) { (data, error) in
                if let error = error {
                    let alert = UIAlertController()
                    alert.title = "Upload failed"
                    alert.message = "Unable to uplaod photo: \(error)"
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        var rep = try decoder.decode(JobRepresentation.self, from: data)
                        if nextImageNeeded == .imagesJobBefore {
                            rep.timeArrived = DateFormatter.nowAsISOString
                        } else if nextImageNeeded == .imagesJobAfter {
                            rep.timeCompleted = DateFormatter.nowAsISOString
                            rep.completed = true
                        }
                        self.jobController.editJob(jobRepresentation: rep) { _, error in
                            if let error = error {
                                print("Failed to update job after uploading photo: \(error)")
                            }
                            DispatchQueue.main.async {
                                let alert = UIAlertController()
                                alert.title = nextImageNeeded == .imagesJobBefore ? "Job started" : "Job complete!"
                                var message: String
                                if nextImageNeeded == .imagesJobBefore {
                                    message = "Let your client know when you've finished "
                                    message += "by tapping the check mark icon!"
                                } else {
                                    message = "Great! You've finished the job! Make sure"
                                    message += " to check your Active status so you can "
                                    message += "start the next one when you're ready!"
                                }
                                alert.message = message
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true) {
                                    if nextImageNeeded == .imagesJobAfter {
                                        self.job = nil
                                    }
                                    if let annotation = self.annotation {
                                        self.mapView.removeAnnotation(annotation)
                                    }
                                    self.updateViews()
                                }
                            }
                        }
                    } catch {
                        print("Couldn't decode job after uploading photo: \(error)")
                    }
                }
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
}
