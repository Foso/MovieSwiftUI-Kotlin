//
//  MoviesHomeList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import common

struct MoviesHomeList: ConnectedView {
    struct Props {
        let movies: [String]
    }
    
    @Binding var menu: MoviesMenu
    
    let pageListener: MoviesMenuListPageListener
    var headerView: AnyView?

    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        return Props(movies: state.moviesState.moviesList[menu] as! [String]? ?? [] )
    }
    
    func body(props: Props) -> some View {
        MoviesList(movies: props.movies,
                   displaySearch: true,
                   pageListener: pageListener,
                   headerView: headerView)
            .navigationBarTitle(menu.title)
    }
}

#if DEBUG
struct MoviesHomeList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviesHomeList(menu: .constant(.popular),
                           pageListener: MoviesMenuListPageListener(menu: .popular))
                .environmentObject(sampleStore)
        }
    }
}
#endif
