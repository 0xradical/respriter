describe('Require authentication when not logged', () => {
  before(() => cy.task(
    'endpoint:mock',
    {
      'httpRequest': {
        'method': 'GET',
        'path':   '/user_accounts/sign_in',
        'queryStringParameters': { 'user_dashboard_redir': [ '/account-settings' ] },
        'headers': {
          'Host': [ 'app.clspt:1080' ]
        }
      },
      'httpResponse': {
        'statusCode': 200,
        'headers': {
          'Location':     [ 'https://www.mock-server.com' ],
          'Content-Type': [ 'text/html; charset=utf-8' ]
        },
        'body': '<html><body><h1>Was redirected to <a href="http://app.clspt:1080/user_accounts/sign_in?user_dashboard_redir=/account-settings">http://app.clspt:1080/user_accounts/sign_in?user_dashboard_redir=/account-settings</a></h1></body></html>'
      }
    })
  )

  after(() => cy.task('endpoint:reset'))

  it('should be redirected to web-app to login', () => {
    cy.visit('/')
    cy.url().should('eq', 'http://app.clspt:1080/user_accounts/sign_in?user_dashboard_redir=/account-settings')
  })
})

describe('Authenticated user', () => {
  before(() => cy.task(
    'endpoint:mock',
    {
      "httpRequest": {
        "method": "GET",
        "path": "/user_accounts",
        "queryStringParameters": {
          "id":     [ "eq.1234" ],
          "select": [ "email,profiles(*)" ]
        },
        "headers": {
          "host": [ "api.clspt:1080" ]
        }
      },
      "httpResponse": {
        "statusCode": 200,
        "headers": {
          "Content-Range": [
            "0-0/*"
          ],
          "Access-Control-Allow-Origin": [
            "http://user.app.clspt:1080"
          ],
          "Access-Control-Allow-Credentials": [
            "true"
          ],
          "Access-Control-Expose-Headers": [
            "Content-Encoding, Content-Location, Content-Range, Content-Type, Date, Location, Server, Transfer-Encoding, Range-Unit"
          ]
        },
        "body": [
          {
            "email": "fulano@classpert.com",
            "profiles": [
              {
                "id":              "12345678-1234-1234-1234-1234567890ab",
                "name":            "Grumpy Cat",
                "username":        "grumpycat",
                "avatar_url":      "//cdn.dicionariopopular.com/imagens/grumpy-cat-cke.jpg",
                "date_of_birth":   null,
                "user_account_id": 1234,
                "interests":       [],
                "preferences":     {}
              }
            ]
          }
        ]
      }
    })
  )

  after(() => cy.task('endpoint:reset'))

  it('should not be redirected to sign in', () => {
    cy.login({ sub: '1234' })
    cy.visit('/')
    cy.url().should('eq', 'http://user.app.clspt:1080/account-settings')
  })
})
