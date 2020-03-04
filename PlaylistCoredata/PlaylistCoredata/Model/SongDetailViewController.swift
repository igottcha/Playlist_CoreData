//
//  SongDetailViewController.swift
//  PlaylistCoredata
//
//  Created by Chris Gottfredson on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var songArtistTextField: UITextField!
    @IBOutlet weak var songTableView: UITableView!
    
    //MARK: - Properties
    
    var playlist: Playlist?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        songTableView.delegate = self
        songTableView.dataSource = self
    }
    
    //MARK: - Actions
    @IBAction func addSongButtonTapped(_ sender: Any) {
        guard let playlist = playlist, let title = songTitleTextField.text, !title.isEmpty, let artist = songArtistTextField.text, !artist.isEmpty else {return}
        SongController.createSong(with: title, and: artist, addTo: playlist)
        //Clean up the dust
        songTitleTextField.text = ""
        songArtistTextField.text = ""
        songTableView.reloadData()
    }
}

extension SongDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let songs = playlist?.songs else {return 0}
       return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for:
            indexPath)
        guard let playlist = playlist else {return UITableViewCell()}
        if let song = playlist.songs?[indexPath.row] as? Song {
            cell.textLabel?.text = song.artist
            cell.detailTextLabel?.text = song.title
    }
        return cell
    }
}

extension SongDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let playlist = playlist, let song = playlist.songs?[indexPath.row] as? Song else {return}
            SongController.deleteSong(song: song)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
