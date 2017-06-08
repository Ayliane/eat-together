class Restaurant < ApplicationRecord
  include PgSearch

  pg_search_scope :search, against: [:name, :address], using: :tsearch
end
