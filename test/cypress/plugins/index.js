// You can read more here: https://on.cypress.io/plugins-guide

const { mockServerClient } = require('mockserver-client')

const mockServer = () => mockServerClient('mockserver', 1080)

module.exports = (on, config) => {
  on('task', {
    'endpoint:mock': (payload) => {
      return new Promise((resolve, reject) => {
        mockServer()
          .mockAnyResponse(payload)
          .then(resolve, reject)
      })
    }
  })

  on('task', {
    'endpoint:reset': () => {
      return new Promise((resolve, reject) => {
        mockServer()
          .reset()
          .then(resolve, reject)
      })
    }
  })

}
