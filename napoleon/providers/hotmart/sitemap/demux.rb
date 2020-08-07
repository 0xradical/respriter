# frozen_string_literal: true

document = Nokogiri::XML(pipe_process.accumulator[:payload])

sitemaps = document.css('sitemap loc').map(&:text).map(&:strip).find_all { |url| url.match(%r{https://www.hotmart.com/product/}) }

# accumulator = []
# sitemaps.each do |sitemap| 
#   doc = Nokogiri::XML(open(sitemap))
#   accumulator += doc.css('url loc').map(&:text).map(&:strip).find_all { |url| url.match(%r{https://www.hotmart.com/product/}) }.map { |url| { initial_accumulator: { url: url } } }
# end

accumulator = [{initial_accumulator: {url: "https://www.hotmart.com/product/roi-positivo/L14679478H"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/keysecrets/L4387867N"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-online-de-limpeza-de-pele-1-0-e-2-0/Y15001429X"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/casa-mers-educando-con-amor/T14732863D"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/creando-empresarias-9-semanas-online-3-pagos/C15230207L"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-de-desenho-realista-completo-do-basico-ao-avancado/K15070986A"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-psicossomatica-medicina-tradicional-chinesa/A15232796P"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/mentoria-y-coaching/C14736963J"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/acesso-viva-o-apice-guilherme-machado/Y15243852A"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/tu-primer-info-producto/L15192286D"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/skin-marker-for-botulinum-toxin/U15203685E"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/programa-apimentando-a-hora-h/R15205120C"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/vivendo-a-vida-mais-doce/M14518067V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/gestao-na-pratica/T14964321V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/como-trabalhar-em-cruzeiros/U15101229N"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/hackeando-seu-ingles-para-o-enem/E14956735V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/magic-training-6/H15210540Q"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/el-arte-de-hablar-en-publico/M15238825A"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/como-encontrar-o-trabalho-que-voce-ama/P15170082L"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/segredos-da-carteira-de-motorista/J14917014D"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/como-crear-riqueza-desde-cero-y-generar-conciencia-del-dinero-en-la-nueva-economia/I14993282O"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-intensivo-copywriting-descomplicado/N14927807C"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-de-espanhol-cris-pacino/C15098705V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/upbiz-coop-cooperar-para-evoluir/G15246813V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/softjuri-web-gerenciador-de-processos/P3439680I"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/excel-para-iniciantes-com-carlos-junior/F15093091N"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/concentracao-em-2-horas-aprenda-mais/R14403990H"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/treinamento-labecom-2-0-2/F15076882X"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/matematica-para-concurso-pm/A15011223X"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/teste-susciripcion/S14156987E"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/training-acelerando-utilidades/U15285350Q"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/21-beneficios-de-elegir-una-vida-mas-simple/O15060692E"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/aquietando-a-mente-e-reduzindo-a-ansiedade/W14054519N"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/nutrindo-corpo-e-mente-por-naty-coelho/S14646513M"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/metas-smart/A15180103K"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/brinquedos-caseiros-para-pets/N14926539X"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-on-line-de-edicao-de-videos/M2065031M"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/opinaqui/C15032391V"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-online-de-limpeza-de-pele-1-0-e-2-0/Y15001429X"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/fale-como-um-nativo-aprenda-phrasal-verbs-de-a-z/K14407916P"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-psicossomatica-medicina-tradicional-chinesa/A15232796P"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/curso-de-autoridade-digital-marketing-digital-que-vende-de-verdade/E15058702R"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/conamake/H14316592J"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/como-resolver-o-problema-de-umidade-vinda-do-chao-e-morfo-de-parede/Y14944152R"}},
{initial_accumulator: {url: "https://www.hotmart.com/product/mini-curso-descubra-seu-estilo/U13346802V"}},
]


pipe_process.accumulator = accumulator

call
