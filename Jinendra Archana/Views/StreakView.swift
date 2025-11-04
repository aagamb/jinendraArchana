//
//  StreakView.swift
//  Jinendra Archana
//
//  Created by Aagam Bakliwal on 11/07/25.
//

import SwiftUI

struct StreakView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            Text("Streak")
                .font(.title2).bold()
                .foregroundStyle(.secondary)
            Text("This is a placeholder page.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}


