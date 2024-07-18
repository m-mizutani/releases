package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strconv"
	"time"

	"cloud.google.com/go/storage"
	"github.com/go-chi/chi/v5"
	"github.com/m-mizutani/goerr"
	"github.com/urfave/cli/v2"
)

func cmdServe() *cli.Command {
	var logs []*logRecord
	var (
		addr     string
		csBucket string
		csObject string
	)
	return &cli.Command{
		Name:    "serve",
		Usage:   "Start the server",
		Aliases: []string{"s"},
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:        "addr",
				Usage:       "Address to listen",
				EnvVars:     []string{"ADDR"},
				Value:       "127.0.0.1:8080",
				Destination: &addr,
			},

			&cli.StringFlag{
				Name:        "cloud-storage-bucket",
				Usage:       "Cloud Storage bucket name",
				EnvVars:     []string{"CLOUD_STORAGE_BUCKET"},
				Destination: &csBucket,
				Required:    true,
			},
			&cli.StringFlag{
				Name:        "cloud-storage-object",
				Usage:       "Cloud Storage object name",
				EnvVars:     []string{"CLOUD_STORAGE_OBJECT"},
				Destination: &csObject,
				Required:    true,
			},
		},

		Before: func(c *cli.Context) error {
			resp, err := downloadLogs(csBucket, csObject)
			if err != nil {
				return err
			}
			logs = resp
			return nil
		},

		Action: func(c *cli.Context) error {
			route := chi.NewRouter()
			route.Use(logging)
			route.Route("/api", func(r chi.Router) {
				r.Get("/logs", func(w http.ResponseWriter, r *http.Request) {
					q, err := parseLogQuery(r.URL.Query())
					if err != nil {
						http.Error(w, "fail to parse query: "+err.Error(), http.StatusBadRequest)
						return
					}

					result, meta := searchLogs(logs, q)

					w.Header().Add("Content-Type", "application/json")
					w.WriteHeader(http.StatusOK)
					resp := apiResponse{Logs: result, Metadata: meta}
					if err := json.NewEncoder(w).Encode(resp); err != nil {
						http.Error(w, "fail to encode response: "+err.Error(), http.StatusInternalServerError)
						return
					}
				})
			})

			http.ListenAndServe(addr, route)
			return nil
		},
	}
}

type statusWriter struct {
	http.ResponseWriter
	status int
}

func (w *statusWriter) WriteHeader(status int) {
	w.status = status
	w.ResponseWriter.WriteHeader(status)
}

func logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		sw := statusWriter{ResponseWriter: w}
		next.ServeHTTP(&sw, r)
		logger.Info("Request",
			"method", r.Method,
			"path", r.URL.Path,
			"query", r.URL.Query(),
			"status", sw.status,
			"remote", r.RemoteAddr,
			"user-agent", r.UserAgent(),
		)
	})
}

func parseLogQuery(v url.Values) (*logQuery, error) {
	var q logQuery

	timeFmt := "2006-01-02T15:04:05"
	now := time.Now()
	if v.Get("begin") != "" {
		t, err := time.Parse(timeFmt, v.Get("begin"))
		if err != nil {
			return nil, goerr.Wrap(err, "failed to parse begin time")
		}
		q.begin = t
	} else {
		q.begin = now.Add(-5 * time.Minute)
	}

	if v.Get("end") != "" {
		t, err := time.Parse(timeFmt, v.Get("end"))
		if err != nil {
			return nil, goerr.Wrap(err, "failed to parse end time")
		}
		q.end = t
	} else {
		q.end = now
	}

	if q.begin.After(q.end) {
		return nil, goerr.New("begin time should be before end time")
	}

	if v.Get("offset") != "" {
		n, err := strconv.Atoi(v.Get("offset"))
		if err != nil {
			return nil, goerr.Wrap(err, "failed to parse offset")
		}
		q.offset = n
	}

	if v.Get("limit") != "" {
		n, err := strconv.Atoi(v.Get("limit"))
		if err != nil {
			return nil, goerr.Wrap(err, "failed to parse limit")
		}
		q.limit = n
	} else {
		q.limit = 100
	}

	if q.limit > 1000 {
		return nil, goerr.New("limit should be less than 1000")
	}

	return &q, nil
}

type logQuery struct {
	begin  time.Time
	end    time.Time
	offset int
	limit  int
}

func searchLogs(logs []*logRecord, q *logQuery) ([]*logRecord, *logMetadata) {
	var results []*logRecord

	for _, log := range logs {
		if log.Timestamp.Before(q.begin) || log.Timestamp.After(q.end) {
			continue
		}

		results = append(results, log)
	}

	s := min(q.offset, len(results))
	e := min(q.offset+q.limit, len(results))

	return results[s:e], &logMetadata{
		Total:  len(results),
		Offset: q.offset,
		Limit:  q.limit,
		Begin:  q.begin,
		End:    q.end,
	}
}

func downloadLogs(bucket, objectName string) ([]*logRecord, error) {
	ctx := context.Background()
	client, err := storage.NewClient(ctx)
	if err != nil {
		panic(fmt.Errorf("failed to create storage client: %w", err))
	}

	rc, err := client.Bucket(bucket).Object(objectName).NewReader(ctx)
	if err != nil {
		panic(fmt.Errorf("failed to create object reader: %w", err))
	}
	defer rc.Close()

	logs, err := loadLogs(rc)
	if err != nil {
		return nil, goerr.Wrap(err, "failed to load logs")
	}

	logger.Info("Downloaded logs from Cloud Storage", "bucket", bucket, "object", objectName, "count", len(logs))

	now := time.Now()
	for _, log := range logs {
		ts := time.Date(
			now.Year(), now.Month(), now.Day(),
			log.Timestamp.Hour(), log.Timestamp.Minute(), log.Timestamp.Second(), 0, time.Local,
		)
		log.Timestamp = ts
	}
	logger.Info("Converted timestamp to today", "count", len(logs), "example", logs[0].Timestamp)

	return logs, nil
}
