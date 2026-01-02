internal import SwiftUI
import Charts


struct chart: View {
    @State private var viewModel = StatsVm()
    @State private var selectedOption: ChartOptions = .oneWeek
    @State private var chartData: [StepModel] = []
    
    private var totalSteps: Int {
        chartData.reduce(0) { $0 + $1.count }
    }
    
    private var averageSteps: Int {
        guard !chartData.isEmpty else { return 0 }
        return totalSteps / chartData.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Activity")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            // Stats Cards
            HStack(spacing: 16) {
                StatCard(
                    title: "Total",
                    value: formatNumber(totalSteps),
                    subtitle: selectedOption.timeLabel,
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Average",
                    value: formatNumber(averageSteps),
                    subtitle: "per \(selectedOption == .oneYear || selectedOption == .yearToDate ? "month" : "day")",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            // Chart
            Chart(chartData) { data in
                BarMark(
                    x: .value(data.date.formatted(), data.date, unit: selectedOption.chartUnit),
                    y: .value("Steps", data.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .green.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 300)
            .padding(.horizontal)
            
            // Time Period Selector
            HStack(spacing: 8) {
                ForEach(ChartOptions.allCases, id: \.rawValue) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedOption = option
                            chartData = viewModel.generateData(for: option)
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedOption == option ? .semibold : .regular)
                            .foregroundStyle(selectedOption == option ? .white : .green)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedOption == option ? .green : Color.green.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            chartData = viewModel.generateData(for: selectedOption)
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}



#Preview {
    chart()
}
