//
//  CloudkitDAO.swift
//  TikTokLaugh
//
//  Created by Pedro Contine on 27/01/20.
//  Copyright © 2020 Pedro Contine. All rights reserved.
//

import UIKit
import CloudKit

class CloudkitDAO {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase
    var recordID: CKRecord.ID?
    
    func getRecords(db: CKDatabase, recordType: String, completion: @escaping (_ records: [CKRecord]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let zone = CKRecordZone.default().zoneID
        
        db.perform(query, inZoneWith: zone) { (records, error) in
            if error != nil {
               completion(nil)
            }
            else {
               completion(records)
            }
        }
    }
    
    func getAllMoviescompletion(completion: @escaping (_ movies: [String]) -> Void) {
        getRecords(db: publicDB, recordType: "Playlist") { (records) in
            guard let records = records, let playlist = records.first?.object(forKey: "videosID") as? [String]
            else {return}
            
            completion(playlist)
        }
    }
    
    func getUnseenMovies(completion: @escaping (_ movies: [String]) -> Void) {
        getAllMoviescompletion { (allMovies) in
            self.getUserSeenMovies { (seenMovies) in
                let movies = seenMovies == nil ? [] : seenMovies!
                
                let unseenMovies = allMovies.filter({!movies.contains($0)})
                
                completion(unseenMovies)
            }
        }
    }
    
    func getUserSeenMovies(completion: @escaping (_ seenMovies: [String]?) -> Void) {
        getRecords(db: privateDB, recordType: "Playlist") { (records) in
            
            if let records = records, let playlist = records.first?.object(forKey: "videosID") as? [String] {
                self.recordID = records.first?.recordID
                completion(playlist)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func updateSeenMovies(newSeenMovie: [String], completion: @escaping (_ seenMovies: [String]) -> Void) {
        getUserSeenMovies { (oldSeenMovies) in
            var seenMovies = oldSeenMovies == nil ? [] : oldSeenMovies!
            
            for movie in newSeenMovie {
                seenMovies.append(movie)
            }
            
            let movies = Array(Set(seenMovies))
            
            completion(movies)
        }
    }
    
    func updateUserSeenMovies(newSeenMovie: [String]) {
        updateSeenMovies(newSeenMovie: newSeenMovie) { (seenMovies) in
            //if record id is nil, it means user has no records.
            //So we need to save a new one
            guard let recordID = self.recordID else {
                self.saveUserSeenMovies(newSeenMovie: seenMovies)
                return
            }
            //update existing record
            self.fetchUserSeenMovies(recordID: recordID, seenMovies: seenMovies)
            
        }
    }
    
    func saveUserSeenMovies(newSeenMovie: [String]) {
        updateSeenMovies(newSeenMovie: newSeenMovie) { (seenMovies) in
            let record = CKRecord(recordType: "Playlist")
            record.setValue(seenMovies, forKey: "videosID")
            
            self.privateDB.save(record) { (savedRecord, error) in
                if error == nil {
                    print("Record Saved")
                } else {
                    print("Record Not Saved")
                }
            }
        }
    }
    
    func fetchUserSeenMovies(recordID: CKRecord.ID, seenMovies: [String]) {
        self.privateDB.fetch(withRecordID: recordID) { (record, error) in
            if error == nil {
                record?.setValue(seenMovies, forKey: "videosID")
                
                self.privateDB.save(record!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("Record Saved")
                    }
                    else {
                        print("Record Not Saved")
                    }
                })
            }
            else {
                print("Could not fetch record")
            }
        }
    }
}
