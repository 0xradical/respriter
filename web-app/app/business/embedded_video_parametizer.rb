class EmbeddedVideoParametizer

  def initialize(video_hash)
    @video_struct = OpenStruct.new(video_hash)
  end

  def parametize
    "Video::#{@video_struct.type.camelcase}".constantize.call(@video_struct)
  end

end
