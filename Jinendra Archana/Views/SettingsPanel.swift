import SwiftUI

struct SettingsPanel: View {
    @Binding var isOpen: Bool
    @Binding var useStreak: Bool

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Settings")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.primary)
                    Spacer(minLength: 0)
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            isOpen = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                }

                Toggle("Use Streak", isOn: $useStreak)
                    .toggleStyle(SwitchToggleStyle())

                Spacer()
            }
            .padding(16)
            .padding(.top, 64) // extra top padding per request
            .frame(width: 280)
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

            Spacer(minLength: 0)
        }
        .ignoresSafeArea()
    }
}


