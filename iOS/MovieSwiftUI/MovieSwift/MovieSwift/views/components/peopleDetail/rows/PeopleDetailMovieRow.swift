//
//  PeopleDetailMovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct PeopleDetailMovieRow : View {
    @EnvironmentObject var store: ObservableStore<AppState>
    
    let movieId: String
    private var movie: Movie! {
        return store.state.moviesState.withMovieId(movieId: movieId)
    }
    let role: String
    
    let onMovieContextMenu: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.poster_path,
                                                                                size: .small),
                                 posterSize: .small)
                ListImage(movieId: movieId)
            }.fixedSize()
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                Text(role)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }.contextMenu{ MovieContextMenu(movieId: movieId, onAction: onMovieContextMenu) }
    }
}

#if DEBUG
struct PeopleDetailMovieRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailMovieRow(movieId: MovieKt.sampleMovie.id, role: "Test", onMovieContextMenu: {
            
        }).environmentObject(sampleStore)
    }
}
#endif
