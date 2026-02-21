import SwiftUI
import Combine

// Lab Assignment 1
// Student: Adel Alhajhussein
// Student ID : 101532466

struct ContentView: View {
    private let maxNumber = 100

    @State private var currentNumber = Int.random(in: 1...maxNumber)
    @State private var feedbackSymbol: String? = nil
    @State private var feedbackColor: Color = .green

    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0

    @State private var showSummaryAlert = false
    @State private var summaryMessage = ""

    @State private var timeRemaining = 10
    @State private var timerRunning = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var gameOver: Bool {
        attemptCount >= 10
    }

    var body: some View {
        ZStack {
            Color(.systemTeal).opacity(0.20)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Text("Time: \(timeRemaining)s")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)

                Text("\(currentNumber)")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.blue)

                VStack(spacing: 18) {
                    Button("Prime") {
                        checkAnswer(userSaysPrime: true)
                    }
                    .disabled(gameOver)
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.borderedProminent)

                    Button("Not Prime") {
                        checkAnswer(userSaysPrime: false)
                    }
                    .disabled(gameOver)
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.bordered)
                }

                HStack(spacing: 20) {
                    Text("Correct: \(correctCount)")
                    Text("Wrong: \(wrongCount)")
                    Text("Attempts: \(attemptCount)")
                    Button("Restart") {
                        resetGame()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .buttonStyle(.bordered)
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
            .onReceive(timer) { _ in
                if timerRunning {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        wrongCount += 1
                        attemptCount += 1
                        feedbackSymbol = "xmark"
                        feedbackColor = .red
                        timeRemaining = 10
                        currentNumber = Int.random(in: 1...100)
                        checkForSummary()
                    }
                }
            }
        }
    }

    private func checkAnswer(userSaysPrime: Bool) {
        if attemptCount >= 10 { return }
        timerRunning = true
        timeRemaining = 10

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

        feedbackSymbol = nil
        currentNumber = Int.random(in: 1...100)
        checkForSummary()
    }

    private func checkForSummary() {
        if attemptCount == 10 {
            summaryMessage = "Correct: \(correctCount)\nWrong: \(wrongCount)"
            showSummaryAlert = true
            timerRunning = false
        }
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
        timeRemaining = 10
        timerRunning = false
    }
}

#Preview {
    ContentView()
}
