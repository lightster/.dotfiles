package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path"
	"strings"
)

type hookInput struct {
	ToolInput struct {
		Command string `json:"command"`
	} `json:"tool_input"`
}

func checkCommand(command string) (bool, string) {
	// Strip leading sudo
	cmd := command
	if strings.HasPrefix(cmd, "sudo ") {
		cmd = strings.TrimLeft(cmd[4:], " ")
	}

	// Must start with rm
	if !strings.HasPrefix(cmd, "rm ") {
		return false, ""
	}

	tokens := strings.Fields(cmd)[1:] // skip "rm"

	// Check for recursive flag
	hasRecursive := false
	for _, token := range tokens {
		if token == "--recursive" {
			hasRecursive = true
			break
		}
		if strings.HasPrefix(token, "-") && !strings.HasPrefix(token, "--") {
			if strings.ContainsAny(token, "rR") {
				hasRecursive = true
				break
			}
		}
	}

	if !hasRecursive {
		return false, ""
	}

	// Check non-flag tokens for root paths
	for _, token := range tokens {
		if strings.HasPrefix(token, "-") {
			continue
		}

		// Only check absolute paths
		if !strings.HasPrefix(token, "/") {
			continue
		}

		// Strip trailing glob star before cleaning
		cleaned := strings.TrimRight(token, "*")

		// Normalize the path
		cleaned = path.Clean(cleaned)

		if cleaned == "/" {
			return true, token
		}
	}

	return false, ""
}

func main() {
	var input hookInput
	if err := json.NewDecoder(os.Stdin).Decode(&input); err != nil {
		fmt.Fprintf(os.Stderr, "deny-rm-root: failed to parse input: %v\n", err)
		os.Exit(1)
	}

	if blocked, token := checkCommand(input.ToolInput.Command); blocked {
		fmt.Fprintf(os.Stderr, "BLOCKED: refusing to run rm against filesystem root (matched %q)\n", token)
		os.Exit(2)
	}
}
