import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationView {
                List(viewModel.categories) { category in
                    NavigationLink(
                        destination: ArtistListView(category: category)
                            .environmentObject(viewModel)
                    ) {
                        VStack {
                            HStack(alignment: .center){
                                URLImage(urlString: category.picture)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                                    .cornerRadius(10)
                                
                                Text(category.name)
                                    .font(.headline)
                                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0.09411764706, blue: 0.2823529412, alpha: 1))) //#001848
                            }
                        }
                    
                        .padding(8)
                    } .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Music Categories")
                .navigationBarTitleDisplayMode(.inline)
               
                .onAppear {
                    viewModel.fetchCategories()
                }
            }
            .tabItem {
                Image(systemName: "music.note.list")
                Text("Categories")
            }
            .tag(0)
            
            
            FavoriteView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorited")
                }
                .tag(1)
        }
        .accentColor(Color(#colorLiteral(red: 0, green: 0.3568627451, blue: 0.7725490196, alpha: 1)))
    }
}
