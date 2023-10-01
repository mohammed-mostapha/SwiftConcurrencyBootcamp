//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Mohamed Mostapha on 23/09/2023.
//


/*
 
 VALUE TYPES:
 - Struct, Enum, String, etc.
 - stored in the stack
 - Faster
 - Thread Safe!
 - When you assign or copy -value type- a new copy of the data is created.
 
 
 REFERENCE TYPES:
 - Classes, Funcitons, Actors
 - Stored in the heap
 - Slower, but synchronized
 - NOT Thread safe (by default)
 - When you assign or pass a -reference type- to a new reference to original instance will be created (pointer)
 
 -------------------------
 
 STACK:
 - Stores values types
 - variables allocated on the stack are stored directly to the memory, and acces to this memory is very fast.
 - Each Thread has its own stack
 
 
 
 HEAP:
 - Stores reference types
 - Shared accross Threads
 
 -------------------------
 
 Struct:
 - Based on VALUES
 - can be mutated
 - Stored in the STACK
 
 Class:
 - Based on REFERENCES (INSTANCES)
 - Stored in the HEAP
 - Inherit from other classes
 
 Actor:
 - Same as Class, but Thread Safe.
 
 -------------------------
 
 Struct: Data Models, Views
 Class: ViewModels
 Actor: Shared 'Manager' and 'Data Store'
 
 */



import SwiftUI

actor StructClassActorBootcampDataManager {
    
    func getDataFromDatabase() {
        
    }
    
}

class StructClassActorViewModel: ObservableObject {
    
    @Published var title = ""
    
    init() {
        print("ViewModel Init")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View Init")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}


struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}



struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp(isActive: true)
    }
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test Started!")
        
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
        
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""

            -------------------
        
        """)
    }
    
    private func structTest1() {
        print("StructTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        // This is not modifying the object itself...this is creating a new object
        print("Passing the values of objectA to objectb")
        objectB.title = "Second title!"
        print("ObjectB title changed!")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        print("ClassTest1")
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        print("Passing the REFERENCE of objectA to objectb")
        objectB.title = "Second title!"
        print("ObjectB title changed!")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)

    }
    
    private func actorTest1() {
        Task {
            print("ClassTest1")
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            print("Passing the REFERENCE of objectA to objectb")
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed!")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }

    }
    
}


struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("struct1: ", struct1.title)
        struct1.title = "Title2"
        print("struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("struct4: ", struct4.title)
    }
    
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "title1")
        print("class1: ", class1.title)
        class1.title = "Title2"
        print("class1: ", class1.title)
        
        let class2 = MyClass(title: "title1")
        print("class2: ", class2.title)
        class2.updateTitle(newTitle: "title2")
        print("class2: ", class2.title)
    }
    
}
