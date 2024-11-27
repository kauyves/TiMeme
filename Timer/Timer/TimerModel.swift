import Foundation

class TimerModel: ObservableObject {
    @Published var timeRemaining: Int = 60
    var totalTime: Int = 60
    private var timer: Timer?  // O timer é privado
    private let soundManager = SoundManager()

    // Adicionamos um getter para verificar se o timer está rodando
    var isTimerRunning: Bool {
        return timer != nil
    }

    var timeString: String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func setTime(time: Int) {
        self.totalTime = time
        self.timeRemaining = time
    }

    func startTimer() {
        // Verifica se o timer está rodando
        if !isTimerRunning {
            // Se o tempo estiver zerado, reiniciamos
            if timeRemaining == 0 {
                timeRemaining = totalTime
            }

            // Inicia o timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                DispatchQueue.main.async {
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        // Quando o tempo se esgota
                        self.timer?.invalidate()  // Para o timer
                        self.timer = nil  // Desassocia o timer
                        let randomSound = self.soundManager.getRandomSoundName()
                        self.soundManager.playSound(named: randomSound)  // Toca o som
                    }
                }
            }
        }
    }

    func stopTimer() {
        // Para o timer se ele estiver rodando
        timer?.invalidate()
        timer = nil
    }
}
