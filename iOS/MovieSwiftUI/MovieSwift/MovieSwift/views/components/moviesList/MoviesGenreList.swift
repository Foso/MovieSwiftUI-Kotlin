//
//  MoviesGenreList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

// MARK: - Page listener
final class MovieGenrePageListener: MoviesPagesListener {
    var genre: Genre
    var dispatch: DispatchFunction?
    
    var sort: MoviesSort = MoviesSort.bypopularity {
        didSet {
            currentPage = 1
            loadPage()
        }
    }
    
    override func loadPage() {
        dispatch!(movieActions.fetchMoviesGenre(genre: genre, page: Int32(currentPage), sortBy: sort))
    }
    
    init(genre: Genre) {
        self.genre = genre
        super.init()
    }
}

// MARK: - View
struct MoviesGenreList: ConnectedView {
    

    let genre: Genre
    let pageListener: MovieGenrePageListener
    @State var isSortSheetPresented = false
    @State var selectedSort: MoviesSort = MoviesSort.bypopularity
    
    init(genre: Genre) {
        self.genre = genre
        self.pageListener = MovieGenrePageListener(genre: self.genre)
    }
   
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> MovieGenreListProps {
        return MovieGenreListPropsKt.movieGenreProps(genreId: genre.id)(state, dispatch)
//        Props(movies: state.moviesState.withGenreId(genreId: genre.id),
//              dispatch: dispatch)
    }
 
    
    func body(props: MovieGenreListProps) -> some View {
        MoviesList(movies: props.movies, displaySearch: false, pageListener: pageListener)
            .navigationBarItems(trailing: (
                Button(action: {
                    self.isSortSheetPresented.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.steam_gold)
                })
            ))
            .navigationBarTitle(Text(genre.name))
            .actionSheet(isPresented: $isSortSheetPresented,
                         content: { ActionSheet.sortActionSheet(onAction: { sort in
                            if let sort = sort {
                                self.selectedSort = sort
                                self.pageListener.sort = sort
                            }
                         })
            })
            .onAppear {
                self.pageListener.dispatch = props.dispatcher
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
/*
struct MoviesGenreList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesGenreList(genre: Genre(id: 0, name: "test")).environmentObject(store)
    }
}
 */
#endif
