class ErrorSerializer
  def self.login_error(error)
    { errors:
        [
          { title: error }
        ]
    }
  end
end
