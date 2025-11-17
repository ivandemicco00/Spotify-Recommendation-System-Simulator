//
//  PlaylistCard.swift
//  SpotifyTest with code
//
//  Created by Ivan De Micco on 16/11/25.
//

import SwiftUI




struct PlaylistCard: View {
    let title: String
    let songCount: Int
    let songs: [Song]
    
    var body: some View {
        HStack(spacing: 15) {
            Image(songs.first?.coverArt ?? "placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(4)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(songCount) brani | Consigliati per te")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
