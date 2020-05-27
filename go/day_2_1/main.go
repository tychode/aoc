package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {

	var lines = getLines("test.txt")

	var two = 0
	var three = 0

	for _, line := range lines {
		countTwo, countThree := countLetters(line)
		two += countTwo
		three += countThree
	}

	fmt.Println(two * three)

}

func countLetters(word string) (int, int) {

	var was map[rune]int
	var two = 0
	var three = 0

	was = make(map[rune]int)

	for _, letter := range word {
		if _, ok := was[letter]; ok != false {
			was[letter]++
			continue
		}
		was[letter] = 1

	}

	for _, value := range was {
		if two == 0 && value == 2 {
			two++
			continue
		}
		if three == 0 && value == 3 {
			three++
			continue
		}

	}

	return two, three
}

func getLines(fileName string) []string {
	file, err := os.Open(fileName)
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}
