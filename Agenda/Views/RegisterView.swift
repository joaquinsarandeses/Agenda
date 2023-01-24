//
//  RegisterView.swift
//  Agenda
//
//  Created by joaquin sarandeses on 10/1/23.
//

import SwiftUI

struct RegisterView: View {
    
    
    @State var email: String = ""
    @State var password: String = ""
    @State var reppass: String = ""
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Register")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                
                TextField("Email" , text: $email)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(10)
                
                SecureField("Contraseña", text: $password)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(10)
                
                
                SecureField("Repetir Contraseña", text: $reppass)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(10)
                
                Spacer()
                ImageView()
                
                Button {
                    
                    if email.isEmpty || password.isEmpty || reppass.isEmpty {
                            self.showAlert = true
                        } else if password != reppass {
                            self.showAlert = true
                        } else {
                            register(email: email, password: password)
                        }
                } label: {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(25)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 100)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Por favor rellena todos los campos y asegurate de que las contraseñas coincidan."), dismissButton: .default(Text("OK")))
                }
                                
                
            }
            
            .padding()
            .background(Color("Colorsito"))
        }
        
        .navigationTitle(Text(""))
    }
    
    
    
    func onSucces(){
        
            mode.wrappedValue.dismiss()
    
    }
    func onError(error: String){
        
    }
    
    func register(email: String, password: String){
        
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : password
        ]
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/register", params: dictionary) { data, response, error in
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
