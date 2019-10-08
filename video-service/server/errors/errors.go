package errors

import (
  "net/http"
  "encoding/json"

  "app/server/session"
)

type HTTPError struct {
  Status       int    `json:status`
  Message      string `json:message`
  WrappedError error  `json:"-"`
}

func New(status int, message string, err error) *HTTPError {
  return &HTTPError{status, message, err}
}

func BadRequest(err error, message string) *HTTPError {
  if message == "" {
    message = "Bad Request"
  }
  return New(400, message, err)
}

func Unauthorized(err error, message string) *HTTPError {
  if message == "" {
    message = "Unauthorized, please authenticate"
  }
  return New(401, message, err)
}

func Forbidden(err error, message string) *HTTPError {
  if message == "" {
    message = "Access Denied"
  }
  return New(403, message, err)
}

func NotFound(err error, message string) *HTTPError {
  if message == "" {
    message = "Not Found"
  }
  return New(404, message, err)
}

func Internal(err error, message string) *HTTPError {
  if message == "" {
    message = "Something went wrong"
  }
  return New(500, message, err)
}

func Handle(err error) *HTTPError {
  httpError, ok := err.(*HTTPError)
  if ok {
    return httpError
  } else {
    return Internal(err, "")
  }
}

func (error *HTTPError) Error() string {
  payload, _ := json.Marshal(error)
  return string(payload)
}

func (error *HTTPError) Respond(writer http.ResponseWriter) *HTTPError {
  if error.Status == 401 {
    writer.Header().Set("WWW-Authenticate", `Basic realm="No, no, no! You didn't say the magic word"`)
  }
  http.Error(writer, error.Error(), error.Status)
  return error
}

func (error *HTTPError) Log(session *session.Session) *HTTPError {
  session.Logger().Printf(
    "[%s] [StatusCode: %d] %s\n",
    session.Id,
    error.Status,
    error.Message,
  )

  if error.WrappedError != nil {
    session.Logger().Printf(
    "[%s] [Wrapped Error] %s\n",
      session.Id,
      error.WrappedError.Error(),
    )
  }

  return error
}
