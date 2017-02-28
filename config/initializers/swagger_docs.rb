class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

if Rails.env.development? || Rails.env.test?
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      # the extension used for the API
      # :api_extension_type => :json,
      # the output location where your .json files are written to
      :api_file_path => "public/apidocs",
      # the URL base path to your API
      :base_path => "http://localhost:3000",
      # if you want to delete all .json files at each generation
      :clean_directory => true,
      # Ability to setup base controller for each api version. Api::V1::SomeController for example.
      # :parent_controller => Api::V1::ApiBaseController,
      # add custom attributes to api-docs
      :attributes => {
        :info => {
          "title" => "Swagger Voters App",
          "description" => "The principal goal for this app is the management of voters and the sections and zones.",
          "contact" => "votanteapp@gmail.com"
        }
      }
    }
  })
else
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      # the extension used for the API
      # :api_extension_type => :json,
      # the output location where your .json files are written to
      :api_file_path => "public/apidocs",
      # the URL base path to your API
      :base_path => "https://votantes-app.herokuapp.com",
      # if you want to delete all .json files at each generation
      :clean_directory => true,
      # Ability to setup base controller for each api version. Api::V1::SomeController for example.
      # :parent_controller => Api::V1::ApiBaseController,
      # add custom attributes to api-docs
      :attributes => {
        :info => {
          "title" => "Swagger Voters App",
          "description" => "The principal goal for this app is the management of voters and the sections and zones.",
          "contact" => "votanteapp@gmail.com"
        }
      }
    }
  })
end
