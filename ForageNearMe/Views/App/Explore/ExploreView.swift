//
//  ExploreView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 25/10/2021.
//

import SwiftUI
import FirebaseFirestore

struct ExploreView: View {
    
    @EnvironmentObject var viewModel: HomeView.ViewModel
    
    @EnvironmentObject var locationManager: LocationManager
    
    @Environment(\.dismiss) var dismiss
    
    @State var searchIsTapped: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: .center)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 20) {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .font(.system(size: 18, weight: .semibold))
                        .scaledToFit()
                        .frame(width: 21, height: 21)
                }
                .foregroundColor(Color.black.opacity(0.75))
                
                
                HStack(spacing: 8) {
                    
                    TextField("Search", text: $viewModel.searchText)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .overlay(
                            VStack {
                                if viewModel.searchText.count > 1 {
                                    Button(action: {
                                        viewModel.searchText = ""
                                    }, label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    })
                                }
                            }
                            ,alignment: .trailing
                        )
                    VStack {
                        if searchIsTapped {
                            
                            Button {
                                searchIsTapped = false
                                viewModel.searchText = ""
                            } label: {
                                Text("Cancel")
                            }
                            .foregroundColor(.black)
                            .transition(.customCancelTransition)
                            .animation(.easeInOut, value: searchIsTapped)
                        }
                    }
                    .transition(.customCancelTransition)
                    .animation(.easeInOut, value: searchIsTapped)
                    
                }// - HStack
                
                .onTapGesture {
                    searchIsTapped = true
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white)
            
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray.opacity(0.25))
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.filteredPosts){ post in
                        
                        NavigationLink {
                            LazyView(PostDetailView(PostDetailView.ViewModel(post)))
                        } label: {
                            ExplorePostCell(viewModel: ExplorePostCell.ViewModel(post: post, location: locationManager.lastLocation))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                                .padding(.horizontal, 20)
                        }
                        .isDetailLink(false)
                        .buttonStyle(FlatLinkStyle())
                    }
                }
                .padding(.top, 15)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .background(Color.gray.opacity(0.075))
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onDisappear(perform: {
            viewModel.searchText = ""
        })
    }
}

struct ExploreView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        NavigationView {
            
            ExploreView()
                .environmentObject(HomeView.ViewModel(posts: [Post(id: UUID().uuidString, name: "Elderflower", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/foragenearme.appspot.com/o/post_images%2FF2A86825-BE3F-42D7-B631-1685D1795E74?alt=media&token=592b9723-be4a-44fc-a8d0-2ecfbb99b979", notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", location: GeoPoint(latitude: 0, longitude: 0))], searchIsActive: true))
        }
    }
}
