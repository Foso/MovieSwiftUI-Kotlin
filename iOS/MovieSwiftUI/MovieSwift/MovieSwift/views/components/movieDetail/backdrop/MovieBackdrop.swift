//
//  MovieBackdrop.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct MovieBackdrop: View {
    @EnvironmentObject var store: ObservableStore<AppState>
    @State var seeImage = false
    
    let movieId: String
    var movie: Movie! {
        let x = store.state.moviesState.withMovieId(movieId: movieId)
        return x
    }
    
    //MARK: - View computed properties
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MovieTopBackdropImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.backdrop_path ?? movie.poster_path,
                                                                                 size: .original),
                             isExpanded: $seeImage)
                .onTapGesture {
                    withAnimation{
                        self.seeImage.toggle()
                    }
            }
            if !seeImage {
                MovieBackdropInfo(movie: movie)
            }
        }.listRowInsets(EdgeInsets())
    }
}


#if DEBUG
struct MovieBackdrop_Previews : PreviewProvider {
    static var previews: some View {
        MovieBackdrop(movieId: MovieKt.sampleMovie.id).environmentObject(sampleStore)
    }
}
#endif
