#coding: utf-8

class Dislike < ActiveRecord::Base
  belongs_to :dislikeable, polymorphic: true
  belongs_to :user
  validates_presence_of :dislikeable
  validates :user_id, :uniqueness => { :scope => [:dislikeable_type, :dislikeable_id] }, if: :user_id
end
