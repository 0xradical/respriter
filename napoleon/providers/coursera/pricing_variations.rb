# price model
# {
#   :course_mode=>"SESSION",
#   :course_type=>"v2.ondemand",
#   :course_status=>"launched",
#   :subscriptions=>[],
#   :premium_experience=>nil,
#   :course_certificates=>["VerifiedCert"],
#   :verified_certificate=>
#     {
#       :amount=>29,
#       :currency=>"USD"
#     }
# }
def print_price_models(price_models)
  header  = ["Mode","Type","Subs","Premium XP","Certs","VeriCert","Count"]
  longest = 18
  puts header.map{|f| f.center(longest) }.join("|")
  puts header.map{|f| "-"*longest }.join("+")
  price_models.each_pair do |k,v|
    puts (k.map{|i| i.inspect.center(longest) } << (v.inspect.center(longest))).join("|")
  end; nil
end

price_models = Hash.new(0)

Resource.where(dataset_id: "47910b52-3644-11e9-aa2c-0242ac150004").find_each do |r|
  pm = r.content[:extras]&.[](:price_model) || {}
  cm = pm[:course_mode]
  ct = pm[:course_type]
  su = !(pm[:subscriptions].nil? || pm[:subscriptions].empty?)
  pe = pm[:premium_experience]
  cc = !(pm[:course_certificates].nil? || pm[:course_certificates].empty?)
  vc = !(pm[:verified_certificate].nil? || pm[:verified_certificate].empty?)

  k = [cm, ct, su, pe, cc, vc]
  price_models[k] += 1
end

print_price_models(price_models.sort_by{|k,v| -v}.to_h)

#        Mode       |       Type       |       Subs       |    Premium XP    |      Certs       |     VeriCert     |      Count
# ------------------+------------------+------------------+------------------+------------------+------------------+------------------
#     "SESSION"     |  "v2.ondemand"   |       true       | "PremiumGrading" |       true       |       true       |       401
#     "SESSION"     |  "v2.ondemand"   |      false       |       nil        |       true       |       true       |       364
#     "SESSION"     |  "v2.ondemand"   |      false       | "PremiumGrading" |       true       |       true       |       130
#     "SESSION"     |  "v2.ondemand"   |       true       | "PremiumCourse"  |       true       |       true       |        30
#     "SESSION"     |  "v2.capstone"   |       true       | "PremiumGrading" |       true       |       true       |        25
#     "SESSION"     |  "v2.ondemand"   |      false       |       nil        |      false       |      false       |        22
#     "SESSION"     |  "v2.ondemand"   |      false       |  "BaseVariant"   |       true       |       true       |        21
#     "SESSION"     |  "v2.ondemand"   |      false       |  "BaseVariant"   |      false       |      false       |        1
#     "SESSION"     |  "v2.capstone"   |      false       |       nil        |       true       |       true       |        1


###### Princing Model ######

# Subscription => Pricing Variavel, 7 dias de trial
# Single Course
# As vezes, certificates = [] ta ligado com launchdate indisponivel

### PremiumXP Nulo implies no subscription model
# PremiumXP Nulo
#   * Capstone: Edge case, olhar launchdate
#   * Resto: Free content = true, Paid content: Tem as opções de comprar ou não certificado, olhar Certs ou Verified Certificate
### BaseVariant == PremiumXP Nulo
### Capstone (free_content: false, paid_content: true) @NÃO INCLUIR@
#   * Tem que concluir com sucesso todos os outros cursos da especialização
#   * É um projeto final
#   * Não tem a opção de auditar
#   * Modelo de subscription
### PremiumGrading (free_content: true, paid_content: true)
#   * De graça para auditar
#   * Paga para ter certificado ou graded assessment
#   * Modelo subscription ou single course (subs true ou false)
### PremiumCourse (free_content: false, paid_content: true)
#   * Não é de graça para auditar
#   * Paga para ter certificado
#   * Modelo de subscription