package main

import (
	"fmt"
	"os"
	"os/exec"
)

func verifyCommit(repoPath, commit, branch string) error {
	args := []string{"--config-file", "gitverify.json"}

	fmt.Println("branch = " + branch)
	args = append(args, "--repository-uri=git+"+os.Getenv("CI_REPO_CLONE_URL"))
	args = append(args, "--commit", commit)
	args = append(args, "--branch", branch)

	cmd := exec.Command("gitverify", args...)
	cmd.Dir = repoPath
	fmt.Println(cmd)

	output, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("gitverify %v failed: %s", err, string(output))
	}

	fmt.Printf("gitverify succeeded: %s\n", string(output))

	return nil
}
