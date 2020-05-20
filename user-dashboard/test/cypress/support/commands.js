// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

import jwt from 'jsonwebtoken'

Cypress.Commands.add('login', (payload = {}) => {
  const token = jwt.sign(payloadWithDefaults(payload), Cypress.env('API_PGRST_JWT_SECRET'), { algorithm: 'HS256' });
  cy.setCookie('_jwt', token, { domain: '.app.clspt', path: '/' })
})

function payloadWithDefaults(payload) {
  const defaultPayload = {
    role: "user",
    scp:  "user_account",
    sub:  Math.floor(Math.random()*10000),
    aud:  null,
    iat:  Math.floor(new Date() / 1000),
    jti:  uuidv4()
  }

  const mergedPayload = { ...defaultPayload, ...payload }

  if ( !mergedPayload.exp ) {
    mergedPayload.exp = mergedPayload.iat + 172800 // 2 days
  }

  return mergedPayload
}

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    let r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8)
    return v.toString(16)
  })
}
