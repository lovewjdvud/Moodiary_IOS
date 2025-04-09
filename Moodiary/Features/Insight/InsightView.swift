//
//  FeedView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture
struct InsightView: View {
    let store: StoreOf<InsightFeature>
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Hello, InsightView!")
            CompanyListView()
        }
    }
}

//#Preview {
//    InsightView(
//        store: Store(initialState: InsightFeature.State()) {
//            InsightFeature()
//        })
//}

struct CompanyCard: View {
    let name: String
    let rating: Double
    let reviews: Int
    let image: String
    let category1: String
    let category2: String
    
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                    }
                }
                
                HStack {
                    Text("Rating \(String(format: "%.1f", rating))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("Reviews: \(reviews.formatted())")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                HStack(spacing: 8) {
                    HStack {
                        Image(systemName: "sofa.fill")
                            .font(.system(size: 12))
                        Text(category1)
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                    
                    HStack {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 12))
                        Text(category2)
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(16)
    }
}
struct CompanyListView: View {
    let companies = [
        CompanyInfo(name: "Hygge Living", rating: 4.8, reviews: 2183, image: "hygge", category1: "Furniture", category2: "Danish Living"),
        CompanyInfo(name: "Chair & Son", rating: 4.5, reviews: 1397, image: "chair", category1: "Furniture", category2: "Wooden Products"),
        CompanyInfo(name: "Good Home", rating: 4.2, reviews: 3234, image: "home", category1: "Furniture", category2: "Cheap furniture")
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text("Recently reviewed companies")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.vertical, 10)
                
                List {
                    ForEach(companies, id: \.name) { company in
                        CompanyCard(
                            name: company.name,
                            rating: company.rating,
                            reviews: company.reviews,
                            image: company.image,
                            category1: company.category1,
                            category2: company.category2
                        )
                        .listRowBackground(Color.black)
                        .listRowSeparator(.hidden)
                        .padding(.bottom, 10)
                    }
                    
                    Button(action: {
                        // Action for view more
                    }) {
                        Text("View more")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.purple)
                            .cornerRadius(25)
                            .padding(.horizontal, 50)
                    }
                    .listRowBackground(Color.black)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }
    }
}

struct CompanyInfo {
    let name: String
    let rating: Double
    let reviews: Int
    let image: String
    let category1: String
    let category2: String
}
