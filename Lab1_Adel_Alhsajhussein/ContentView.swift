import SwiftUI

// Lab Assignment 1
// Student: Adel Alhajhussein
// Student ID : 101532466
//Test commit

struct ContentView: View {

    @State private var currentNumber: Int = Int.random(in: 1...100)
    @State private var showCorrectMark: Bool = false
    @State private var showWrongMark: Bool = false
    @State private var currentNumber = Int.random(in: 1...100)
    @State private var feedbackSymbol: String? = nil
    @State private var feedbackColor: Color = .green

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.20).ignoresSafeArea()

            VStack(spacing: 28) {

                Text("\(currentNumber)")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.blue)

                VStack(spacing: 18) {
                    Button("Prime") {
                        // Step 3 will add logic
                    }
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.borderedProminent)

                    Button("Not Prime") {
                        // Step 3 will add logic
                    }
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.bordered)
                }

                Spacer().frame(height: 30)

                if let symbol = feedbackSymbol {
                    Image(systemName: symbol)
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(feedbackColor)
                }

                Spacer()
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
        }
    }

    private func handleAnswer(userSaysPrime: Bool) {
        let actualIsPrime = isPrime(currentNumber)

        if userSaysPrime == actualIsPrime {
            showCorrectMark = true
            showWrongMark = false
        } else {
            showWrongMark = true
            showCorrectMark = false
        }

        // Move to a new number right away for now
        currentNumber = Int.random(in: 1...100)
    }

    private func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        if n == 2 { return true }
        if n % 2 == 0 { return false }

        var i = 3
        while i * i <= n {
            if n % i == 0 { return false }
            i += 2
        }
        return true
    }
}

#Preview {
    ContentView()
}

