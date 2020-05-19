# s12n (specialization) id = 5cRd_NmpEeWkogoQ284TMQ
# on demand course materials id = k1EoDdm3EeWpMxLJs6PspQ

# Course Pricing Model
# capstone (nada free) / "premiumExperienceVariant":"PremiumGrading"
# https://www.coursera.org/api/courses.v1/k1EoDdm3EeWpMxLJs6PspQ?showHidden=true&fields=id,courseStatus,courseMode,certificates,name,premiumExperienceVariant,s12nIds,plannedLaunchDate
# ondemand (eh free to audit) / "premiumExperienceVariant":"PremiumGrading"
# https://www.coursera.org/api/courses.v1/nO_yqTe0EeWYbg7p2_3OHQ?showHidden=true&fields=id,courseStatus,courseMode,certificates,name,premiumExperienceVariant,s12nIds,plannedLaunchDate
# ondemand (nao eh free to audit) / "premiumExperienceVariant":"PremiumCourse"
# https://www.coursera.org/api/courses.v1/voUQTv9AEeaBXg46-AuF8A?showHidden=true&fields=id,courseStatus,courseMode,certificates,name,premiumExperienceVariant,s12nIds,plannedLaunchDate
# Ex.:
# {
#   "elements":[
#      {
#         "courseType":"v2.ondemand",
#         "s12nIds":[
#            "D6Ap6_7hEeaRogry0hUlXg"
#         ],
#         "id":"voUQTv9AEeaBXg46-AuF8A",
#         "slug":"leveraging-unstructured-data-dataproc-gcp",
#         "courseMode":"SESSION",
#         "premiumExperienceVariant":"PremiumCourse",
#         "certificates":[
#            "VerifiedCert",
#            "Specialization"
#         ],
#         "name":"Leveraging Unstructured Data with Cloud Dataproc on Google Cloud Platform",
#         "courseStatus":"launched"
#      }
#   ],
#   "paging":{

#   },
#   "linked":{

#   }
# }
#
# ||
# \/
#
# Subscription Price
# https://www.coursera.org/api/s12nDerivatives.v1/5cRd_NmpEeWkogoQ284TMQ?fields=catalogPrice
# Ex.:
# {
#   "elements":[
#      {
#         "catalogPrice":{
#            "amount":49,
#            "productItemId":"Uyd0RjadEeihjwrTk_gDmA",
#            "liableForTax":false,
#            "countryISOCode":"BR",
#            "currencySymbol":"$",
#            "productPriceId":"SpecializationSubscription~Uyd0RjadEeihjwrTk_gDmA~USD~BR",
#            "currencyCode":"USD",
#            "productType":"SpecializationSubscription"
#         },
#         "id":"D6Ap6_7hEeaRogry0hUlXg"
#      }
#   ],
#   "paging":{

#   },
#   "linked":{

#   }
# }
#
# ||
# \/
#
# VerifiedCertificate Pricing Model
# https://www.coursera.org/api/productPrices.v3/VerifiedCertificate~k1EoDdm3EeWpMxLJs6PspQ~USD~US%22

course_id   = pipe_process.data[:course_id]
course_url  = proc { |course_id| "https://www.coursera.org/api/courses.v1/%{course_id}?showHidden=true&fields=id,courseStatus,courseMode,certificates,name,premiumExperienceVariant,s12nIds,plannedLaunchDate,upcomingSessionStartDate" % { course_id: course_id } }
s12n_url    = proc { |s12n_id| "https://www.coursera.org/api/s12nDerivatives.v1/%{s12n_id}?fields=catalogPrice" % { s12n_id: s12n_id } }
vercert_url = proc { |course_id| "https://www.coursera.org/api/productPrices.v3/VerifiedCertificate~%{course_id}~USD~US" % { course_id: course_id } }

pipe_process.accumulator[:url]  = course_url.call(course_id)

call

course_price_payload = pipe_process.accumulator[:payload]

raise "This course has more than one coursera price model" if course_price_payload[:elements].size > 1
raise "This course has no coursera price model" if course_price_payload[:elements].size < 1

course_price_model  = course_price_payload[:elements][0]
course_type         = course_price_model[:courseType]
course_mode         = course_price_model[:courseMode]
premium_experience  = course_price_model[:premiumExperienceVariant]
course_certificates = course_price_model[:certificates]
course_status       = course_price_model[:courseStatus]
planned_launch_date = course_price_model[:plannedLaunchDate]
upcoming_session    = course_price_model[:upcomingSessionStartDate]
subscriptions       = course_price_model[:s12nIds].map do |s12n_id|
  pipe_process.accumulator[:url] = s12n_url.call(s12n_id)

  call

  s12n_payload  = pipe_process.accumulator[:payload][:elements][0]
  catalog_price = s12n_payload[:catalogPrice]
  amount        = catalog_price[:amount]
  currency      = catalog_price[:currencyCode]

  { amount: amount, currency: currency }
end

verified_cert = if course_certificates.include?('VerifiedCert')
  pipe_process.accumulator[:url] = vercert_url.call(course_id)

  call

  vercert_payload = pipe_process.accumulator[:payload][:elements][0]
  amount          = vercert_payload[:amount]
  currency        = vercert_payload[:currencyCode]

  { amount: amount, currency: currency }
end

content = pipe_process.data[:content]
content[:extras] = (content[:extras] || {}).merge({
  price_model: {
    course_type: course_type,
    course_mode: course_mode,
    premium_experience: premium_experience,
    course_certificates: course_certificates,
    course_status: course_status,
    subscriptions: subscriptions,
    verified_certificate: verified_cert,
    planned_launch_date: planned_launch_date,
    upcoming_session: upcoming_session # TODO: verificar se tem data disponivel, senao course_status: unavailable
  }
})

if course_type == "v2.capstone"
  raise Pipe::Error.new(:skipped, 'Capstone Project Course, ignoring creation')
end

free_content = true
paid_content = false
prices       = []

if premium_experience == 'PremiumGrading'
  free_content = true
  paid_content = true

  prices = subscriptions.empty? ? [
    {
      type: 'single_course',
      price: '0.00',
      plan_type: 'regular',
      customer_type: 'individual',
      currency: 'USD'
    }
  ] : (subscriptions.map do |sub|
      {
        type: 'subscription',
        total_price: ('%.2f' % sub[:amount]),
        price: ('%.2f' % sub[:amount]),
        currency: sub[:currency],
        plan_type: 'premium',
        customer_type: 'individual',
        subscription_period: { value: 1, unit: 'months' },
        payment_period: { value: 1, unit: 'months' },
        trial_period: { value: 7, unit: 'days' }
      }
    end)
elsif premium_experience == 'PremiumCourse'
  pipe_process.data[:skip_video] = true
  free_content = false
  paid_content = true
  prices = subscriptions.map do |sub|
    {
      type: 'subscription',
      total_price: ('%.2f' % sub[:amount]),
      price: ('%.2f' % sub[:amount]),
      currency: sub[:currency],
      plan_type: 'premium',
      customer_type: 'individual',
      subscription_period: { value: 1, unit: 'months' },
      payment_period: { value: 1, unit: 'months' },
      trial_period: { value: 7, unit: 'days' }
    }
  end
else # nil ou BaseVariant
  free_content = true
  paid_content = !verified_cert.nil?

  prices = [
    {
      type: 'single_course',
      price: '0.00',
      plan_type: 'regular',
      customer_type: 'individual',
      currency: 'USD'
    }
  ]
end

# status sempre é available mas as sessões não ...
status = 'available'

content[:prices]       = prices
content[:free_content] = free_content
content[:paid_content] = paid_content
content[:status]       = status

pipe_process.data[:content] = content
