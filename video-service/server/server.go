package server

import (
  "os"
  "os/signal"
  "context"
  "net/http"

  "app/server/config"
)

type Server struct {
  http.Server

  Config *config.Config
}

func NewServer(config *config.Config, handler http.Handler) *Server {
  return &Server{
    http.Server{
      Addr:              config.Address,
      Handler:           handler,
      ErrorLog:          config.Logger(),
      ReadTimeout:       config.HTTPReadTimeout,
      ReadHeaderTimeout: config.HTTPReadHeaderTimeout,
      WriteTimeout:      config.HTTPWriteTimeout,
      IdleTimeout:       config.HTTPIdleTimeout,
      MaxHeaderBytes:    config.HTTPMaxHeaderBytes,
    },
    config,
  }
}

func (server *Server) Run() {
  done := make(chan bool)
  quit := make(chan os.Signal, 1)
  signal.Notify(quit, os.Interrupt)

  logger := server.ErrorLog

  go func() {
    <-quit
    logger.Println("Video Service is shutting down...")

    ctx, cancel := context.WithTimeout(context.Background(), server.Config.GracefulShutdownTimeout)
    defer cancel()

    server.SetKeepAlivesEnabled(false)
    if err := server.Shutdown(ctx); err != nil {
      logger.Fatalf("Could not gracefully shutdown: %v\n", err)
    }

    close(done)
  }()

  address := server.Config.Address
  logger.Println("Video Service is ready at", address)
  if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
    logger.Fatalf("Could not listen on %s: %v\n", address, err)
  }

  <-done
  logger.Println("Video Service stopped")
}
