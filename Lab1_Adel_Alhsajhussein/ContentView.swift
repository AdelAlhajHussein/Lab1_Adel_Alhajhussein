import SwiftUI

// Lab Assignment 1
// Student: Adel Alhajhussein
// Student ID : 101532466

struct ContentView: View {

    @State private var currentNumber = Int.random(in: 1...100)
    @State private var feedbackSymbol: String? = nil
    @State private var feedbackColor: Color = .green
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0
    @State private var showSummaryAlert = false
    @State private var summaryMessage = ""

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.20)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Text("\(currentNumber)")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.blue)

                VStack(spacing: 18) {
                    Button("Prime") {
                        checkAnswer(userSaysPrime: true)
                    }
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.borderedProminent)

                    Button("Not Prime") {
                        checkAnswer(userSaysPrime: false)
                    }
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.bordered)
                }
                HStack(spacing: 20) {
                    Text("Correct: \(correctCount)")
                    Text("Wrong: \(wrongCount)")
                    Text("Attempts: \(attemptCount)")
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)

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
            
            .alert("Results (10 Attempts)", isPresented: $showSummaryAlert) {
                Button("OK") {
                    resetGame()
                }
            } message: {
                Text(summaryMessage)
            }
        }
    }
    private func checkAnswer(userSaysPrime: Bool) {
        attemptCount += 1

        let actualIsPrime = isPrime(currentNumber)

        if userSaysPrime == actualIsPrime {
            correctCount += 1
            feedbackSymbol = "checkmark"
            feedbackColor = .green
        } else {
            wrongCount += 1
            feedbackSymbol = "xmark"
            feedbackColor = .red
        }

        if attemptCount == 10 {
            summaryMessage = "Correct: \(correctCount)\nWrong: \(wrongCount)"
            showSummaryAlert = true
        }

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
    private func resetGame() {
        correctCount = 0
        wrongCount = 0
        attemptCount = 0
        feedbackSymbol = nil
        currentNumber = Int.random(in: 1...100)
    }

}

#Preview {
    ContentView()
}

