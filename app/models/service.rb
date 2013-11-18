class Service < ActiveRecord::Base

  has_attached_file :image
  validates_presence_of :name, :image, :description
  belongs_to :region

  geocoded_by :full_address do |object, results|
    if geo = results.first
      object.latitude = geo.latitude
      object.longitude = geo.longitude
      object.postal_code = geo.postal_code
    end
  end
  after_validation :geocode

  include PgSearch
  pg_search_scope :search, against: [
      [:name, 'A'],
      [:description, 'B'],
      [:address, 'C']
    ],
    using: {tsearch: {dictionary: "portuguese"}},
    ignoring: :accents

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def display_description
    self.description.gsub(/\n/, '<br/>').html_safe
  end

  def full_address
    return self.address unless self.region and not self.address.match(/#{self.region.name}/i)
    "#{self.address} #{self.region.name}".strip
  end

end