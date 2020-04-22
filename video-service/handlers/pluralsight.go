package handlers

import (
  "os"

  "fmt"
  "time"
  "strings"
  "net/http"
  "io/ioutil"
  "encoding/json"

  "github.com/gorilla/mux"

  "app/server/errors"
  "app/server/session"
)

type PluralsightURLSEntry struct {
  Urls []struct {
    Url string `json:"url"`
  } `json:"urls"`
}

func Pluralsight (session *session.Session, writer http.ResponseWriter, request *http.Request) error {
  vars := mux.Vars(request)

  fmt.Fprintf(os.Stderr, "Vars: %v\n", vars)
  urls, err := fetchPluralsightCourse(session, vars["clip_id"])
  if err != nil {
    return err
  }

  http.Redirect(writer, request, urls.Urls[0].Url, 307)

  return nil
}

func fetchPluralsightCourse (session *session.Session, clipId string) (*PluralsightURLSEntry, error) {
  client := &http.Client{
    Timeout: time.Second * 5,
  }

  payload := fmt.Sprintf("{\"clipId\":\"%s\",\"mediaType\":\"mp4\",\"quality\":\"1280x720\",\"online\":true,\"boundedContext\":\"course\",\"versionId\":\"\"}", clipId)
  apiRequest, err := http.NewRequest("POST", "https://app.pluralsight.com/video/clips/v3/viewclip", strings.NewReader(payload))
  if err != nil {
    return nil, err
  }

  apiRequest.Header.Add("Origin", "https://app.pluralsight.com")
  apiRequest.Header.Add("Content-Type", "application/json")

  apiResponse, err := client.Do(apiRequest)
  if err != nil {
    return nil, err
  }

  if apiResponse.StatusCode != 200 {
    if apiResponse.StatusCode == 404 {
      return nil, errors.NotFound(nil, "Video Not Found")
    } else {
      return nil, errors.New(apiResponse.StatusCode, "", nil)
    }
  }

  body, err := ioutil.ReadAll(apiResponse.Body)
  if err != nil {
    return nil, err
  }

  urls := PluralsightURLSEntry{}
  err = json.Unmarshal([]byte(body), &urls)
  if err != nil {
    return nil, err
  }

  return &urls, nil
}
