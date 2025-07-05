//
//  ContentView.swift
//  heads and tails
//
//  Created by Денис Васильевич on 04.07.2025.
//

// Код решения задачи из раздела "Словари"
/*
let game = ["орел", "решка"]
var result = ["man": 0, "mac": 0]
for _ in  1...5 {
    let a = game.randomElement()!
    print("орел или решка?")
    let answer = readline()
    if !game.constant(answer!) {print("Не правильно")}
    if answer == a {result["man"]!+=1}
    else {result["mac"]!+=1}
    print(a)
}
if result["man"]! > result["mac"]! {print("Вы победили \(results["man"]!):\(results["mac"]!)")}
else if result["mac"]! > result["man"]! {print("Вы проиграли \(result["mac"]!):\(result["mac"]!)")}
else {print("ничья")}
*/

import SwiftUI

struct ContentView: View {
    // MARK: СВОЙСТВА
    @State var selection = "игра"
    let game = ["орел", "решка"]
    @State var randomResult = ""
    @State var results = ["man": 0, "mac": 0]
    @State var history: [[String:Int]] = []
    @State var button1Text = "Начать новую игру"
    @State var board = "Текущий счет 0:0"
    @State var message = ""
    @State var roundCount = 0
    @State var button1Disabled = false
    @State var buttons2Disabled = true
    @State var button1Color = Color.black
    @State var buttonEagleColor = Color.gray
    @State var buttonTailsColor = Color.gray
    @State private var showResultAlert = false
    
// MARK:   BODY
    var body: some View {
        TabView(selection:$selection,
                content:{ // START: TabView
            ZStack{ // START: ZStack
                
                // фон
                Color.yellow.ignoresSafeArea()
                // передний план
                VStack{ // START: VStack
                    Text(board)
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .font(.largeTitle)
                    Text("Номер броска \(roundCount)").font(.headline)
                    Spacer()
                    Text(message)
                        .font(.largeTitle)
                    Spacer()
                    Button(action: { // START: кнопка начала новой игры и броска монеты
                        randomResult = game.randomElement()!
                        button1Disabled = true
                        button1Color = .yellow
                        button1Text = ""
                        roundCount += 1
                        buttons2Disabled = false
                        buttonEagleColor = Color.blue
                        buttonTailsColor = Color.red
                        message = "орел или решка?"
                    }, label: {
                        Text(button1Text)
                            .frame(width: 300, height: 100)
                            .background(button1Color)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .font(.title)
                    }) // END: кнопка начала новой игры и броска монеты
                    .disabled(button1Disabled)
                    .alert("Результат игры", isPresented: $showResultAlert) {
                        Button("OK") {
                            // Действия после закрытия алерта
                            button1Text = "Начать новую игру"
                            roundCount = 0
                            results = ["man": 0, "mac": 0]
                            board = "Текущий счет \(results["man"]!):\(results["mac"]!)"
                            buttons2Disabled = true
                        }
                    } message: {
                        if results["man"]! > results["mac"]! {
                            Text("Вы победили! \(results["man"]!):\(results["mac"]!)")
                        } else {
                            Text("Вы проиграли! \(results["mac"]!):\(results["man"]!)")
                        }
                    }
                    Spacer()
                    HStack{
                        Button(action: { // START: Кнопка "Орел"
                            displayMassage()
                            score(answer: "орел")
                            buttonsDisable(answer: "орел")
                            startNewGame()
                        }, label: {
                            Text("Орел")
                                .frame(width: 150, height: 50)
                                .background(buttonEagleColor)
                                .cornerRadius(20)
                                .font(.title)
                                .foregroundColor(.black)
                        }) // END: Кнопка "Орел"
                        .disabled(buttons2Disabled)
                        Button(action: { // START: Кнопка "Решка"
                            displayMassage()
                            score(answer: "решка")
                            buttonsDisable(answer: "решка")
                            startNewGame()
                        }, label: {
                            Text("Решка")
                                .frame(width: 150, height: 50)
                                .background(buttonTailsColor)
                                .cornerRadius(20)
                                .font(.title)
                                .foregroundColor(.black)
                        }) // END: Кнопка "Решка"
                        .disabled(buttons2Disabled)
                    }
                    Spacer()
                } // END: VStack
            } // END ZStack
            .tabItem {
                Label("Игра", systemImage: "gamecontroller")
                    .font(.headline)
            }
            .tag("Игра")
            
            ZStack{ // START: ZStack
                
                // фон
                Color.orange.ignoresSafeArea()
                ScrollView (showsIndicators: false){ // START: ScrollView
                    // передний план
                    VStack{ // START: VStack
                        ForEach(history, id: \.self) { i in
                            if i["man"]! > i["mac"]! {
                                Text("Вы победили: \(i["man"]!) : \(i["mac"]!)")
                                    .frame(width: 300, height: 100)
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            } else {
                                Text("Вы проиграли: \(i["mac"]!) : \(i["man"]!)")
                                    .frame(width: 300, height: 100)
                                    .background(.yellow)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                    } // END: VStack
                } // END: ScrollView
            } // END: ZStack
            .tabItem {
                Label("Результаты", systemImage: "list.bullet.clipboard")
                    .font(.headline)
            }
            .tag("Результаты")
        })
    }
    // MARK:  ФУНКЦИИ
    /// эта функция выводит на экран сообщение о том какая сторона выпала у монеты
    func displayMassage() {
        if randomResult == "орел" {
            message = "Выпал орел!"
        }
        if randomResult == "решка" {
            message = "Выпала решка!"
        }
    }
    /// эта функция сравнивает параметр answer, задаваемый в зависимости от нажимаеомй кнопки, с параметром randomResult (результатом броска монеты) и в зависимости от совпадения (угадал пользователь, что выпадет или нет) добавляет в словарь, хранящий текущий счет игры (result), очко пользователю или компьютеру
    /// - Parameter answer: задается в зависимости то нажимаемой кнопки, может быть только "орел" или "решка"
    func score(answer: String){
        if answer == randomResult {results["man"]!+=1}
        else {results["mac"]!+=1}
    }
    
    
    /// функиця кнопок "орер" и "решка"
    /// - Parameter answer: задается в зависимости то нажимаемой кнопки, может быть только "орел" или "решка"
    func buttonsDisable(answer: String){
        buttons2Disabled = true
        if answer == "решка" {
            buttonEagleColor = .gray.opacity(0.1)
            buttonTailsColor = .gray
        }
        else {
            buttonEagleColor = .gray
            buttonTailsColor = .gray.opacity(0.1)
        }
        button1Disabled = false
        button1Color = .black
    }
    
    /// функция для отсчета кол-во бросков с последущим выводом сообщения о результате игры и ее рестарта
    func startNewGame(){
        if roundCount < 5 {
                   button1Text = "Бросить монету"
                   board = "Текущий счет \(results["man"]!):\(results["mac"]!)"
        } else {
            history.append(results)
            showResultAlert = true
        }
    }
}

// MARK: ПРЕДВАРИТЕЛЬНЫЙ ПРОСМОТР
#Preview {
    ContentView()
}
