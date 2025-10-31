//
//  VideoFileManager.swift
//  ReflectRoom
//
//  Created by Andrew Lawrence on 10/26/25.
//

import Foundation

struct VideoFileManager {
    static let shared = VideoFileManager()

    func saveVideoToDocuments(videoURL: URL) -> String? {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filename = UUID().uuidString + ".mov"
        let destinationURL = documents.appendingPathComponent(filename)

        do {
            try fileManager.copyItem(at: videoURL, to: destinationURL)
            return destinationURL.path
        } catch {
            print("Error saving video to documents directory: \(error.localizedDescription)")
            return nil
        }
    }

    /// Delete a video at the given path string
    /// - Parameter path: The local path of the saved video (from Core Data)
    static func deleteVideo(at path: String) {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)

        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
                print("Successfully deleted video at \(url.path)")
            } catch {
                print("Failed to delete video: \(error.localizedDescription)")
            }
        } else {
            print("No video found at path: \(url.path)")
        }
    }

    /// Retrieve the app's documents directory URL
    static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    /// Optional: Get list of saved videos (e.g., for future playback screen)
    static func listAllSavedVideos() -> [URL] {
        let documents = documentsDirectory()
        let fileManager = FileManager.default

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
            return fileURLs.filter { $0.pathExtension == "mov" }
        } catch {
            print("Error reading documents directory: \(error.localizedDescription)")
            return []
        }
    }
}

