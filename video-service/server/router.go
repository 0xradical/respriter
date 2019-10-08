package server

import (
  "context"
  "net/http"
  "container/list"

  "github.com/gorilla/mux"

  "app/server/config"
  "app/server/errors"
  "app/server/session"
)

type Middleware         func (http.HandlerFunc) http.HandlerFunc
type SessionHandlerFunc func (*session.Session, http.ResponseWriter, *http.Request) error

type Router struct {
  Config      *config.Config
  Mux         *mux.Router
  HandlerFunc http.HandlerFunc
  Middlewares *list.List
}

func NewRouter(config *config.Config) *Router {
  muxRouter := mux.NewRouter()

  router := &Router{
    Config:      config,
    Mux:         muxRouter,
    HandlerFunc: http.HandlerFunc(muxRouter.ServeHTTP),
    Middlewares: list.New(),
  }

  router.Routes()
  for element := router.Middlewares.Front(); element != nil; element = element.Next() {
    middleware, _ := element.Value.(Middleware)
    router.HandlerFunc = middleware(router.HandlerFunc)
  }
  return router
}

func WithSession(handleFunc SessionHandlerFunc) http.HandlerFunc {
  return func(writer http.ResponseWriter, request *http.Request) {
    session := session.FromRequest(request)
    err := handleFunc(session, writer, request)
    if err != nil {
      errors.Handle(err).Log(session).Respond(writer)
    }
  }
}

func (router *Router) NewRoute() *mux.Route {
  return router.Mux.NewRoute()
}

func (router *Router) Handle(pattern string, handler http.Handler) *mux.Route {
  return router.Mux.Handle(pattern, handler)
}

func (router *Router) HandleFunc(pattern string, handleFunc http.HandlerFunc) *mux.Route {
  return router.Mux.HandleFunc(pattern, handleFunc)
}

func (router *Router) Use(middleware Middleware) {
  router.Middlewares.PushFront(middleware)
}

func (router *Router) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
  request = request.WithContext(context.WithValue(request.Context(), "config", router.Config))
  router.HandlerFunc.ServeHTTP(writer, request)
}
