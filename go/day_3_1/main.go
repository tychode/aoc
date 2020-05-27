package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

type coordintes struct {
	x, y int
}

func main() {

	ids := map[coordintes][]int{}
	lines := getLines("test.txt")

	for _, square := range lines {
		id, corX, corY, width, height := converToCoordinate(square)

		for x := corX; x < corX+width; x++ {
			for y := corY; y < corY+height; y++ {
				ids[coordintes{x, y}] = append(ids[coordintes{x, y}], id)
			}
		}
	}
	overlaped := 0
	for _, element := range ids {
		if len(element) > 1 {
			overlaped++
		}
	}
	fmt.Println(overlaped)
}

func converToCoordinate(s string) (id, x, y, w, h int) {
	_, err := fmt.Sscanf(s, "#%d @ %d,%d: %dx%d",
		&id, &x, &y, &w, &h)
	if err != nil {
		log.Fatal(err)
	}

	return
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
