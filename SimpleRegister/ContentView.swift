import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var isSignUpMode = true
    @State private var errorMessage = ""
    @State private var showListView = false

    var body: some View {
        VStack {
            if userIsLoggedIn {
                ListView(userIsLoggedIn: $userIsLoggedIn)
            } else {
                content
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    showListView = true
                }) {
                    Text("About Us")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showListView) {
                    APIListView()
                }
            }
        }
    }

    var content: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(isSignUpMode ? "Sign Up" : "Sign In")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.red)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .foregroundColor(.white)
                        .font(.headline)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.white))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .foregroundColor(.white)
                        .font(.headline)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.white))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                        .padding(.top, 10)
                }

                Button(action: {
                    if isSignUpMode {
                        register()
                    } else {
                        login()
                    }
                }) {
                    Text(isSignUpMode ? "Sign Up" : "Sign In")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                }
                .padding(.top)

                Button(action: {
                    isSignUpMode.toggle()
                }) {
                    Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn = true
                    }
                }
            }
        }
    }



    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                userIsLoggedIn = true
                errorMessage = ""
            }
        }
    }

}    
   