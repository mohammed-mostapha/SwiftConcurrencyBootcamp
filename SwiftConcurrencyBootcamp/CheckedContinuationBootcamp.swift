//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Mohamed Mostapha on 22/09/2023.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            throw error
        }
        
    }
    
    func getData2(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHearImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHearImageFromDatabase() async -> UIImage {
         await withCheckedContinuation { continuation in
            getHearImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
    
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func fetchImage() async throws {
        guard let url = URL(string: "https://picsum.photos/300") else { return }
        
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            throw error
        }
    }
    
    func getHeartImage() async {
        self.image = await networkManager.getHearImageFromDatabase()
    }
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            try? await viewModel.fetchImage()
            await viewModel.getHeartImage()
        }
    }
}

struct CheckedContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationBootcamp()
    }
}
