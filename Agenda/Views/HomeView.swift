//
//  HomeView.swift
//  Agenda
//
//  Created by joaquin sarandeses on 12/1/23.
//

import SwiftUI



struct EventResponseModel: Decodable {
    
    let name: String?
    let date: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = Int(date)
        } else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        } else if let  _ = try? values.decodeIfPresent(Float.self, forKey: .date)  {
            self.date = nil
        }else {
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct EventPresentationModel: Identifiable{
    let id = UUID()
    let name:String
    let date: Int
}

struct HomeView: View {
    @State var dateSelected: Date = Date()
    @State var events: [EventPresentationModel] = []
    @State private var shouldShowNewEvent = false
    
    var body: some View {
        ZStack{
            VStack(spacing:0){
                VStack(spacing:5){
                    Text("Agenda")
                        .foregroundColor(.white)
                        .font(.system(size:50, weight: .bold))
                        .padding(.top, 20)
                    
                    DatePicker("", selection: $dateSelected, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(10)
                    
                    
                    
                    Spacer()
                    ScrollView{
                        LazyVStack(spacing: 2) {
                            ForEach(events) { event in
                                HStack{
                                    /*@START_MENU_TOKEN@*/Text(event.name)/*@END_MENU_TOKEN@*/
                                        .fixedSize()
                                        .bold()
                                        .foregroundColor(Color.blue)
                                    Spacer()
                                    Text("\(event.date)")
                                        .fixedSize()
                                        .bold()
                                        .foregroundColor(.blue)
                                }
                                .frame(height:50)
                                .padding(5)
                                .background(.white)
                                .cornerRadius(5)
                            }
                        }
                        
                    }
                    
                }
                .padding()
                .background(.cyan)
            }
        }
        .sheet(isPresented: $shouldShowNewEvent, content:{ NewEventView(shouldShowNewEvent: $shouldShowNewEvent) {
            getEvents()
        }})
        
        .toolbar{
            Button{
                shouldShowNewEvent = true
            }label: {
                Image(systemName: "plus")
                    .font(.system(size: 20))
            }
        }
        
        
        .onAppear {
            getEvents()
        }.onChange(of: dateSelected){newValue in
            let newDate = Int(dateSelected.timeIntervalSince1970)
            
        }
    }
    
    func getEvents(){
        
        
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/db/eventos", type: .GET) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
            }else if let data = data, let response = response as? HTTPURLResponse{
                print(response.statusCode)
                print(String(bytes:data, encoding: .utf8))
                if response.statusCode == 200{
                    onSucces(data: data)
                    
                }else{
                    onError(error: error?.localizedDescription ?? "Request error")
                    
                }
            }
        }
    }
    
    func onSucces(data: Data){
        do{
            let eventsNotFiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            events = eventsNotFiltered.compactMap({ eventNotFiltered in
                guard let date = eventNotFiltered?.date else { return nil }
                return EventPresentationModel(name: eventNotFiltered?.name ?? "", date: date)
            })
        }catch{
            self.onError(error: error.localizedDescription)
        }
    }
    func onError(error: String){
        
    }
    
    
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


