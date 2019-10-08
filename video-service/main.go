package main

import (
  "app/server"
  "app/server/config"
)

func main() {
  config := config.FromEnv()
  router := server.NewRouter(config)
  server := server.NewServer(config, router)
  server.Run()
}
