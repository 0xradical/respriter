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
    "/skillshare/{account_id:[0-9]+}/{video_id:[0-9]+}",
    middleware.SignedUrl( WithSession(handlers.Skillshare) ),
  )

  router.HandleFunc(
    "/skillshare/{account_id:[0-9]+}/{video_id:[0-9]+}/{resolution:high_resolution|low_resolution}",
    middleware.SignedUrl( WithSession(handlers.Skillshare) ),
  )

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}",
    middleware.SignedUrl( WithSession(handlers.Udemy) ),
  )

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}/{resolution:high_resolution|low_resolution}",
    middleware.SignedUrl( WithSession(handlers.Udemy) ),
  )

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}/first_lecture",
    middleware.SignedUrl( WithSession(handlers.UdemyLecture) ),
  )

  router.HandleFunc(
    "/udemy/{course_id:[0-9]+}/first_lecture/{resolution:high_resolution|low_resolution}",
    middleware.SignedUrl( WithSession(handlers.UdemyLecture) ),
  )

  router.HandleFunc(
    "/vimeo/thumbnail/{course_id:[0-9]+}",
    WithSession(handlers.VimeoThumbnail),
  )

  router.HandleFunc(
    "/pluralsight/{clip_id:[a-z0-9-]+}",
    middleware.SignedUrl( WithSession(handlers.Pluralsight) ),
  )

  router.NewRoute().PathPrefix("/").Handler(http.FileServer(http.Dir("./public/")))
}
