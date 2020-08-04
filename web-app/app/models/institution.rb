# frozen_string_literal: true

class Institution
  def id
    '2015cd2a-e842-4d5b-bb54-e6b897cf0a8a'
  end

  def name
    'Google Academy'
  end

  def description
    'Lorem Ipsum ' * 20 + "\n\nIpsum Lorem " + 'Ipsum Lorem ' * 15
  end

  def slug
    'google-academy'
  end

  def url
    'https://google.com'
  end

  def posts
    []
  end

  def courses
    []
  end

  def instructors
    []
  end

  def institution_stats
    OpenStruct.new({
                     indexed_courses:    100,
                     instructors:        200,
                     areas_of_knowledge: 'computer_science',
                     top_countries:      %w[us ca in jp]
                   })
  end

  def institution_pricing
    OpenStruct.new({
                     membership_types: ['subscription'],
                     price_range:      [0, 1000],
                     has_trial?:       true
                   })
  end
end
