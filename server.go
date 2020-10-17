package main

import(
        "fmt"
        "net"
        "os"
)

func handleConnection(c net.Conn) {
        fmt.Printf("Serving %s\n", c.RemoteAddr().String())
        buf := make([]byte, 1512)
        for {
                nr, err := c.Read(buf)
                if err != nil {
                        return
                }
     //           defer c.Close()
                data := buf[0:nr]
                fmt.Printf("Received: %v\n", string(data))
        }
}

func main() {
        arguments := os.Args
        if len(arguments) == 1 {
                fmt.Println("Please provide a port number!")
                return
        }

        PORT := ":" + arguments[1]
        l, err := net.Listen("tcp4", PORT)
        if err != nil {
                fmt.Println(err)
                return
        }
        defer l.Close()
        // rand.Seed(time.Now().Unix())

        for {
                c, err := l.Accept()
                if err != nil {
                        fmt.Println(err)
                        return
                }
                go handleConnection(c)
        }
}
