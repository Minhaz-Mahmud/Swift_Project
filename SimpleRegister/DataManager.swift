import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var dogs: [Dog] = []
    
    init() {
        fetchDogs()
    }
    
    func fetchDogs() {
        dogs.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? "0"
                    let breed = data["breed"] as? String ?? ""
                    let dog = Dog(id: id, breed: breed)
                    self.dogs.append(dog)
                }
            }
        }
    }
    
    func addDog(dogBreed: String, dogId: String) {
        let db = Firestore.firestore()
        let uniqueId = UUID().uuidString // Generate a unique ID for Firestore
        let ref = db.collection("Dogs").document(uniqueId)
        
        ref.setData(["breed": dogBreed, "id": dogId]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Dog added successfully")
                self.fetchDogs() // Refresh the list after adding
            }
        }
    }
}
