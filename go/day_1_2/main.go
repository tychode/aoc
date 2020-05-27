package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {

	var sum = 0
	var numbers = getNumbersFromFile("test.txt")
	was := map[int]bool{
		0: true,
	}

	for {
		for _, number := range numbers {

			sum = sum + number

			if was[sum] {
				fmt.Println(sum)
				return
			}

			was[sum] = true
		}

	}

}

func getNumbersFromFile(fileName string) []int {
	file, err := os.Open(fileName)
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var numbers []int

	for scanner.Scan() {
		var n int
		line := scanner.Text()
		if _, err := fmt.Sscanf(line, "%d", &n); err != nil {
			log.Fatal(err)
		}

		numbers = append(numbers, n)
	}
	return numbers
}
