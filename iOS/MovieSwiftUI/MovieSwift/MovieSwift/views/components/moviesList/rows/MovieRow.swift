//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct MovieRow: ConnectedView {
    struct Props {
        let movie: Movie
    }
    
    // MARK: - Init
    let movieId: String
    var displayListImage = true
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]! as! Movie)
    }
    
    func body(props: Props) -> some View {
        HStack {
            ZStack(alignment: .topLeading) {
                MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.poster_path,
                                                                                size: .medium),
                                 posterSize: .medium)
                if displayListImage {
                    ListImage(movieId: movieId)
                }
            }
            .fixedSize()
            VStack(alignment: .leading, spacing: 8) {
                Text(props.movie.userTitle(appUserDefaults: appUserDefaults))
                    .titleStyle()
                    .foregroundColor(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(props.movie.vote_average * 10))
                    Text(props.movie.releaseDate)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                Text(props.movie.overview)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .contextMenu{ MovieContextMenu(movieId: self.movieId) }
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        List {
            MovieRow(movieId: MovieKt.sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif
