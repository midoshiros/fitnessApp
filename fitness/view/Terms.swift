//
//  Terms.swift
//  fitness
//
//  Created by Ahmad Hamdy on 06/01/2026.
//

import SwiftUI
import Foundation

struct Terms: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("username") var username: String?
    @State var name = ""
    @State var acceptedTerms = false
    
    var body: some View {
        VStack{
            
            Text("Laedernoard")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            TextField("UserName", text: $name)
                .padding()
                .background(
                   RoundedRectangle(cornerRadius: 10)
                    .stroke()
                )
                .padding(.horizontal)
            
            
            HStack(alignment: .top){
               
                Button{
                    withAnimation{
                        acceptedTerms.toggle()
                    }
                } label: {
                    if acceptedTerms {
                        Image(systemName: "square.inset.filled")
                    } else {
                        Image(systemName: "square")
                    }
                }
               
                Text("By checking you agree to the terms and enter the competition.")
            }
            
            Spacer()
            
            Button {
                
                if acceptedTerms && name.count > 2 {
                    username = name
                    dismiss()
                }
                
            } label: {
                Text("Continue")
                    .foregroundStyle(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                       RoundedRectangle(cornerRadius: 10)
                        .stroke()
                    )
                    .padding(.horizontal)
            }

        }
        
    }
}

#Preview {
    Terms()
}
