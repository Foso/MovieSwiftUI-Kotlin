//
//  ListImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 21/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import common

struct ListImage: ConnectedView {
    typealias Props = ListImageProps
    let movieId: String
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        ListImagePropsKt.listImapePropsMapper(movieId: movieId)(state, dispatch)
    }
    
    private func icon(props: Props) -> String? {
        if props.isInwishlist {
            return "heart.fill"
        } else if props.isInSeenlist {
            return "eye.fill"
        } else if props.isInCustomList {
            return "pin.fill"
        }
        return nil
    }
    
    func body(props: Props) -> some View {
        Group {
            if icon(props: props) != nil {
                Image(systemName: icon(props: props)!)
                    .imageScale(.small)
                    .foregroundColor(.white)
                    .position(x: 13, y: 15)
                    .transition(AnyTransition.scale
                        .combined(with: .opacity))
                    .animation(.interpolatingSpring(stiffness: 80, damping: 10))
            }
        }
    }
}

#if DEBUG
struct ListImage_Previews: PreviewProvider {
    static var previews: some View {
        ListImage(movieId: "0").environmentObject(sampleStore)
    }
}
#endif
