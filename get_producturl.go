package main

import (
    "encoding/xml"
    "fmt"
    "os"
)

type Product struct {
    ProductUrl string `xml:"ProductUrl"`
}

func main() {
    if len(os.Args) == 1 {
        fmt.Println("Usage:", os.Args[0], "<file>")
        return
    }
    xmlFile, err := os.Open(os.Args[1])
    if err != nil {
        fmt.Println("Error while opening file:", err)
        return
    }
    defer xmlFile.Close()

    decoder := xml.NewDecoder(xmlFile)
    var inElement string
    for {
        t, _ := decoder.Token()
        if t == nil {
            break
        }
        switch se := t.(type) {
        case xml.StartElement:
            inElement = se.Name.Local
            if inElement == "Product" {
                var p Product
                decoder.DecodeElement(&p, &se)
                fmt.Println(p.ProductUrl)
            }
        default:
        }
    }
}
