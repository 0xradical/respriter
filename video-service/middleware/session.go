package middleware

import (
  "context"
  "net/http"

  "github.com/google/uuid"

  "app/server/config"
  "app/server/session"
)

func Session(handlerFunc http.HandlerFunc) http.HandlerFunc {
  return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
    config, _ := request.Context().Value("config").(*config.Config)

    id := request.Header.Get("X-Request-Id")

    if id == "" {
      uuid, _ := uuid.NewUUID()
      id = uuid.String()
    }

    session := session.New(id, config)
    request = request.WithContext(context.WithValue(request.Context(), "session", session))

    handlerFunc(writer, request)
  })
}
