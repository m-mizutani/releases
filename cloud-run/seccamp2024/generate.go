package main

import (
	crypto_rand "crypto/rand"
	"encoding/binary"
	"fmt"
	"io"
	math_rand "math/rand"
	"os"
	"sort"
	"time"

	"github.com/google/uuid"
	"github.com/m-mizutani/goerr"
	"github.com/urfave/cli/v2"
)

func cmdGenerate() *cli.Command {
	var (
		output string
		size   int
	)

	return &cli.Command{
		Name:    "generate",
		Aliases: []string{"g"},
		Usage:   "Generate random logs",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:        "output",
				Usage:       "Output file",
				Aliases:     []string{"o"},
				EnvVars:     []string{"OUTPUT"},
				Destination: &output,
				Value:       "-",
			},
			&cli.IntFlag{
				Name:        "size",
				Usage:       "Number of logs",
				Aliases:     []string{"s"},
				EnvVars:     []string{"SIZE"},
				Destination: &size,
				Value:       100,
			},
		},
		Action: func(c *cli.Context) error {
			var w io.Writer
			if output == "-" {
				w = c.App.Writer
			} else {
				f, err := os.Create(output)
				if err != nil {
					return goerr.Wrap(err, "failed to create file")
				}
				defer f.Close()
				w = f
			}

			if err := outputLogs(w, size); err != nil {
				return goerr.Wrap(err, "failed to output logs")
			}

			return nil
		},
	}
}

func concat[A any](arrays ...[]A) []A {
	var a []A
	for _, arr := range arrays {
		a = append(a, arr...)
	}

	return a
}

func outputLogs(w io.Writer, size int) error {
	var seed int64
	if err := binary.Read(crypto_rand.Reader, binary.LittleEndian, &seed); err != nil {
		return goerr.Wrap(err, "failed to read random seed")
	}
	source := math_rand.NewSource(seed)
	rng := math_rand.New(source)

	var logs []*logRecord

	now := time.Now()
	base := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, time.Local)

	multiplex := func(s string, n int) []string {
		var ret []string
		for i := 0; i < n; i++ {
			ret = append(ret, s)
		}
		return ret
	}

	actions := concat(
		multiplex("login", 1),
		multiplex("read", 15),
		multiplex("write", 6),
	)

	for i := 0; i < size; i++ {
		addSec := rng.Intn(86400)
		timestamp := base.Add(time.Duration(addSec) * time.Second)

		actor := dummyActors[rng.Intn(len(dummyActors))]
		target := dummyTargets[rng.Intn(len(dummyTargets))]
		action := actions[rng.Intn(len(actions))]
		ipaddr := fmt.Sprintf("%d.%d.%d.%d", rng.Intn(256), rng.Intn(256), rng.Intn(256), rng.Intn(256))

		if action == "login" {
			target = ""
		}

		logs = append(logs, &logRecord{
			ID:        uuid.NewString(),
			User:      actor,
			Target:    target,
			Action:    action,
			Timestamp: timestamp,
			Success:   rng.Intn(100) < 95,
			Remote:    ipaddr,
		})
	}

	logs = concat(logs,
		genBruteForceFromSameAddrLogs(base, rng, 256),
		genBruteForceFromSameUserLogs(base, rng, 256),
	)

	sort.Slice(logs, func(i, j int) bool {
		return logs[i].Timestamp.Before(logs[j].Timestamp)
	})

	if err := dumpLogs(w, logs); err != nil {
		return err
	}

	return nil
}

func genBruteForceFromSameAddrLogs(base time.Time, rng *math_rand.Rand, size int) []*logRecord {
	var logs []*logRecord
	ipaddr := "203.0.113.1" // 203.0.113.0/24
	for i := 0; i < size; i++ {
		addSec := rng.Intn(86400)
		timestamp := base.Add(time.Duration(addSec) * time.Second)
		actor := dummyActors[rng.Intn(len(dummyActors))]

		logs = append(logs, &logRecord{
			ID:        uuid.NewString(),
			Timestamp: timestamp,
			User:      actor,
			Action:    "login",
			Remote:    ipaddr,
			Success:   false,
		})
	}

	return logs
}

func genBruteForceFromSameUserLogs(base time.Time, rng *math_rand.Rand, size int) []*logRecord {
	var logs []*logRecord

	for i := 0; i < size; i++ {
		addSec := rng.Intn(86400)
		timestamp := base.Add(time.Duration(addSec) * time.Second)
		ipaddr := fmt.Sprintf("%d.%d.%d.%d", rng.Intn(256), rng.Intn(256), rng.Intn(256), rng.Intn(256))

		logs = append(logs, &logRecord{
			ID:        uuid.NewString(),
			Timestamp: timestamp,
			User:      "alice_x",
			Action:    "login",
			Remote:    ipaddr,
			Success:   false,
		})
	}

	return logs
}
