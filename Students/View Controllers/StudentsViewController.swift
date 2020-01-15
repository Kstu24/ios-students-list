//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
        private let studentController = StudentController()
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        studentController.loadFromPersistentStore { (students, error) in
            guard error == nil else {
                print("Error loading students: \(error!)")
                return
            }
            
            guard let students = students else {
                print("Error: Students was nil!")
                return
            }
            
            DispatchQueue.main.async {
                self.filteredAndSortedStudents = students
            }
        }
        
        let intArray = [1, 2, 3, 4, 5, 6]
        
        //filter
        let filteredArray = intArray.filter { ($0 ?? 0) % 2 == 0 }
        print("Even array = \(filteredArray)")
        
        
        //sorted
        let sortedArray = intArray.sorted { ($0 ?? 0) > ($1 ?? 0) }
        print("Sorted array = \(sortedArray)")
        
        //map
        let mapArray = intArray.map { ($0 ?? 0) * 2 }
        print("Mapped array = \(mapArray)")
        
        //flatMap
        let flatMapArray = intArray.flatMap { $0 }
        print("Flat mapped array = \(flatMapArray)")
        
        let compactMapArray = intArray.compactMap { $0 }
        print("Compact mapped array = \(compactMapArray)")
        
        //using compact map to clean up array
        let cleanFilteredArray = intArray
            .compactMap { $0 }
            .filter { $0 % 2 == 0 }
        print("Even array = \(cleanFilteredArray)")
        
        //reduce
        
        let reducedArray = intArray
            .compactMap { $0 }
            .reduce(1) { (result, value) -> Int in
                return result + value
        }
        print("Reduced array = \(reducedArray)")
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        let sort = SortOption(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        
        studentController.filter(with: filter, sortedBy: sort) { (students) in
            self.filteredAndSortedStudents = students
        }
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        
        guard indexPath.row < filteredAndSortedStudents.count else { return cell }
        
        let students = filteredAndSortedStudents[indexPath.row]
        
        cell.textLabel?.text = students.name
        cell.detailTextLabel?.text = students.course
        
        return cell
    }
}
