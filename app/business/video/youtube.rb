class Video::Youtube

  def self.call(video_struct)
   { url: "//youtube.com/embed/#{video_struct.id}?showinfo=0&rel=0&enablejsapi=1", mode: 'iframe' }
  end

end
