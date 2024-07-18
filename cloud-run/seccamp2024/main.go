package main

import (
	"log/slog"
	"os"

	"github.com/urfave/cli/v2"
)

var logger = slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
	Level:     slog.LevelInfo,
	AddSource: true,
}))

func main() {
	app := cli.App{
		Name:  "seccamp2024",
		Usage: "Utility for seccamp2024",

		Commands: []*cli.Command{
			cmdServe(),
			cmdGenerate(),
		},
	}

	if err := app.Run(os.Args); err != nil {
		logger.Error("failed to run app", "error", err)
	}
}
