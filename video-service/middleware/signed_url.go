package middleware

import (
  "fmt"

  "time"
  "regexp"
  "strconv"
  "net/url"
  "net/http"

  "crypto/hmac"
  "crypto/sha1"
  "encoding/hex"

  "app/server/config"
  "app/server/errors"
)

func SignedUrl(handlerFunc http.HandlerFunc) http.HandlerFunc {
  return HandleError(func(writer http.ResponseWriter, request *http.Request) error {
    date, token, err := parseDateAndToken(request)
    if err != nil {
      return err
    }

    if time.Now().After( date.Add(time.Hour) ) {
      return errors.Forbidden(nil, "Token Expired")
    }

    expectedToken := getExpectedToken(request)
    if token != expectedToken {
      return errors.Forbidden(nil, "Signature does not match")
    }

    handlerFunc(writer, request)
    return nil
  })
}

func parseDateAndToken(request *http.Request) (date time.Time, token string, err error) {
  params, err := url.ParseQuery(request.URL.RawQuery)
  if err != nil {
    return
  }

  if len(params["date"]) != 1 {
    err = errors.BadRequest(nil, "Missing Date")
    return
  }

  dateInUnix, err := strconv.Atoi(params["date"][0])
  if err != nil {
    return
  }

  date = time.Unix(int64(dateInUnix), 0)
  if time.Now().After( date.Add(time.Hour) ) {
    err = errors.Forbidden(nil, "Token Expired")
    return
  }

  if len(params["token"]) != 1 {
    err = errors.BadRequest(nil, "Missing Token")
    return
  }

  token = params["token"][0]
  return
}

func getExpectedToken (request *http.Request) string {
  url          := request.URL.RequestURI()
  tokenlessUrl := regexp.MustCompile(`(&|\?)token=[[:xdigit:]]+\z`).ReplaceAllString(url, "")
  stringToSign := fmt.Sprintf("[%s]%s", request.Method, tokenlessUrl)
  config, _    := request.Context().Value("config").(*config.Config)

  return getSignature(config.UrlSignerKey, stringToSign)
}

func getSignature(key, stringToSign string) string {
  digester := hmac.New(sha1.New, []byte(key))
  digester.Write([]byte(stringToSign))
  return hex.EncodeToString(digester.Sum(nil))
}
