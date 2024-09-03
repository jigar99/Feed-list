//
//  ContentView.swift
//  Feed
//
//  Created by Jigar on 8/9/24.
//JIgar 

import SwiftUI



struct ContentView: View {
    
  
    
    init(){
       
        #if Dev
        print("Dev")
        #elseif Prod
        print("PRod")
        #elseif Staging
                print("Staging")
        #endif
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
