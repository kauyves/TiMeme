import SwiftUI

struct TimerView: View {
    @StateObject private var timerModel = TimerModel()
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    @State private var isPressed = false

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Circle()
                            .trim(from: 0, to: CGFloat(timerModel.timeRemaining) / CGFloat(timerModel.totalTime))
                            .stroke(timerColor(), lineWidth: 10)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.1), value: timerModel.timeRemaining)
                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.6, height: min(geometry.size.width, geometry.size.height) * 0.6)
                        
                        if geometry.size.width > geometry.size.height {
                            // Modo Paisagem: Posiciona os botões na lateral
                            VStack {
                                buttonSection
                            }
                            .frame(maxHeight: .infinity)
                            .padding(.leading, 20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Exibição do tempo
                    Text(timerModel.timeString)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.15))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    // Exibição dos Pickers de Hora, Minuto e Segundo
                    if geometry.size.width > geometry.size.height {
                        HStack {
                            timePickerSection
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 30)
                    } else {
                        VStack {
                            timePickerSection
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if geometry.size.width <= geometry.size.height {
                        // Botões na parte inferior em modo retrato
                        buttonSection
                            .padding(.top, 20)
                    }
                }
                .padding()
            }
        }
    }

    private var timePickerSection: some View {
        HStack {
            Picker("Horas", selection: $selectedHours) {
                ForEach(0..<24) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 80)
            
            Picker("Minutos", selection: $selectedMinutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute)").tag(minute)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 80)
            
            Picker("Segundos", selection: $selectedSeconds) {
                ForEach(0..<60) { second in
                    Text("\(second)").tag(second)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 80)
        }
        .padding()
    }

    private var buttonSection: some View {
        VStack {
            Button(action: {
                let totalTime = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
                timerModel.setTime(time: totalTime)
            }) {
                Text("Definir Tempo")
                    .padding()
                    .background(isPressed ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut, value: isPressed)
            }
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                })
            
            Button(action: {
                timerModel.startTimer()
            }) {
                Text("Iniciar")
                    .padding()
                    .background(isPressed ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut, value: isPressed)
            }
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                })
            .disabled(timerModel.isTimerRunning || timerModel.timeRemaining == 0) // Desabilita se o timer estiver rodando ou o tempo for 0

            Button(action: {
                timerModel.stopTimer()
            }) {
                Text("Parar")
                    .padding()
                    .background(isPressed ? Color.gray : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut, value: isPressed)
            }
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                })
        }
        .frame(maxWidth: .infinity)
    }

    private func timerColor() -> Color {
        if timerModel.timeRemaining <= 10 {
            return Color.red
        } else if timerModel.timeRemaining <= timerModel.totalTime / 2 {
            return Color.orange
        } else {
            return Color.blue
        }
    }
}
