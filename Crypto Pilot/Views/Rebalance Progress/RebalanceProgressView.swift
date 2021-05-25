//
//  ContentView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI

struct RebalanceProgressView: View {
    @ObservedObject var viewModel = RebalanceProgressViewModel()
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background color
            Color.blakish()
                .ignoresSafeArea(.all)
            
            // Content
            VStack {
                Spacer()
                // Steps
                VStack(spacing: 58) {
                    StepView(title: "Getting the latest values")
                    StepView(title: "Executing sell orders")
                    StepView(title: "Updating user portfolio")
                    StepView(title: "Executing buy orders")
                    StepView(title: "Done")
                }
                .offset(x: 21)
                .background(HStack {
                    Rectangle()
                        .frame(width: 8)
                        .foregroundColor(Color.lightBlue())
                        .offset(x: 48.5)
                        .padding(.vertical, 10)
                    Spacer()
                })
                Spacer()
                // Button
                Button("Start rebalance") {
                    
                }
                .buttonStyle(PrimaryButton())
                .offset(y: -20)
            }
        }
    }
}

struct StepCircle: View {
    @State var isFinished = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(isFinished ? Color.green() : Color.gray())
            if isFinished {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Text("X")
                    .foregroundColor(Color.blakish())
                    .font(.system(size: 24))
            }
        }.frame(width: 62, height: 62, alignment: .center)
    }
}

struct StepView: View {
    var title: String
    
    var body: some View {
        HStack {
            StepCircle()
            Text(title)
                .foregroundColor(Color.white())
                .offset(x: 20)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RebalanceProgressView()
            .previewDevice("iPhone 12 Pro")
    }
}
