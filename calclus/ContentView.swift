import SwiftUI

// MARK: - Model
struct CalculatorModel {
    var displayValue: String = "0"
    var firstOperand: Double? = nil
    var pendingOperation: String? = nil
    var isEnteringNumber: Bool = false
    var historyString: String = ""
}

// MARK: - Calculator Themes
enum CalculatorTheme: String, CaseIterable, Identifiable {
    case forest = "Forest"
    case ocean = "Ocean"
    case sunset = "Sunset"
    case lavender = "Lavender"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .forest: return "leaf.fill"
        case .ocean: return "drop.fill"
        case .sunset: return "sunset.fill"
        case .lavender: return "sparkles"
        }
    }

    func background(isDark: Bool) -> Color {
        switch self {
        case .forest:
            return isDark ? Color(red: 0.08, green: 0.08, blue: 0.09) : Color(red: 0.13, green: 0.17, blue: 0.14)
        case .ocean:
            return isDark ? Color(red: 0.04, green: 0.09, blue: 0.14) : Color(red: 0.10, green: 0.22, blue: 0.29)
        case .sunset:
            return isDark ? Color(red: 0.14, green: 0.07, blue: 0.07) : Color(red: 0.34, green: 0.16, blue: 0.12)
        case .lavender:
            return isDark ? Color(red: 0.10, green: 0.08, blue: 0.15) : Color(red: 0.25, green: 0.19, blue: 0.34)
        }
    }

    func button(isDark: Bool) -> Color {
        switch self {
        case .forest: return isDark ? Color(red: 0.18, green: 0.18, blue: 0.20) : Color(red: 0.18, green: 0.24, blue: 0.20)
        case .ocean: return isDark ? Color(red: 0.10, green: 0.18, blue: 0.25) : Color(red: 0.15, green: 0.32, blue: 0.40)
        case .sunset: return isDark ? Color(red: 0.25, green: 0.13, blue: 0.13) : Color(red: 0.47, green: 0.25, blue: 0.19)
        case .lavender: return isDark ? Color(red: 0.20, green: 0.15, blue: 0.27) : Color(red: 0.36, green: 0.28, blue: 0.48)
        }
    }

    func operationButton(isDark: Bool) -> Color {
        switch self {
        case .forest: return isDark ? Color(red: 0.35, green: 0.35, blue: 0.38) : Color(red: 0.29, green: 0.42, blue: 0.36)
        case .ocean: return isDark ? Color(red: 0.15, green: 0.42, blue: 0.55) : Color(red: 0.20, green: 0.52, blue: 0.62)
        case .sunset: return isDark ? Color(red: 0.65, green: 0.27, blue: 0.18) : Color(red: 0.80, green: 0.36, blue: 0.20)
        case .lavender: return isDark ? Color(red: 0.48, green: 0.28, blue: 0.65) : Color(red: 0.55, green: 0.35, blue: 0.70)
        }
    }
}


// MARK: - View (SwiftUI User Interface)
struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var isDarkMode: Bool = false
    @State private var selectedTheme: CalculatorTheme = .forest
    
    // Theme Colors based on Mode
    var backgroundColor: Color { selectedTheme.background(isDark: isDarkMode) }
    var buttonColor: Color { selectedTheme.button(isDark: isDarkMode) }
    var operationButtonColor: Color { selectedTheme.operationButton(isDark: isDarkMode) }
    var secondaryTextColor: Color { isDarkMode ? .white.opacity(0.65) : .white.opacity(0.75) }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Top Bar with Theme Toggle Button
                HStack {
                    Menu {
                        ForEach(CalculatorTheme.allCases) { theme in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTheme = theme
                                }
                            } label: {
                                Label(theme.rawValue, systemImage: theme.icon)
                            }
                        }
                    } label: {
                        Label(selectedTheme.rawValue, systemImage: selectedTheme.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(buttonColor)
                            .clipShape(Capsule())
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isDarkMode ? .yellow : .white)
                            .padding(10)
                            .background(buttonColor)
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
                        .foregroundColor(secondaryTextColor)
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
                        .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: secondaryTextColor))
                    Button("+/-") { viewModel.receiveInput("+/-") }
                        .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: secondaryTextColor))
                    Button("%") { viewModel.receiveInput("%") }
                        .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: secondaryTextColor))
                    Button("÷") { viewModel.receiveInput("/") }
                        .buttonStyle(CalcButtonStyle(bgColor: operationButtonColor, fgColor: .white))
                    
                    ForEach(["7", "8", "9"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: .white))
                    }
                    Button("×") { viewModel.receiveInput("*") }
                        .buttonStyle(CalcButtonStyle(bgColor: operationButtonColor, fgColor: .white))
                    
                    ForEach(["4", "5", "6"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: .white))
                    }
                    Button("-") { viewModel.receiveInput("-") }
                        .buttonStyle(CalcButtonStyle(bgColor: operationButtonColor, fgColor: .white))
                    
                    ForEach(["1", "2", "3"], id: \.self) { digit in
                        Button(digit) { viewModel.receiveInput(digit) }
                            .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: .white))
                    }
                    Button("+") { viewModel.receiveInput("+") }
                        .buttonStyle(CalcButtonStyle(bgColor: operationButtonColor, fgColor: .white))
                    
                    Button("0") { viewModel.receiveInput("0") }
                        .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: .white))
                    Button(".") { viewModel.receiveInput(".") }
                        .buttonStyle(CalcButtonStyle(bgColor: buttonColor, fgColor: .white))
                    Button("=") { viewModel.receiveInput("=") }
                        .buttonStyle(CalcWideButtonStyle(bgColor: operationButtonColor, fgColor: .white))
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
