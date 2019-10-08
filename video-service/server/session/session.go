package session

import (
  "log"
  "net/http"
  "database/sql"

  "app/server/config"
)

type Session struct {
  Id     string
  Config *config.Config
}

func New(id string, config *config.Config) *Session {
  return &Session{
    Id:     id,
    Config: config,
  }
}

func FromRequest(request *http.Request) *Session {
  session, _ := request.Context().Value("session").(*Session)
  return session
}

func (session *Session) Logger() *log.Logger  {
  return session.Config.Logger()
}

func (session *Session) DatabasePool() *sql.DB  {
  return session.Config.DatabasePool()
}
