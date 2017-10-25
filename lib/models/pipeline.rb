module Models
  class Pipeline
    include MongoMapper::EmbeddedDocument
    
    has_many :jobs, class: Job
  end
end
