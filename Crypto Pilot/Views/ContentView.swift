//
//  ContentView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 07/12/2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Color.primary()
                .ignoresSafeArea(.all)
            VStack {
                ForEach(viewModel.allocations) { allocation in
                    Text("\(allocation.symbol) (\(allocation.ratio ?? 0.0)%)")
                        .foregroundColor(Color.green)
                }
            }
        }
        .background(Color.primary())
        .ignoresSafeArea()
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = UIColor.clear
            viewModel.getListings()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro")
    }
}
