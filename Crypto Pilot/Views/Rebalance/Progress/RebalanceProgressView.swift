//
//  ContentView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI

struct RebalanceProgressView: View {
    @ObservedObject var viewModel = RebalanceProgressViewModel()
    @Binding var viewState: RebalanceViewState
    @Binding var presentedAsModal: Bool
    
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
                    StepView(step: 1, title: "Getting the latest values", inProgress: viewModel.rebalanceProgress.rawValue == 1, isFinished: viewModel.rebalanceProgress.rawValue > 1)
                    StepView(step: 2, title: "Executing sell orders", inProgress: viewModel.rebalanceProgress.rawValue == 2, isFinished: viewModel.rebalanceProgress.rawValue > 2)
                    StepView(step: 3, title: "Updating user portfolio", inProgress: viewModel.rebalanceProgress.rawValue == 3, isFinished: viewModel.rebalanceProgress.rawValue > 3)
                    StepView(step: 4, title: "Executing buy orders", inProgress: viewModel.rebalanceProgress.rawValue == 4, isFinished: viewModel.rebalanceProgress.rawValue > 4)
                    StepView(step: 5, title: "Done", inProgress: false, isFinished: viewModel.rebalanceProgress.rawValue == 5)
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
                Spacer()
                
                // Button
                Button("Great! I am done") {
                    if viewModel.shouldAskForNotificationPermission {
                        viewState = .notificationPermission
                    } else {
                        presentedAsModal = false
                    }
                }
                .buttonStyle(PrimaryButton())
                .offset(y: -20)
                .disabled(viewModel.rebalanceProgress != .done)
                .opacity(viewModel.rebalanceProgress == .done ? 1.0 : 0.0)
            }
        }
        .onAppear {
            viewModel.startRebalance()
        }
    }
}

struct StepCircle: View {
    var step: Int
    var inProgress = false
    var isFinished = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(inProgress ? Color.blue() : isFinished ? Color.green() : Color.gray())
            if inProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white()))
            } else if isFinished {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Text("\(step)")
                    .foregroundColor(Color.blakish())
                    .font(.system(size: 24))
            }
        }.frame(width: 64, height: 64, alignment: .center)
    }
}

struct StepView: View {
    var step: Int
    var title: String
    var inProgress: Bool
    var isFinished: Bool
    
    var body: some View {
        HStack {
            StepCircle(step: step, inProgress: inProgress, isFinished: isFinished)
            Text(title)
                .foregroundColor(Color.white())
                .offset(x: 20)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RebalanceProgressView(viewState: .constant(.rebalanceInProgress), presentedAsModal: .constant(false))
                .previewDevice("iPhone 12 Pro")
            RebalanceProgressView(viewState: .constant(.rebalanceInProgress), presentedAsModal: .constant(false))
                .previewDevice("iPhone 8")
        }
    }
}
