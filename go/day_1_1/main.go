package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("test.txt") // For read access.
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var sum = 0
	for scanner.Scan() {
		var n int
		line := scanner.Text()
		a, _ := fmt.Sscanf(line, "%d", &n)
		fmt.Println(a, n)
		sum = sum + n

	}
	fmt.Println(sum)

}
