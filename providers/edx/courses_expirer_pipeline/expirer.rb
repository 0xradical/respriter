url, alternative_url = pipe_process.accumulator.values_at(:url, :alternative_url)
unique_id            = Digest::SHA1.hexdigest(url)

if Resource.where(dataset_id: pipeline.dataset_id, unique_id: unique_id).exists?
  content = { stale: true }

  if alternative_url.present? && resource = Resource.find_by(dataset_id: pipeline.dataset_id, unique_id: Digest::SHA1.hexdigest(alternative_url))
    content[:alternative_course_id] = resource.id
  end

  pipe_process.accumulator = { kind: :course, unique_id: unique_id, content: content }

  call
else
  raise Pipe::Error.new(:skipped, 'Unavailable course that we never had')
end
