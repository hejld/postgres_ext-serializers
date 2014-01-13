require 'active_record'
require 'minitest/autorun'
require 'test/unit'
require 'mocha/setup'
require 'bourne'
require 'database_cleaner'
unless ENV['CI'] || RUBY_PLATFORM =~ /java/
  require 'byebug'
end
require 'postgres_ext/serializers'

require 'dotenv'
Dotenv.load

ActiveRecord::Base.establish_connection

class Note < ActiveRecord::Base
  has_many :tags
end

class Tag < ActiveRecord::Base
  belongs_to :note
end

class NotesController < ActionController::Base
  def url_options
    {}
  end
end

class NoteSerializer < ActiveModel::Serializer
  attributes :id, :content, :name
  has_many   :tags
  embed      :ids, include: true
end

class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
  embed :ids
end

DatabaseCleaner.strategy = :deletion

class MiniTest::Spec
  class << self
    alias :context :describe
  end

  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end