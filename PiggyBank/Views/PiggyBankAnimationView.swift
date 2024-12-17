import SwiftUI
import DotLottie

struct PiggyBankAnimationView: View {
    var body: some View {
         DotLottieAnimation(
            webURL: "https://lottie.host/420055f8-9976-4b11-80a4-bec092e4666f/0D5yTVeq73.lottie",
            config: AnimationConfig(autoplay: true)
         ).view()
     }
}

#Preview {
    PiggyBankAnimationView()
}
