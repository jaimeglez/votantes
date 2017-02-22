Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "api/v1/",
    # the URL base path to your API
    # :base_path => "http://votantes-app.herokuapp.com",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # Ability to setup base controller for each api version. Api::V1::SomeController for example.
    :parent_controller => Api::V1::ApiBaseController,
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
