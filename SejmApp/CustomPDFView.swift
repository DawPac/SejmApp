//
//  CustomPDFView.swift
//  SimFlightHelper
//
//  Created by Dawid Paćkowski on 14/01/2024.
//

import SwiftUI
import PDFKit

struct CustomPDFView: View {
    
    @State var PDFUrl:String
    @State var PDFData:Data = Data()
    
    func loadPDF() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: PDFUrl)!)
            PDFData = data
        } catch {
            print("invalid data")
        }
    }
    
    var body: some View {
        PDFKitView(documentData: PDFData)
        .task {
            await loadPDF()
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    var documentData: Data?

    func makeUIView(context: Context) -> PDFView {
        let pdfView: PDFView = PDFView()
        // check if url exists then set a new document
        if let documentData {
            pdfView.document = PDFDocument(data: documentData)
        }
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // take the updated document url and apply
        // check if url exists then set a new document
        if let documentData {
            uiView.document = PDFDocument(data: documentData)
        } else {
            uiView.document = nil // clear the document in case if url is nil
        }
    }
}
/*
#Preview {
    PDFView()
}
*/
