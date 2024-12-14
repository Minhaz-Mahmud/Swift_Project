

import SwiftUI

struct NewDogView: View {
    @EnvironmentObject var dataManager: DataManager
    @State var newDog: String = ""
    @State var dogid: String = ""
    var body: some View {
        VStack{
            TextField("Task", text:$newDog)
            TextField("Task date", text:$dogid)
            Button{
                dataManager.addDog(dogBreed: newDog,dogId: dogid)
            } label: {
                Text("Save")
            }
        }.padding()
    }
}

struct NewDogView_Previews: PreviewProvider{
    static var previews: some View {
        NewDogView()
    }
}
