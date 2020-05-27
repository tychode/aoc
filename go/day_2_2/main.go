package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {

	var lines = getLines("test.txt")

	memoSimilar := ""
	memoCount := 100

	for x, word := range lines {
		for y, diff := range lines {
			if x != y {
				similar, count := diffWords(word, diff)
				if count < memoCount {
					memoCount = count
					memoSimilar = similar
				}
			}
		}
	}
	fmt.Println(memoCount, memoSimilar)
}

func diffWords(word string, diff string) (string, int) {

	var similar []byte
	var disimilar []byte
	for i := range word {
		if word[i] == diff[i] {
			similar = append(similar, word[i])
		} else {
			disimilar = append(disimilar, word[i])
		}
	}

	similarToString := string(similar[:len(similar)])
	return similarToString, len(disimilar)
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
