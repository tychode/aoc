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
	//fmt.Println(overlapped())
	fmt.Println(notOverlapped())
}
func overlapped() (overlapped int) {
	for _, element := range coordintesIds() {
		if len(element) > 1 {
			overlapped++
		}
	}
	return
}

func coordintesIds() (ids map[coordintes][]int) {
	ids = make(map[coordintes][]int)
	lines := getLines("test.txt")
	for _, square := range lines {
		id, corX, corY, width, height := converToCoordinate(square)

		for x := corX; x < corX+width; x++ {
			for y := corY; y < corY+height; y++ {
				ids[coordintes{x, y}] = append(ids[coordintes{x, y}], id)
			}
		}
	}
	return
}

func notOverlapped() (notOverlapped int) {
	not := map[int]int{}
	coordintesIds := coordintesIds()
	for _, ids := range coordintesIds {
		not[ids[0]] = 1
	}
	for _, ids := range coordintesIds {
		if len(ids) > 1 {
			for _, id := range ids {
				delete(not, id)
			}
		}
	}
	for oneNot := range not {
		notOverlapped = oneNot
	}

	return
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
