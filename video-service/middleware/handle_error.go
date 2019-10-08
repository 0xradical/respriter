package middleware

import (
  "net/http"

  "app/server/errors"
  "app/server/session"
)

type HandlerFuncWithError func (http.ResponseWriter, *http.Request) error

func HandleError (handleFunc HandlerFuncWithError) http.HandlerFunc {
  return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
    session := session.FromRequest(request)

    err := handleFunc(writer, request)
    if err != nil {
      errors.Handle(err).Log(session).Respond(writer)
    }
  })
}
