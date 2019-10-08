package middleware

import (
  "net/http"
)

func ForceSSL(handlerFunc http.HandlerFunc) http.HandlerFunc {
  return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
    if request.Header.Get("X-Forwarded-Proto") == "https" {
      writer.Header().Set("Strict-Transport-Security", "max-age=31536000")
      handlerFunc(writer, request)
    } else {
      sslUrl := "https://" + request.Host + request.RequestURI
      http.Redirect(writer, request, sslUrl, http.StatusTemporaryRedirect)
      return
    }
  })
}
