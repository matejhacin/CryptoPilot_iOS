//
//  ContentView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI
import Combine

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
                    StepView(step: 1, title: "Getting the latest values", state: viewModel.getStepState(for: 1))
                    StepView(step: 2, title: "Executing sell orders", state: viewModel.getStepState(for: 2))
                    StepView(step: 3, title: "Updating user portfolio", state: viewModel.getStepState(for: 3))
                    StepView(step: 4, title: "Executing buy orders", state: viewModel.getStepState(for: 4))
                    StepView(step: 5, title: "Done", state: viewModel.getStepState(for: 5))
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
                Button(viewModel.isProgressFailed ? "Restart Rebalance" : "Great! I am done") {
                    if viewModel.isProgressFailed {
                        viewModel.startRebalance()
                    } else if viewModel.shouldAskForNotificationPermission {
                        viewState = .notificationPermission
                    } else {
                        presentedAsModal = false
                    }
                }
                .buttonStyle(PrimaryButton())
                .offset(y: -20)
                .disabled(viewModel.rebalanceProgress != .done && !viewModel.isProgressFailed)
                .opacity(viewModel.rebalanceProgress == .done || viewModel.isProgressFailed ? 1.0 : 0.0)
            }
            .alert(isPresented: $viewModel.showErrorDialog, content: {
                Alert(title: Text(viewModel.isProgressFailed ? "Oops" : "Warning"), message: Text(viewModel.getErrorMessage()), dismissButton: .default(Text("Continue"), action: {
                    viewModel.showErrorDialog = false
                }))
            })
        }
        .onAppear {
            viewModel.startRebalance()
        }
    }
}

struct StepCircle: View {
    var step: Int
    var state: RebalanceProgressViewModel.StepState
    
    @State private var isAnimatingProgress = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(state.color)
            if state == .inProgress {
                Image("rebalance")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white())
                    .rotationEffect(Angle(degrees: isAnimatingProgress ? 360 : 0.0))
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false))
                    .onAppear { isAnimatingProgress = true }
                    .onDisappear { isAnimatingProgress = false }
            } else if state == .finished {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 16, height: 16)
            } else if state == .failed {
                Text("X")
                    .foregroundColor(Color.blakish())
                    .font(.system(size: 24))
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
    var state: RebalanceProgressViewModel.StepState
    
    var body: some View {
        HStack {
            StepCircle(step: step, state: state)
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
