package main

import "testing"

func TestCheckCommand(t *testing.T) {
	tests := []struct {
		name    string
		command string
		blocked bool
	}{
		// Should deny
		{"rm -rf /", "rm -rf /", true},
		{"rm -rf /*", "rm -rf /*", true},
		{"rm -f -r /", "rm -f -r /", true},
		{"rm -rf //", "rm -rf //", true},
		{"rm -rf /./", "rm -rf /./", true},
		{"sudo rm -rf /", "sudo rm -rf /", true},
		{"sudo rm -rf /*", "sudo rm -rf /*", true},
		{"rm --force -r /", "rm --force -r /", true},
		{"rm --recursive /", "rm --recursive /", true},
		{"rm -Rf /", "rm -Rf /", true},
		{"rm -r file -f / other --no-preserve-root some_dir/", "rm -r file -f / other --no-preserve-root some_dir/", true},

		// Should allow
		{"rm -rf /tmp/foo", "rm -rf /tmp/foo", false},
		{"rm -rf ./src", "rm -rf ./src", false},
		{"rm file.txt", "rm file.txt", false},
		{"rm -rf /var/log/app", "rm -rf /var/log/app", false},
		{"ls -la /", "ls -la /", false},
		{"echo rm -rf /", "echo rm -rf /", false},
		{"rm foo / bar (no recursive)", "rm foo / bar", false},
		{"rm foo bar //* baz (no recursive)", "rm foo bar //* baz", false},
		{"rm / (no recursive)", "rm /", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			blocked, _ := checkCommand(tt.command)
			if blocked != tt.blocked {
				t.Errorf("checkCommand(%q) = %v, want %v", tt.command, blocked, tt.blocked)
			}
		})
	}
}
