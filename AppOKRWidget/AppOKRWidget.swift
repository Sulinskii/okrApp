//
//  AppOKRWidget.swift
//  AppOKRWidget
//
//  Created by Artur Sulinski on 19/03/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let viewModel = AppOKRWidgetViewModel()
    
    func placeholder(in context: Context) -> AppOKRWidgetEntry {
        AppOKRWidgetEntry(date: Date(), subtitle: "Your recently selected book")
    }

    func getSnapshot(in context: Context, completion: @escaping (AppOKRWidgetEntry) -> ()) {
        let entry = AppOKRWidgetEntry(date: Date(), subtitle: "Your recently selected book")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = viewModel.getEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct AppOKRWidgetEntry: TimelineEntry {
    let date: Date
    let title: String = "You selected"
    let subtitle: String
}

struct AppOKRWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.subtitle)
                .background(.green)
                .cornerRadius(3)
            Text(entry.date, style: .time)
                .foregroundColor(.blue)
        }
    }
}

@main
struct AppOKRWidget: Widget {
    let kind: String = "AppOKRWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppOKRWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AppOKRWidget_Previews: PreviewProvider {
    static var previews: some View {
        AppOKRWidgetEntryView(entry: AppOKRWidgetEntry(date: Date(), subtitle: "Your recently selected book"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
