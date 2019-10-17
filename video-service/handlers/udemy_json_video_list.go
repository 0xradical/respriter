package handlers

import "strconv"

type JsonVideoList []struct {
  Type  string `json:"type"`
  Label string `json:"label"`
  File  string `json:"file"`
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
