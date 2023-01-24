//
//  NewEventView.swift
//  Agenda
//
//  Created by joaquin sarandeses on 20/1/23.
//

import SwiftUI


struct NewEventView: View {
    @Binding var shouldShowNewEvent : Bool
    @State var dateSelected: Date = Date()
    @State var name: String = ""
    @State var finalDate: Int = 0
    
    
    var completion: ()->() = {}
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            VStack{
                Text("Añadir Evento")
                    .foregroundColor(.blue)
                    .font(.system(size:50, weight: .bold))
                    .padding(.top, 20)
                
                
                DatePicker("", selection: $dateSelected, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(10)
                
                
                TextField("Nombre del evento" , text: $name)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(10)
                
                Spacer()
                Button {
                    addEvent(name: name, date: finalDate)
                    
                } label: {
                    Text("Añadir evento")
                        .foregroundColor(.white)
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(25)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 100)
                }.padding(20)
                
            }
            
        }
        .background(.cyan)
    }
    
    
    func onSucces(){
            
            completion()
            shouldShowNewEvent = false
        
    }
    func onError(error: String){
        
    }
    
    func addEvent(name: String, date: Int){
        let timeInterval = dateSelected.timeIntervalSince1970
        let finalDate = Int(timeInterval)
        
        let dictionary: [String: Any] = [
            "name" : name,
            "date" : finalDate
        ]
        
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/db/events", params: dictionary) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
            }else if let data = data, let response = response as? HTTPURLResponse{
                print(response.statusCode)
                print(String(bytes:data, encoding: .utf8))
                if response.statusCode == 200{
                    onSucces()
                }else{
                    onError(error: error?.localizedDescription ?? "Request error")
                }
            }
        }
    }
    
    
    
    struct NewEventView_Previews: PreviewProvider {
        static var previews: some View {
            NewEventView(shouldShowNewEvent: .constant(true))
        }
    }
}
