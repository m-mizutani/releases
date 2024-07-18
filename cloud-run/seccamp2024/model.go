package main

import (
	"encoding/json"
	"io"
	"time"

	"github.com/m-mizutani/goerr"
)

type logRecord struct {
	ID        string    `json:"id"`
	Timestamp time.Time `json:"timestamp"`
	User      string    `json:"user"`
	Action    string    `json:"action"`
	Target    string    `json:"target"`
	Success   bool      `json:"success"`
	Remote    string    `json:"remote"`
}

type logMetadata struct {
	Total  int       `json:"total"`
	Offset int       `json:"offset"`
	Limit  int       `json:"limit"`
	Begin  time.Time `json:"begin"`
	End    time.Time `json:"end"`
}

type apiResponse struct {
	Logs     []*logRecord `json:"logs"`
	Metadata *logMetadata `json:"metadata"`
}

func dumpLogs(w io.Writer, logs []*logRecord) error {
	enc := json.NewEncoder(w)
	for _, log := range logs {
		if err := enc.Encode(log); err != nil {
			return goerr.Wrap(err, "failed to encode log")
		}
	}

	return nil
}

func loadLogs(r io.Reader) ([]*logRecord, error) {
	dec := json.NewDecoder(r)
	var logs []*logRecord
	for {
		var log logRecord
		if err := dec.Decode(&log); err == io.EOF {
			break
		} else if err != nil {
			return nil, goerr.Wrap(err, "failed to decode log")
		}
		logs = append(logs, &log)
	}

	return logs, nil
}
