//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Mohamed Mostapha on 21/09/2023.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image1: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func getImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image1 = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })

            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME 🤓") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcampHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcampHomeView()
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = viewModel.image1 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image2 = viewModel.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.getImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.getImage2()
//            }
            
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("Hight : \(Thread.current) \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("UserInitiated : \(Thread.current) \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("Medium : \(Thread.current) \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("Low : \(Thread.current) \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("Utility : \(Thread.current) \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background : \(Thread.current) \(Task.currentPriority)")
//            }
           
            
//            Task(priority: .userInitiated) {
//                print("UserInitiated : \(Thread.current) \(Task.currentPriority)")
//
//                Task.detached {
//                    print("detached : \(Thread.current) \(Task.currentPriority)")
//                }
//            }
           
//        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
