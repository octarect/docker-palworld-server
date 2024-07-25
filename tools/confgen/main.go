package main

import (
	"bytes"
	"fmt"
	"os"
	"strings"

	"github.com/octarect/docker-palworld-server/tools/confgen/templates"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:  "confgen [flags] target",
	Args: cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		target := args[0]

		tmpl, err := templates.LoadTemplate(target)
		if err != nil {
			return fmt.Errorf("Failed to load template: %v", err)
		}

		buf := &bytes.Buffer{}
		if err := tmpl.Execute(buf, getEnvVars()); err != nil {
			return fmt.Errorf("Failed to generate config: %v", err)
		}

		fmt.Printf("%s", buf)

		return nil
	},
}

func getEnvVars() map[string]string {
	m := make(map[string]string)
	for _, e := range os.Environ() {
		kv := strings.SplitN(e, "=", 2)
		k, v := kv[0], kv[1]
		m[k] = v
	}
	return m
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
