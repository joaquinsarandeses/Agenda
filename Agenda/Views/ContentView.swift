//
//  ContentView.swift
//  Agenda
//
//  Created by joaquin sarandeses on 10/1/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var shouldShowHome:Bool = false
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationView{
            ZStack{
                bgc
                VStack {
                    
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 20)
                    
                    
                    TextField("Email", text: $email)
                        .frame(height: 60)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(10)
                    
                    SecureField("Password", text: $password)
                        .frame(height: 60)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(10)
                    Spacer()
                    
                    ImageView()
                        .padding(.vertical,10)
                        .shadow(radius: 20)
                    
                    
                    
                    Button {
                        if email.isEmpty || password.isEmpty {
                            self.showAlert = true
                        } else {
                            login(email: email, password: password)
                            
                        }
                        print("Hola jefe")
                        
                    } label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 160)
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Por favor rellena todos los campos ."), dismissButton: .default(Text("OK")))
                    }
                    
                    .background(NavigationLink(destination: HomeView(),
                                               isActive: $shouldShowHome) {
                        EmptyView()
                    })
                    
                    
                    NavigationLink{
                        RegisterView()
                    }label:{
                        Text("¿No estas logueado? Pulsa aquí.")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .bold))
                            .padding(.top, 10)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    var bgc: some View{
        
        Color("Colorsito")
            .ignoresSafeArea()
        
    }
    
    func onSucces(){
        shouldShowHome = true
        
    }
    func onError(error: String){
        //tengo que poner la alerta por si el usuario y la contraseña no coinciden
    }
    func login(email: String, password: String){
        
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : password
        ]
        
    
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/login", params: dictionary) { data, response, error in
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
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct ImageView: View{
    
    var body: some View{
        Image("harambe")
            .resizable()
            .clipShape(Circle())
        
        
        
        
    }
    
}

