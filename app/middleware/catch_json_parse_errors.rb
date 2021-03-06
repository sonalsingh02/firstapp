class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['CONTENT_TYPE'] =~ /application\/json/
        error_output = "There was a problem in the JSON you submitted: #{error.class}"
        return [
          400, { "Content-Type" => "application/json" },
          [ { status: "Failure", message: "Incorrect json parameters",code: 500 }.to_json  ]
        ]
      else
        raise error
      end
    end
  end
end