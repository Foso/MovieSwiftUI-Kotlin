//
//  MoviesHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import common

struct MoviesHome : View {
    @EnvironmentObject private var store: ObservableStore<AppState>
    @ObservedObject private var selectedMenu = MoviesSelectedMenuStore(selectedMenu: .popular)
    @State private var isSettingPresented = false
    
    private var segmentedView: some View {
        ScrollableSelector(items: AppStateKt.allMovieMenuValues().map{ $0.title },
                           selection: Binding<Int>(
                            get: {
                                Int(self.selectedMenu.menu.ordinal)
                           },
                            set: {
                                self.selectedMenu.menu = MoviesMenu.Companion().fromOrdinal(ordinal: Int32($0))
                           })
        )
    }
    
    var body: some View {
        NavigationView {
            Group {
                if selectedMenu.menu.name == MoviesMenu.genres.name {
                    GenresList(headerView2: AnyView(segmentedView))
                } else {
                    MoviesHomeList(menu: $selectedMenu.menu,
                                   pageListener: selectedMenu.pageListener,
                                   headerView: AnyView(segmentedView))
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.isSettingPresented = true
                }) {
                    HStack {
                        Image(systemName: "wrench").imageScale(.medium)
                    }.frame(width: 30, height: 30)
                }
            ).sheet(isPresented: $isSettingPresented,
                    content: { SettingsForm() })
        }
    }
}

#if DEBUG
struct MoviesHome_Previews : PreviewProvider {
    static var previews: some View {
        MoviesHome().environmentObject(sampleStore)
    }
}
#endif
