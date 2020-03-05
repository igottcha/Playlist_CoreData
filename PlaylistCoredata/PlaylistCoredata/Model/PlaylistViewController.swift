//
//  PlaylistViewController.swift
//  PlaylistCoredata
//
//  Created by Chris Gottfredson on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit
import CoreData

class PlaylistViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var playlistTableView: UITableView!
    @IBOutlet weak var playlistNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        PlaylistController.sharedInstance.fetchResultsController.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let playlistName = playlistNameTextField.text, !playlistName.isEmpty else {return}
        PlaylistController.sharedInstance.createPlaylist(with: playlistName)
        playlistTableView.reloadData()
        playlistNameTextField.text = ""
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let index = playlistTableView.indexPathForSelectedRow, let destinationVC = segue.destination as? SongDetailViewController else {return}
            let playlist = PlaylistController.sharedInstance.fetchResultsController.object(at: index)
            destinationVC.playlist = playlist
        }
     }
}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PlaylistController.sharedInstance.fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        let playlist = PlaylistController.sharedInstance.fetchResultsController.object(at: indexPath)
        
        let songCount = playlist.songs?.count ?? 0
        
        cell.textLabel?.text = playlist.name
        if songCount == 1 {
            cell.detailTextLabel?.text = "\(songCount) Song"
        } else {
            cell.detailTextLabel?.text = "\(songCount) Songs"
        }
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let playlist = PlaylistController.sharedInstance.fetchResultsController.object(at: indexPath)
            PlaylistController.sharedInstance.deletePlaylist(playist: playlist)
        }
    }
}

extension PlaylistViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        playlistTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        playlistTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {break}
            playlistTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {break}
            playlistTableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let fromIndexPath = indexPath, let newIndexPath = newIndexPath else {break}
            playlistTableView.moveRow(at: fromIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {break}
            playlistTableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            playlistTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            playlistTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
}
