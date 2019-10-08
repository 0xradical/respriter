package handlers

import (
  "io"
  "time"
  "net/http"
)

func ProxyStream (url string, writer http.ResponseWriter, request *http.Request) error {
  client := &http.Client{
    Timeout: time.Second * 5,
  }

  targetRequest, err := http.NewRequest("GET", url, nil)
  if err != nil {
    return err
  }

  if request.Header.Get("range") != "" {
    targetRequest.Header.Set( "range", request.Header.Get("range") )
  }

  targetResponse, err := client.Do(targetRequest)
  if err != nil {
    return err
  }

  if targetResponse.StatusCode == 200 {
    writer.Header().Set( "date",                        targetResponse.Header.Get("date")                        )
    writer.Header().Set( "content-type",                "binary/octet-stream"                                   )
    writer.Header().Set( "content-length",              targetResponse.Header.Get("content-length")              )
    writer.Header().Set( "etag",                        targetResponse.Header.Get("etag")                        )
    writer.Header().Set( "last-modified",               targetResponse.Header.Get("last-modified")               )
    writer.Header().Set( "access-control-allow-origin", targetResponse.Header.Get("access-control-allow-origin") )
    writer.Header().Set( "age",                         targetResponse.Header.Get("age")                         )
    writer.Header().Set( "accept-ranges",               targetResponse.Header.Get("accept-ranges")               )

    buffer := make([]byte, 1024)
    for {
      n, err := targetResponse.Body.Read(buffer)
      writer.Write(buffer[:n])
      if err == io.EOF {
        break
      }
    }
  }
  return nil
}
