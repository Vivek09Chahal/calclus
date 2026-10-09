import SwiftUI

// MARK: - Model
struct CalculatorModel {
    var displayValue: String = "0"
    var firstOperand: Double? = nil
    var pendingOperation: String? = nil
    var isEnteringNumber: Bool = false
    var historyString: String = ""
}


// MARK: - View (SwiftUI User Interface)
struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var isDarkMode: Bool = false
    
    // Theme Colors based on Mode
    var forestBg: Color {
        isDarkMode ? Color(red: 0.08, green: 0.08, blue: 0.09) : Color(red: 0.13, green: 0.17, blue: 0.14)
    }
    var sageButton: Color {
        isDarkMode ? Color(red: 0.18, green: 0.18, blue: 0.20) : Color(red: 0.18, green: 0.24, blue: 0.20)
    }
    var sageOpButton: Color {
        isDarkMode ? Color(red: 0.35, green: 0.35, blue: 0.38) : Color(red: 0.29, green: 0.42, blue: 0.36)
    }
    
    var body: some View {
        ZStack {
            forestBg.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Top Bar with Theme Toggle Button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isDarkMode ? .yellow : Color(red: 0.76, green: 0.84, blue: 0.77))
                            .padding(10)
                            .background(sageButton)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                Spacer()
                
                // Display Area
                VStack(alignment: .trailing, spacing: 4) {
                    Text(viewModel.historyString)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text(viewModel.displayValue)
                        .font(.system(size: 68, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 24)
                
                // Keypad Grid matching screenshot
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    
                    Button("AC") { viewModel.receiveInput("AC") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: Color(red: 0.76, green: 0.84, blue: 0.77)))
                    Button("+/-") { viewModel.receiveInput("+/-") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: Color(red: 0.76, green: 0.84, blue: 0.77)))
                    Button("%") { viewModel.receiveInput("%") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: Color(red: 0.76, green: 0.84, blue: 0.77)))
                    Button("÷") { viewModel.receiveInput("/") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageOpButton, fgColor: .white))
                    
                    ForEach(["7", "8", "9"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: .white))
                    }
                    Button("×") { viewModel.receiveInput("*") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageOpButton, fgColor: .white))
                    
                    ForEach(["4", "5", "6"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: .white))
                    }
                    Button("-") { viewModel.receiveInput("-") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageOpButton, fgColor: .white))
                    
                    ForEach(["1", "2", "3"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: .white))
                    }
                    Button("+") { viewModel.receiveInput("+") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageOpButton, fgColor: .white))
                    
                    Button("0") { viewModel.receiveInput("0") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: .white))
                    Button(".") { viewModel.receiveInput(".") }
                        .buttonStyle(CalcButtonStyle(bgColor: sageButton, fgColor: .white))
                    Button("=") { viewModel.receiveInput("=") }
                        .buttonStyle(CalcWideButtonStyle(bgColor: sageOpButton, fgColor: .white))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    CalculatorView()
}
