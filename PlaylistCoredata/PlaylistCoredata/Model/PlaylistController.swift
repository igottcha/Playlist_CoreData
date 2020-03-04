//
//  PlaylistController.swift
//  PlaylistCoredata
//
//  Created by Chris Gottfredson on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation
import CoreData

class PlaylistController {
    
    //MARK: - Singleton
    
    static let sharedInstance = PlaylistController()
    
    //MARK: - Source of Truth
    
    var playlists: [Playlist] {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    //MARK: - CRUD
    
    func createPlaylist(with name: String) {
        Playlist(name: name)
        saveToPersistentStore()
    }
    
    func deletePlaylist(playist: Playlist) {
        CoreDataStack.context.delete(playist)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the data!!!\n \(#function)\n \(error.localizedDescription)")
        }
    }
}
