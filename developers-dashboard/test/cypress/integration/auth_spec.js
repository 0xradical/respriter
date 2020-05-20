describe('Require authentication when not logged', () => {
  before(() => cy.task(
    'endpoint:mock',
    {
      'httpRequest': {
        'method': 'GET',
        'path':   '/user_accounts/sign_in',
        'headers': {
          'Host': [ 'app.clspt:1080' ]
        }
      },
      'httpResponse': {
        'statusCode': 200,
        'headers': {
          'Content-Type': [ 'text/html; charset=utf-8' ]
        },
        'body': '<html><body><h1>Was redirected to <a href="http://app.clspt:1080/user_accounts/sign_in">http://app.clspt:1080/user_accounts/sign_in</a></h1></body></html>'
      }
    })
  )

  after(() => cy.task('endpoint:reset'))

  it('should be redirected to web-app to login', () => {
    cy.visit('/')
    cy.url().should('eq', 'http://app.clspt:1080/user_accounts/sign_in')
  })
})

describe('Authenticated user', () => {
  it('should not be redirected to sign in', () => {
    cy.login({ sub: '1234' })
    cy.visit('/')
    cy.url().should('eq', 'http://developer.app.clspt:1080/dashboard/domains')
  })
})
