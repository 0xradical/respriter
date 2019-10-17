package handlers

import (
  "os"

  "fmt"
  "io/ioutil"
  "time"
  "sort"
  "net/http"
  "encoding/json"

  "github.com/gorilla/mux"

  "app/server/errors"
  "app/server/session"
)

type UdemySyllabusResult struct {
  Results []UdemySyllabusEntry `json:"results"`
}

type UdemySyllabusEntry struct {
  Id   int  `json:"id"`
  Free bool `json:"is_free"`
  Asset *struct {
    DownloadUrls struct {
      Videos JsonVideoList `json:"Video"`
    } `json:"download_urls"`
  } `json:"asset"`
}

func UdemyLecture (session *session.Session, writer http.ResponseWriter, request *http.Request) error {
  vars := mux.Vars(request)

  fmt.Fprintf(os.Stderr, "Vars: %v\n", vars)

  syllabusEntry, err := fetchUdemySyllabusEntry(session, vars["course_id"])
  if err != nil {
    return err
  }

  sort.Sort(syllabusEntry.Asset.DownloadUrls.Videos)

  videos := syllabusEntry.Asset.DownloadUrls.Videos
  switch vars["resolution"] {
  case "high_resolution":
    http.Redirect(writer, request, videos[0].File, 307)
  case "low_resolution":
    http.Redirect(writer, request, videos[len(videos)-1].File, 307)
  default:
    http.Redirect(writer, request, videos[len(videos)/2].File, 307)
  }

  return nil
}

func fetchUdemySyllabusEntry (session *session.Session, courseId string) (*UdemySyllabusEntry, error) {
  username := session.Config.UdemyApiUser
  password := session.Config.UdemyApiPassword

  client := &http.Client{
    Timeout: time.Second * 5,
  }

  url := fmt.Sprintf("https://www.udemy.com/api-2.0/courses/%s/public-curriculum-items/?page_size=10&fields[lecture]=@min,is_free,asset&fields[asset]=download_urls", courseId)
  apiRequest, err := http.NewRequest("GET", url, nil)
  if err != nil {
    return nil, err
  }

  apiRequest.SetBasicAuth(username, password)
  apiResponse, err := client.Do(apiRequest)
  if err != nil {
    return nil, err
  }

  if apiResponse.StatusCode != 200 {
    if apiResponse.StatusCode == 404 {
      return nil, errors.NotFound(nil, "Course Not Found")
    } else {
      return nil, errors.New(apiResponse.StatusCode, "", nil)
    }
  }

  body, err := ioutil.ReadAll(apiResponse.Body)
  if err != nil {
    return nil, err
  }

  syllabusResults := UdemySyllabusResult{}
  err = json.Unmarshal([]byte(body), &syllabusResults)
  if err != nil {
    return nil, err
  }

  entry, err := findFirstFreeVideo(syllabusResults.Results)
  if err != nil {
    return nil, err
  }

  return entry, nil
}

func findFirstFreeVideo(syllabusEntries []UdemySyllabusEntry) (*UdemySyllabusEntry, error) {
  for _, entry := range syllabusEntries {
    if entry.Free && entry.Asset != nil {
      return &entry, nil
    }
  }

  return nil, errors.NotFound(nil, "Missing First Lecture Video")
}
