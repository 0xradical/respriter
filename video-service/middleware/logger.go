package middleware

import (
  "net/http"

  "app/server/session"
)

func Logger(handlerFunc http.HandlerFunc) http.HandlerFunc {
  return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
    session := session.FromRequest(request)

    country := request.Header.Get("Cf-Ipcountry")
    if country == "" {
      country = "local"
    }

    ip := request.Header.Get("X-Forwarded-For")
    if ip == "" {
      ip = request.RemoteAddr
    }

    session.Logger().Printf(
      "[%s] (%s %s) START %s %s\n",
      session.Id,
      country,
      ip,
      request.Method,
      request.URL.RequestURI(),
    )

    handlerFunc(writer, request)

    session.Logger().Printf(
      "[%s] (%s %s) END %s %s\n",
      session.Id,
      country,
      ip,
      request.Method,
      request.URL.RequestURI(),
    )
  })
}
