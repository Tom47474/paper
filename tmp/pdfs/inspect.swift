import Foundation
import PDFKit
import AppKit
let url=URL(fileURLWithPath:CommandLine.arguments[1])
let doc=PDFDocument(url:url)!
print("PAGES \(doc.pageCount)")
var full=""
for i in 0..<doc.pageCount {
 let p=doc.page(at:i)!
 full += "\n--- PAGE \(i+1) ---\n"+(p.string ?? "")
 let img=p.thumbnail(of:NSSize(width:1000,height:1400),for:.mediaBox)
 if let t=img.tiffRepresentation,let b=NSBitmapImageRep(data:t),let data=b.representation(using:.png,properties:[:]) {try! data.write(to:URL(fileURLWithPath:"tmp/pdfs/page-\(i+1).png"))}
}
try! full.write(toFile:"tmp/pdfs/paper.txt",atomically:true,encoding:.utf8)
