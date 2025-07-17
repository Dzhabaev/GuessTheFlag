//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chingiz on 16.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Kazakhstan", "Monaco","Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var questionCount = 0
    @State private var showingFinalScore = false
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var selectedFlag: Int? = nil
    @State private var animationAmount = 0.0
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                selectedFlag = number
                                animationAmount += 360
                            }
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .rotation3DEffect(
                                    .degrees(selectedFlag == number ? animationAmount : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(selectedFlag == nil || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1 : 0.7)
                                .animation(.easeInOut(duration: 0.6), value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                if questionCount == 8 {
                    showingFinalScore = true
                } else {
                    askQuestion()
                }
            }
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Play Again", action: reset)
        } message: {
            Text("You answered 8 questions.\nFinal score: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        questionCount += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let wrongCountry = countries[number]
            scoreTitle = "Wrong!\nThat’s the flag of \(wrongCountry)"
            score = max(score - 1, 0)
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
    }
    
    func reset() {
        score = 0
        questionCount = 0
        selectedFlag = nil
        askQuestion()
    }
}

#Preview {
    ContentView()
}
