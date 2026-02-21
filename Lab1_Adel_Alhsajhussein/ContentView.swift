import SwiftUI
import Combine

// Lab Assignment 1
// Student: Adel Alhajhussein
// Student ID : 101532466

struct ContentView: View {

    private let maxNumber = 100
    private let roundSeconds = 5
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var currentNumber = Int.random(in: 1...100)
    @State private var feedbackSymbol: String? = nil
    @State private var feedbackColor: Color = .green

    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attemptCount = 0

    @State private var showSummaryAlert = false
    @State private var summaryMessage = ""

    @State private var timeRemaining = 5
    @State private var timerRunning = false
    @State private var hasAnsweredThisRound = false

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
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.borderedProminent)
                    .disabled(gameOver)

                    Button("Not Prime") {
                        checkAnswer(userSaysPrime: false)
                    }
                    .font(.system(size: 22, weight: .medium))
                    .buttonStyle(.bordered)
                    .disabled(gameOver)
                }

                HStack(spacing: 20) {
                    Text("Correct: \(correctCount)")
                    Text("Wrong: \(wrongCount)")
                    Text("Attempts: \(attemptCount)")
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)

                Button("Restart") {
                    resetGame()
                }
                .font(.system(size: 18, weight: .semibold))
                .buttonStyle(.bordered)

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
            .onAppear {
                currentNumber = Int.random(in: 1...maxNumber)
                timeRemaining = roundSeconds
                timerRunning = true
                hasAnsweredThisRound = false
            }
            .alert("Results (10 Attempts)", isPresented: $showSummaryAlert) {
                Button("OK") {
                    resetGame()
                }
            } message: {
                Text(summaryMessage)
            }
            .onReceive(timer) { _ in
                if timerRunning && !gameOver && !showSummaryAlert {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        if !hasAnsweredThisRound {
                            wrongCount += 1
                            attemptCount += 1
                            feedbackSymbol = "xmark"
                            feedbackColor = .red
                            checkForSummary()
                        }

                        hasAnsweredThisRound = false
                        timeRemaining = roundSeconds
                        feedbackSymbol = nil
                        currentNumber = Int.random(in: 1...maxNumber)
                    }
                }
            }
        }
    }

    private func checkAnswer(userSaysPrime: Bool) {
        if gameOver { return }

        hasAnsweredThisRound = true
        timerRunning = true
        timeRemaining = roundSeconds

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

        hasAnsweredThisRound = false
        timeRemaining = roundSeconds
        currentNumber = Int.random(in: 1...maxNumber)
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
        showSummaryAlert = false
        summaryMessage = ""
        hasAnsweredThisRound = false
        timeRemaining = roundSeconds
        timerRunning = true
        currentNumber = Int.random(in: 1...maxNumber)
    }
}

#Preview {
    ContentView()
}
