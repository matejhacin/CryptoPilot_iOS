//
//  HomeView.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 30/05/2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            
            // Background
            Color.blakish()
                .ignoresSafeArea()
            
            // Content
            VStack(alignment: .leading, spacing: 32) {
                
                // Logo
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                    Spacer()
                }
                
                // Portfolio value
                PortfolioValueView()
                
                // Coin table
                VStack {
                    TableHeaderView()
                    
                    // Coin holding rows
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(0..<20) { _ in
                                CoinHoldingRowView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

fileprivate struct PortfolioValueView: View {
    var body: some View {
        VStack {
            
            // Title
            HStack {
                Text("Portfolio value:")
                    .foregroundColor(.white())
                    .font(.footnote)
                    .offset(x: 10)
                Spacer()
            }
            
            // Value
            HStack {
                Spacer()
                Text("$69,420.00")
                    .foregroundColor(.white())
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .offset(x: -10)
            }
            
            // Previous value
            HStack {
                Text("Portfolio since last time app opened:")
                    .foregroundColor(.lightBlue())
                    .font(.footnote)
                Spacer()
                Text("$66,999.00")
                    .foregroundColor(.lightBlue())
                    .font(.body)
            }
            .padding(.all, 10)
            .frame(maxWidth: .infinity)
            .background(RoundedCorners(color: .blakish(), tl: 0, tr: 0, bl: 20, br: 20))
            .opacity(0.5)
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
        .background(Color.blue())
        .cornerRadius(20)
    }
}

fileprivate struct HorizontalDivider: View {
    var body: some View {
        Color.darkGray()
            .frame(height: 1)
    }
}

fileprivate struct TableHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("COIN")
                        .foregroundColor(.white())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                Text("HOLDING")
                    .foregroundColor(.altGray())
                    .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    Text("PRICE")
                        .foregroundColor(.altGray())
                }
                .frame(maxWidth: .infinity)
            }
            HorizontalDivider()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

fileprivate struct CoinHoldingRowView: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 10) {
                    Image("logo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("BTC")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Text("$1,000.00")
                            .foregroundColor(.white())
                    }
                    HStack {
                        Spacer()
                        Text("10%")
                            .foregroundColor(.white())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.trailing, 16)
                
                VStack {
                    HStack {
                        Spacer()
                        Text("$17,784.00")
                            .foregroundColor(.white())
                    }
                    HStack {
                        Spacer()
                        Text("+2.43%")
                            .foregroundColor(.green())
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.green())
                    }
                }
                .frame(maxWidth: .infinity)
            }
            Spacer()
            HorizontalDivider()
        }
        .frame(height: 60)
    }
}
