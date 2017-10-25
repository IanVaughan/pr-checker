module Models
  class Project
    include MongoMapper::Document

    has_many :merge_requests, class: MergeRequest
    has_many :pipelines, class: Pipeline
  end
end
