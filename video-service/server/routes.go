package server

import (
  "net/http"

  "app/handlers"
  "app/middleware"
)

func (router *Router) Routes() {
  router.Use(middleware.Session)
  router.Use(middleware.Logger)

  if router.Config.ForceHTTPS {
    router.Use(middleware.ForceSSL)
  }

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}",
    middleware.SignedUrl( WithSession(handlers.Udemy) ),
  )

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}/{resolution:high_resolution|low_resolution}",
    middleware.SignedUrl( WithSession(handlers.Udemy) ),
  )

  router.NewRoute().PathPrefix("/").Handler(http.FileServer(http.Dir("./public/")))
}
