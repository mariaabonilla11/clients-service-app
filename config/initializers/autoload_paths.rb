Rails.application.config.autoload_paths += %W[
  #{Rails.root}/app/domain
  #{Rails.root}/app/use_cases
  #{Rails.root}/app/infrastructure
]
