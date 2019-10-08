package handlers

import (
  "os"

  "fmt"
  "strconv"
  "io/ioutil"
  "time"
  "sort"
  "net/http"
  "encoding/json"

  "github.com/gorilla/mux"

  "app/server/errors"
  "app/server/session"
)

type JsonVideoList []struct {
  Type  string `json:"type"`
  Label string `json:"label"`
  File  string `json:"file"`
}

type UdemyCourseEntry struct {
  Id int `json:"id"`
  PromoAssets struct {
    DownloadUrls struct {
      Videos JsonVideoList `json:"Video"`
    } `json:"download_urls"`
  } `json:"promo_asset"`
}

func Udemy (session *session.Session, writer http.ResponseWriter, request *http.Request) error {
  vars := mux.Vars(request)

  fmt.Fprintf(os.Stderr, "Vars: %v\n", vars)

  courseEntry, err := fetchUdemyCourse(session, vars["course_id"])
  if err != nil {
    return err
  }

  sort.Sort(courseEntry.PromoAssets.DownloadUrls.Videos)

  videos := courseEntry.PromoAssets.DownloadUrls.Videos
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

func fetchUdemyCourse (session *session.Session, courseId string) (*UdemyCourseEntry, error) {
  username := session.Config.UdemyApiUser
  password := session.Config.UdemyApiPassword

  client := &http.Client{
    Timeout: time.Second * 5,
  }

  url := fmt.Sprintf("https://www.udemy.com/api-2.0/courses/%s/?fields[course]=@min,promo_asset", courseId)
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

  courseEntry := UdemyCourseEntry{}
  err = json.Unmarshal([]byte(body), &courseEntry)
  if err != nil {
    return nil, err
  }

  return &courseEntry, nil
}

func (list JsonVideoList) Len() int {
  return len(list)
}

func (list JsonVideoList) Swap(i, j int) {
  list[i], list[j] = list[j], list[i]
}

func (list JsonVideoList) Less(i, j int) bool {
  posI, _ := strconv.Atoi(list[i].Label)
  posJ, _ := strconv.Atoi(list[j].Label)
  return posI > posJ
}
