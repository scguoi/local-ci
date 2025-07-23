package main

import (
	"fmt"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		_, _ = fmt.Fprint(w, "Hello World")
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
		_, _ = fmt.Fprint(w, "Method not allowed")
	}
}

func main() {
	http.HandleFunc("/", helloHandler)

	fmt.Println("Server starting on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
