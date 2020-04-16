package handlers

import (
  "fmt"
  "time"
  "net/http"
  "io/ioutil"
  "encoding/xml"

  "github.com/gorilla/mux"

  "app/server/errors"
  "app/server/session"
)

type VimeoThumbnailPayload struct {
  Video struct {
    ThumbnailLarge string `xml:"thumbnail_large"`
  } `xml:"video"`
}

func VimeoThumbnail (session *session.Session, writer http.ResponseWriter, request *http.Request) error {
  vars := mux.Vars(request)

  url := fmt.Sprintf("https://vimeo.com/api/v2/video/%s.xml", vars["course_id"])
  apiRequest, err := http.NewRequest("GET", url, nil)
  if err != nil {
    return err
  }

  client := &http.Client{Timeout: time.Second * 5}
  apiResponse, err := client.Do(apiRequest)
  if err != nil {
    return err
  }

  if apiResponse.StatusCode != 200 {
    if apiResponse.StatusCode == 404 {
      return errors.NotFound(nil, "Course Not Found")
    } else {
      return errors.New(apiResponse.StatusCode, "", nil)
    }
  }

  body, err := ioutil.ReadAll(apiResponse.Body)
  if err != nil {
    return err
  }

  payload := VimeoThumbnailPayload{}
  xml.Unmarshal(body, &payload)
  http.Redirect(writer, request, payload.Video.ThumbnailLarge, 307)

  return nil
}
