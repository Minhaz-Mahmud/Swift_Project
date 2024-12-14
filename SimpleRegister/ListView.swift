import SwiftUI
import Firebase
import FirebaseAuth

struct ListView: View {
    @Binding var userIsLoggedIn: Bool  // Added this binding
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false

    var body: some View {
        NavigationView {
            List(dataManager.dogs, id: \.id) { dog in
                HStack {
                    Text(dog.breed)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading) // Aligns the breed to the left
                    Text(dog.id)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .trailing) // Aligns the ID to the right
                }
            }
            .navigationTitle("Todo")
            .navigationBarItems(
                leading: Button(action: logout) {
                    Text("Logout")
                },
                trailing: Button(action: { showPopup.toggle() }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showPopup) {
                NewDogView()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false // Update the login state here
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLoggedIn: .constant(true))
            .environmentObject(DataManager())
    }
}