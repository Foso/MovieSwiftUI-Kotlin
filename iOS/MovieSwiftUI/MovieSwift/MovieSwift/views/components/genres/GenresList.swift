//
//  GenresList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct GenresList: View {
    @EnvironmentObject private var store: ObservableStore<AppState>
    var headerView2: AnyView?
    
    var body: some View {
        List {
            /*
            if headerView2 != nil {
                headerView2!
            }
 */
            ForEach(store.state.moviesState.genres.compactMap({ $0 as? Genre })) { genre in
                NavigationLink(destination: MoviesGenreList(genre: genre)) {
                    Text(genre.name)
                }
            }
        }
        .navigationBarTitle("Genres")
        .onAppear {
            self.store.dispatch(movieActions.fetchGenres())
        }
    }
}

#if DEBUG
struct GenresList_Previews: PreviewProvider {
    static var previews: some View {
        GenresList()
    }
}
#endif
