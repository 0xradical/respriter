class Video::Youtube

  def self.call(params)
   {
     url:           "//youtube.com/embed/#{params.id}?showinfo=0&rel=0&enablejsapi=1",
     thumbnail_url: params.thumbnail_url || "https://img.youtube.com/vi/#{params.id}/mqdefault.jpg",
     embed:         true
   }
  end

end
