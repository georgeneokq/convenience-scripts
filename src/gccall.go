package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	files := make([]string, 0)
	err := filepath.Walk(".",
		func(path string, info os.FileInfo, err error) error {
			// Add to slice if ends with .c extension
			if strings.HasSuffix(path, ".c") {
				// Split string using "\"
				files = append(files, path)
			}
			return nil
		})
	if err != nil {
		log.Fatal(err)
	}
	filesString := strings.Join(files, " ")
	// fmt.Printf(filesString)
	outputFileName := "main"
	args := make([]string, 0)
	args = append(args, "-o", outputFileName)
	for _, file := range files {
		args = append(args, file)
	}
	cmd := exec.Command("gcc", args...)
	cmd.Stderr = os.Stderr
	fmt.Printf("gcc -o %s %s", outputFileName, filesString)
	cmd.Output()
}
