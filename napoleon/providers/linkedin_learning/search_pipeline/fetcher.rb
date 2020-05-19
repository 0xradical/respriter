pipe_process.accumulator[:http].deep_merge!(
  cookies: pipeline.data[:cookie_jar],
  headers: { 'Csrf-Token' => pipeline.data[:jsessionid] },
  dont_encode_params: true
)

call

status_code = pipe_process.accumulator[:status_code]
raise "Something wrong happened, got status code #{status_code}" if status_code != 200

payload = Oj.load(pipe_process.accumulator[:payload]).deep_symbolize_keys

included = payload[:included]
objects = included.group_by do |object|
  object[:$type]
end.map do |type, objects|
  [
    type,
    objects.map do |object|
      [object[:$id], object]
    end.to_h
  ]
end.to_h

courses = objects['com.linkedin.learning.api.ListedCourse'].values rescue []
courses.each do |course|
  course[:welcomeVideo]     = "https://www.lynda.com/player/embed/#{ course[:welcomeVideo].match(/\,(\d+)\)$/)[1] }"
  course[:locale]           = objects['com.linkedin.common.Locale'][ course[:locale] ]
  course[:associatedSkills] = course[ :associatedSkills ].map{ |id| objects[ 'com.linkedin.learning.api.BasicSkill'  ][ id ] }.uniq
  course[:authors]          = course[ :authors          ].map{ |id| objects[ 'com.linkedin.learning.api.BasicAuthor' ][ id ] }.uniq
  course[:url]              = "https://www.linkedin.com/learning/#{course[:slug]}"
end

pipe_process.accumulator = courses.map{ |course| { initial_accumulator: course } }
