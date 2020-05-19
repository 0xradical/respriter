# API endpoints:
#   Course
#     GET https://www.edx.org/api/v1/catalog/courses/:course_id
#       https://www.edx.org/api/v1/catalog/courses/TrinityX+T001
#     GET https://www.edx.org/api/catalog/v2/courses/:course_run_id
#       https://www.edx.org/api/catalog/v2/courses/course-v1:TrinityX+T001+3T2015
#   Course Runs
#     GET https://www.edx.org/api/v1/catalog/course_runs/:course_run_id
#       https://www.edx.org/api/v1/catalog/course_runs/course-v1:TrinityX+T001+3T2015
#   Enrollments
#     GET https://courses.edx.org/api/enrollment/v1/course/:course_run_id?include_expired=1
#       https://courses.edx.org/api/enrollment/v1/course/course-v1:TrinityX+T001+3T2015?include_expired=1
call

payload     = pipe_process.accumulator[:payload]
status_code = pipe_process.accumulator[:status_code]
json_ld     = pipe_process.accumulator[:json_ld]&.first
document    = Nokogiri::HTML(payload)

if pipe_process.accumulator[:redirected]
  url = pipe_process.accumulator[:current_url]

  PipeProcess.create({
    pipeline_id: pipeline.data[:courses_expirer_pipeline_id],
    initial_accumulator: pipe_process.initial_accumulator.merge(url: pipe_process.initial_accumulator[:url], alternative_url: url)
  })
else
  url           = pipe_process.initial_accumulator[:url]
  course_run_id = document.css('main#course-info-page').first&.attribute('data-course-id')&.value

  if course_run_id
    PipeProcess.create({
      pipeline_id: pipeline.data[:api_courses_pipeline_id],
      initial_accumulator: {
        url: 'https://www.edx.org/api/v1/catalog/course_runs/' + course_run_id
      },
      data: {
        json_ld: json_ld,
        course_run_id: course_run_id,
        course_url: url
      }
    })
  else
    PipeProcess.create({
      pipeline_id: pipeline.data[:manual_courses_pipeline_id],
      initial_accumulator: { url: url }
    })
  end
end
