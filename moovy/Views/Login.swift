//
//  Login.swift
//  moovy
//
//  Created by Oladimeji Oladiti on 07/05/2024.
//
import SwiftUI

struct Login : View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var rememberPassword = false
    var body: some View {
        
        ZStack {
            ColorManager.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 59) {
                Image("App Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Welcome back !")
                    .font(Font.system(size: 35, weight: .bold))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                
                VStack(spacing:20){
                    TextField("", text: $username, prompt: Text("email").foregroundColor(.gray))
                        .padding([.top, .leading, .bottom])
                        .frame(width: nil, height: 40.0)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.9), lineWidth: 1)
                        )
                        .padding([.leading, .bottom, .trailing])
                        .foregroundColor(Color.white.opacity(0.7)) // lighter gray
                    
                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                        .padding()
                        .frame(height: 40.0)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.9), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .foregroundColor(Color.white.opacity(0.7)) // lighter gray
                    
                }
                
                HStack(spacing: 80.0){
                    
                     Spacer()
                    
                    Text("Forgot Password?")
                        .underline()
                        .font(Font.system(size: 13, weight: .bold))
                        .foregroundColor(.gray)
                    
                }
                
                Button(action: {
                    // Login action
                }) {
                    Text("Log In")
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(10)
                        .frame(width: UIScreen.main.bounds.width - 53)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                        )
                }
                
                Text("Sign Up")
                    .underline()
                    .font(Font.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                
            }
            .padding()
        }
    }
}

#Preview {
    Login()
}
