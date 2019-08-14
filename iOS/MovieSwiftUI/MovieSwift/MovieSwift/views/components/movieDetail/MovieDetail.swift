//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common
import Combine

struct MovieDetail: ConnectedView {
    struct Props {
        let movie: Movie
        let characters: [People]?
        let credits: [People]?
        let recommended: [Movie]?
        let similar: [Movie]?
        let reviewsCount: Int?
    }
    
    let movieId: String
    
    // MARK: View States
    @State var isAddSheetPresented = false
    @State var isCreateListFormPresented = false
    @State var isAddedToListBadgePresented = false
    @State var selectedPoster: ImageData?
        
    // MARK: Computed Props
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        return Props(movie: state.moviesState.withMovieId(movieId: movieId),
                     characters: state.peoplesState.characters,
                     credits: state.peoplesState.credits,
                     recommended: state.moviesState.recommendedMovies(movieId: movieId),
                     similar: state.moviesState.similarMovies(movieId: movieId),
                     reviewsCount: state.moviesState.reviewByMovieId(movieId: movieId)?.count)
    }
    
    // MARK: - Fetch
    func fetchMovieDetails() {
        store.dispatch(movieActions.fetchDetail(movie: movieId))
        store.dispatch(peopleActions.fetchMovieCasts(movie: movieId))
        store.dispatch(movieActions.fetchRecommended(movie: movieId))
        store.dispatch(movieActions.fetchSimilar(movie: movieId))
        store.dispatch(movieActions.fetchMovieReviews(movie: movieId))
    }
    
    // MARK: - View actions
    func displaySavedBadge() {
        isAddedToListBadgePresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isAddedToListBadgePresented = false
        }
    }
    
    func onAddButton() {
        isAddSheetPresented.toggle()
    }
    
    // MARK: - Computed views
    func addActionSheet(props: Props) -> ActionSheet {
        var buttons: [Alert.Button] = []
        let wishlistButton = ActionSheet.wishlistButton(store: store, movie: movieId) {
            self.displaySavedBadge()
        }
        let seenButton = ActionSheet.seenListButton(store: store, movie: movieId) {
            self.displaySavedBadge()
        }
        let customListButtons = ActionSheet.customListsButttons(store: store, movie: movieId) {
            self.displaySavedBadge()
        }
        let createListButton: Alert.Button = .default(Text("Create list")) {
            self.isCreateListFormPresented = true
        }
        let cancelButton = Alert.Button.cancel {
            
        }
        buttons.append(wishlistButton)
        buttons.append(seenButton)
        buttons.append(contentsOf: customListButtons)
        buttons.append(createListButton)
        buttons.append(cancelButton)
        let sheet = ActionSheet(title: Text("Add or remove \(props.movie.userTitle(appUserDefaults: appUserDefaults)) from your lists"),
                                message: nil,
                                buttons: buttons)
        return sheet
    }
    
    // MARK: - Body
    
    func peopleRow(role: String, people: People?) -> some View {
        Group {
            if people != nil {
                NavigationLink(destination: PeopleDetail(peopleId: people!.id)) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(role + ": ").font(.callout)
                        Text(people!.name).font(.body).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    func peopleRows(props: Props) -> some View {
        Group {
            peopleRow(role: "Director", people: props.credits?.filter{ $0.department == "Directing" }.first)
        }
    }

    func topSection(props: Props) -> some View {
        Section {
            MovieBackdrop(movieId: movieId)
            MovieCoverRow(movieId: movieId).onTapGesture {
                self.isAddSheetPresented = true
            }
            if props.reviewsCount != nil {
                NavigationLink(destination: MovieReviews(movie: self.movieId)) {
                    Text("\(props.reviewsCount!) reviews")
                        .foregroundColor(.steam_blue)
                        .lineLimit(1)
                }
            }
            MovieOverview(movie: props.movie)
        }
    }
    
    func bottomSection(props: Props) -> some View {
        Section {
            if props.movie.keywords?.keywords?.isEmpty == false {
                MovieKeywords(keywords: props.movie.keywords!.keywords!)
            }
            if props.characters?.isEmpty == false {
                MovieCrosslinePeopleRow(title: "Cast",
                                        peoples: props.characters ?? [])
            }
            if props.credits?.isEmpty == false {
                peopleRows(props: props)
                MovieCrosslinePeopleRow(title: "Crew",
                                        peoples: props.credits ?? [])
            }
            if props.similar?.isEmpty == false {
                MovieCrosslineRow(title: "Similar Movies", movies: props.similar ?? [])
            }
            if  props.recommended?.isEmpty == false {
                MovieCrosslineRow(title: "Recommended Movies", movies: props.recommended ?? [])
            }
            if props.movie.images?.posters?.isEmpty == false {
                MoviePostersRow(posters: props.movie.images!.posters!,
                                selectedPoster: $selectedPoster)
            }
            if props.movie.images?.backdrops?.isEmpty == false {
                MovieBackdropsRow(backdrops: props.movie.images!.backdrops!)
            }
        }
    }
    
    func body(props: Props) -> some View {
        ZStack(alignment: .bottom) {
            List {
                topSection(props: props)
                bottomSection(props: props)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarItems(trailing: Button(action: onAddButton) {
                Image(systemName: "text.badge.plus").imageScale(.large)
            })
            .onAppear {
                self.fetchMovieDetails()
            }
            .actionSheet(isPresented: $isAddSheetPresented, content: { addActionSheet(props: props) })
            .sheet(isPresented: $isCreateListFormPresented,
                   content: { CustomListForm(editingListId: nil)
                    .environmentObject(store) })
                .disabled(selectedPoster != nil)
                .animation(nil)
                .blur(radius: selectedPoster != nil ? 30 : 0)
                .animation(.easeInOut)
            
            NotificationBadge(text: "Added successfully",
                              color: .blue,
                              show: $isAddedToListBadgePresented).padding(.bottom, 10)
            if selectedPoster != nil && props.movie.images?.posters != nil {
                ImagesCarouselView(posters: props.movie.images!.posters!, selectedPoster: $selectedPoster)
            }
        }
    }
    
    
}

// MARK: - Preview
#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movieId: MovieKt.sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif

