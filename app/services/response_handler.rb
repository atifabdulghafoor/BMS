module ResponseHandler
  def handle_exception
    yield
  rescue StandardError => e
    handle_response(message: e.message)
    nil
  end

  def handle_response(success: false, message:)
    @response = {
      success: success,
      message: message,
      status: success ? :ok : :unprocessable_entity 
    }
  end

  def success?
    !!@response[:success]
  end

  def failure?
    @response[:success]
  end
end