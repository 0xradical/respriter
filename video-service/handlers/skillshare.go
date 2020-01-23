package handlers

import (
  "os"

  "fmt"
  "io/ioutil"
  "regexp"
  "time"
  "sort"
  "net/http"
  "encoding/json"

  "github.com/gorilla/mux"

  "app/server/errors"
  "app/server/session"
)

type SkillshareVideoSources []struct {
  Container  *string `json:"container"`
  Codec      *string `json:"codec"`
  Src        *string `json:"src"`
  AvgBitrate *int    `json:"avg_bitrate"`
}

type SkillshareVideoData struct {
  Sources SkillshareVideoSources `json:"sources"`
}

func Skillshare (session *session.Session, writer http.ResponseWriter, request *http.Request) error {
  vars := mux.Vars(request)

  fmt.Fprintf(os.Stderr, "Vars: %v\n", vars)

  videoData, err := fetchSkillshareVideoData(session, vars["account_id"], vars["video_id"])
  if err != nil {
    return err
  }

  sources := make(SkillshareVideoSources, 0)
  for _, s := range videoData.Sources {
    if s.Container != nil && s.Codec != nil && s.Src != nil && s.AvgBitrate != nil && *s.Container == "MP4" && *s.Codec == "H264" {
      matched, err := regexp.MatchString(`\Ahttps`, *(s.Src))
      if matched && err == nil {
        sources = append(sources, s)
      }
    }
  }

  sort.SliceStable(sources, func(i, j int) bool {
    return *(sources[i].AvgBitrate) < *(sources[j].AvgBitrate)
  })

  if len(sources) == 0 {
    return errors.NotFound(nil, "Missing Videos")
  }

  switch vars["resolution"] {
  case "high_resolution":
    http.Redirect(writer, request, *sources[0].Src, 307)
  case "low_resolution":
    http.Redirect(writer, request, *sources[len(sources)-1].Src, 307)
  default:
    http.Redirect(writer, request, *sources[len(sources)/2].Src, 307)
  }

  return nil
}

func fetchSkillshareVideoData (session *session.Session, accountId, videoId string) (*SkillshareVideoData, error) {
  secretKey := session.Config.SkillshareSecretKey

  client := &http.Client{
    Timeout: time.Second * 5,
  }

  url := fmt.Sprintf("https://edge.api.brightcove.com/playback/v1/accounts/%s/videos/%s", accountId, videoId)
  apiRequest, err := http.NewRequest("GET", url, nil)
  if err != nil {
    return nil, err
  }

  acceptHeader := fmt.Sprintf("application/json;pk=%s", secretKey)
  apiRequest.Header.Set("Accept", acceptHeader)

  apiResponse, err := client.Do(apiRequest)
  if err != nil {
    return nil, err
  }

  if apiResponse.StatusCode != 200 {
    if apiResponse.StatusCode == 404 {
      return nil, errors.NotFound(nil, "Missing Videos")
    } else {
      return nil, errors.New(apiResponse.StatusCode, "", nil)
    }
  }

  body, err := ioutil.ReadAll(apiResponse.Body)
  if err != nil {
    return nil, err
  }

  videoData := SkillshareVideoData{}
  err = json.Unmarshal([]byte(body), &videoData)
  if err != nil {
    return nil, err
  }

  fmt.Fprintf(os.Stderr, "Response: %v\n", videoData)

  return &videoData, nil
}
